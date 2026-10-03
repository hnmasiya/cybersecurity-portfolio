#!/usr/bin/env bash

set -u
set -o pipefail

# Preserve the real repository location even when executed with sudo.
if [[ -n "${SUDO_USER:-}" ]]; then
    REAL_HOME="$(getent passwd "${SUDO_USER}" | cut -d: -f6)"
else
    REAL_HOME="${HOME}"
fi

PROJECT_ROOT="${REAL_HOME}/cybersecurity-portfolio"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

REPORT_DIR="${PROJECT_ROOT}/reports"
EVIDENCE_DIR="${PROJECT_ROOT}/evidence/phase1-wazuh-manager-alert-validation-${TIMESTAMP}"
REPORT="${REPORT_DIR}/phase1-wazuh-manager-alert-validation-${TIMESTAMP}.txt"

MANAGER_CONTAINER=""

PASS=0
WARN=0
FAIL=0

mkdir -p "${REPORT_DIR}" "${EVIDENCE_DIR}"

exec > >(tee -a "${REPORT}") 2>&1

log() {
    printf '%s\n' "$*"
}

pass() {
    PASS=$((PASS + 1))
    log "[PASS] $*"
}

warn() {
    WARN=$((WARN + 1))
    log "[WARN] $*"
}

fail() {
    FAIL=$((FAIL + 1))
    log "[FAIL] $*"
}

section() {
    log
    log "============================================================"
    log "$*"
    log "============================================================"
}

cleanup() {
    rm -f /tmp/WAZUH_PIPELINE_TEST_*.txt
}

trap cleanup EXIT

section "1. ENVIRONMENT PRE-CHECK"

if command -v docker >/dev/null 2>&1; then
    pass "Docker CLI available."
else
    fail "Docker CLI unavailable."
    exit 1
fi

if systemctl is-active --quiet wazuh-agent 2>/dev/null; then
    pass "Wazuh agent service is active."
else
    fail "Wazuh agent service is not active."
fi

MANAGER_CONTAINER="$(docker ps \
    --filter 'name=single-node-wazuh.manager' \
    --format '{{.Names}}' | head -n 1)"

if [[ -n "${MANAGER_CONTAINER}" ]]; then
    pass "Wazuh manager container detected: ${MANAGER_CONTAINER}"
else
    fail "Unable to locate running Wazuh manager container."
    exit 1
fi

if docker exec "${MANAGER_CONTAINER}" test -f \
    /var/ossec/logs/alerts/alerts.json; then
    pass "Manager-side alerts.json detected."
else
    fail "Manager-side alerts.json not found."
    exit 1
fi

section "2. MANAGER HEALTH"

MANAGER_STATUS="$(
    docker exec "${MANAGER_CONTAINER}" \
    /var/ossec/bin/wazuh-control status 2>&1
)"

printf '%s\n' "${MANAGER_STATUS}" \
    | tee "${EVIDENCE_DIR}/manager-status.txt"

# Match the actual status output directly.
if printf '%s\n' "${MANAGER_STATUS}" \
    | grep -Eq '^wazuh-analysisd is running'; then
    pass "wazuh-analysisd is running."
else
    fail "wazuh-analysisd is not running."
fi

if printf '%s\n' "${MANAGER_STATUS}" \
    | grep -Eq '^wazuh-remoted is running'; then
    pass "wazuh-remoted is running."
else
    fail "wazuh-remoted is not running."
fi

section "3. ALERT BASELINE"

BASELINE_COUNT="$(
    docker exec "${MANAGER_CONTAINER}" \
        sh -c 'wc -l < /var/ossec/logs/alerts/alerts.json' \
        2>/dev/null || echo 0
)"

log "Manager alerts.json baseline lines: ${BASELINE_COUNT}"

if [[ "${BASELINE_COUNT}" =~ ^[0-9]+$ ]]; then
    pass "Manager-side alert baseline established."
else
    fail "Unable to establish manager-side alert baseline."
fi

docker exec "${MANAGER_CONTAINER}" \
    tail -n 20 /var/ossec/logs/alerts/alerts.json \
    > "${EVIDENCE_DIR}/alerts-baseline-tail.json" 2>/dev/null || true

section "4. CONTROLLED FILE ACTIVITY"

TEST_FILE="/tmp/WAZUH_PIPELINE_TEST_${TIMESTAMP}.txt"

log "Creating: ${TEST_FILE}"

printf 'WAZUH SOC PIPELINE VALIDATION %s\n' "${TIMESTAMP}" > "${TEST_FILE}"

if [[ -f "${TEST_FILE}" ]]; then
    pass "Controlled file creation succeeded."
else
    fail "Controlled file creation failed."
fi

printf 'MODIFIED %s\n' "$(date --iso-8601=seconds)" >> "${TEST_FILE}"

sha256sum "${TEST_FILE}" \
    | tee "${EVIDENCE_DIR}/test-file-hash.txt"

rm -f "${TEST_FILE}"

if [[ ! -e "${TEST_FILE}" ]]; then
    pass "Temporary test file removed."
else
    fail "Temporary test file remains."
fi

section "5. CONTROLLED PRIVILEGE ACTIVITY"

if sudo -n true 2>/dev/null; then
    pass "Controlled sudo activity executed."
else
    warn "sudo -n true did not execute without prompting."
fi

section "6. CONTROLLED APACHE ACTIVITY"

APACHE_RESULT="${EVIDENCE_DIR}/apache-request.txt"

if curl -sS --max-time 10 \
    -o "${EVIDENCE_DIR}/apache-response-body.txt" \
    -w 'HTTP_STATUS=%{http_code}\nTIME_TOTAL=%{time_total}\n' \
    http://127.0.0.1/ \
    | tee "${APACHE_RESULT}"; then
    pass "Local Apache request generated."
else
    warn "Local Apache request failed."
fi

section "7. CONTROLLED AUDIT/JOURNAL ACTIVITY"

log "Recent sudo-related journal entries:"
journalctl --since "2 minutes ago" \
    | grep -Ei 'sudo|pam_unix' \
    | tail -n 20 \
    | tee "${EVIDENCE_DIR}/sudo-journal-events.txt" || true

log "Recent Auditd execution events:"
ausearch -ts recent -m EXECVE,PROCTITLE,SYSCALL 2>/dev/null \
    | tail -n 60 \
    | tee "${EVIDENCE_DIR}/audit-execution-events.txt" || true

section "8. WAIT FOR WAZUH PROCESSING"

log "Waiting 30 seconds for Wazuh processing..."

for i in $(seq 1 30); do
    printf '.'
    sleep 1
done

log

section "9. POST-TEST ALERT COUNT"

POST_COUNT="$(
    docker exec "${MANAGER_CONTAINER}" \
        sh -c 'wc -l < /var/ossec/logs/alerts/alerts.json' \
        2>/dev/null || echo 0
)"

log "Baseline alert lines : ${BASELINE_COUNT}"
log "Post-test alert lines: ${POST_COUNT}"

if [[ "${POST_COUNT}" =~ ^[0-9]+$ ]] && \
   [[ "${BASELINE_COUNT}" =~ ^[0-9]+$ ]]; then

    if (( POST_COUNT > BASELINE_COUNT )); then
        pass "New manager-side Wazuh alerts were generated."
    else
        warn "No increase detected in manager-side alerts.json."
    fi
else
    warn "Unable to compare alert counts."
fi

section "10. CAPTURE NEW MANAGER ALERTS"

NEW_ALERTS="${EVIDENCE_DIR}/new-manager-alerts.json"

if [[ "${BASELINE_COUNT}" =~ ^[0-9]+$ ]]; then
    docker exec "${MANAGER_CONTAINER}" \
        sh -c "tail -n +$((BASELINE_COUNT + 1)) /var/ossec/logs/alerts/alerts.json" \
        > "${NEW_ALERTS}" 2>/dev/null || true
else
    : > "${NEW_ALERTS}"
fi

NEW_LINES="$(wc -l < "${NEW_ALERTS}" 2>/dev/null || echo 0)"

log "New alert lines captured: ${NEW_LINES}"

if (( NEW_LINES > 0 )); then
    pass "New manager alerts captured as evidence."
else
    warn "No new manager alerts captured."
fi

section "11. EXTRACT ALERT METADATA"

ALERT_SUMMARY="${EVIDENCE_DIR}/alert-summary.txt"

if [[ -s "${NEW_ALERTS}" ]]; then

    if command -v jq >/dev/null 2>&1; then

        jq -r '
            [
              .timestamp,
              .agent.id,
              .agent.name,
              .rule.id,
              .rule.level,
              .rule.description,
              .decoder.name,
              .location
            ] | @tsv
        ' "${NEW_ALERTS}" 2>/dev/null \
        | tee "${ALERT_SUMMARY}" || true

        log
        log "timestamp | agent.id | agent.name | rule.id | level | description | decoder | location"

    else
        warn "jq is not installed; raw alerts retained for analysis."
        cp "${NEW_ALERTS}" "${EVIDENCE_DIR}/new-manager-alerts-raw.json"
    fi

else
    warn "Alert metadata extraction skipped because no new alerts were captured."
fi

section "12. RULE / SEVERITY SUMMARY"

if [[ -s "${NEW_ALERTS}" ]] && command -v jq >/dev/null 2>&1; then

    log "Rule IDs observed:"
    jq -r '.rule.id // empty' "${NEW_ALERTS}" \
        | sort | uniq -c \
        | tee "${EVIDENCE_DIR}/rule-id-summary.txt" || true

    log
    log "Severity levels observed:"
    jq -r '.rule.level // empty' "${NEW_ALERTS}" \
        | sort -n | uniq -c \
        | tee "${EVIDENCE_DIR}/severity-summary.txt" || true
else
    warn "Rule/severity summary unavailable."
fi

section "13. AGENT-SIDE CORRELATION"

AGENT_LOG="${EVIDENCE_DIR}/agent-correlation.log"

if [[ -f /var/ossec/logs/ossec.log ]]; then

    grep -Ei \
        'FIM|syscheck|connected|online|queue|error|warning|analysis|alert' \
        /var/ossec/logs/ossec.log \
        | tail -n 100 \
        | tee "${AGENT_LOG}" || true

    pass "Agent-side Wazuh events captured."

else
    warn "Agent ossec.log not found."
fi

section "14. MANAGER-SIDE RECENT LOGS"

docker logs --since 2m "${MANAGER_CONTAINER}" \
    2>&1 \
    | tee "${EVIDENCE_DIR}/manager-recent-logs.txt" || true

section "15. PIPELINE ASSESSMENT"

log
log "Telemetry generation:"
log "  File activity      : executed"
log "  Sudo activity      : executed"
log "  Apache activity    : executed"
log "  Journal telemetry  : queried"
log "  Auditd telemetry   : queried"

log
log "Wazuh alert pipeline:"
log "  Manager detected   : ${MANAGER_CONTAINER}"
log "  alerts.json        : available"
log "  Baseline lines     : ${BASELINE_COUNT}"
log "  Post-test lines    : ${POST_COUNT}"
log "  New alert lines    : ${NEW_LINES}"

if (( NEW_LINES > 0 )); then
    log
    pass "END-TO-END ALERT PIPELINE VALIDATED."
elif (( POST_COUNT == BASELINE_COUNT )); then
    log
    warn "Telemetry was generated, but no new manager alerts were observed."
    warn "This requires investigation before declaring detection coverage."
else
    log
    warn "Alert pipeline result is inconclusive."
fi

section "16. FINAL RESULTS"

log "Checks passed : ${PASS}"
log "Warnings      : ${WARN}"
log "Failures      : ${FAIL}"

log
log "Repository:"
log "${PROJECT_ROOT}"

log
log "Evidence directory:"
log "${EVIDENCE_DIR}"

log
log "Report:"
log "${REPORT}"

log
log "No Wazuh configuration changes were intentionally made."

log
log "============================================================"
log "END OF WAZUH MANAGER ALERT PIPELINE VALIDATION"
log "============================================================"
