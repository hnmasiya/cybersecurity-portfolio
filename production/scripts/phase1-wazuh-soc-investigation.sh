#!/usr/bin/env bash

set -u
set -o pipefail

# Preserve the real repository when executed with sudo.
if [[ -n "${SUDO_USER:-}" ]]; then
    REAL_HOME="$(getent passwd "${SUDO_USER}" | cut -d: -f6)"
else
    REAL_HOME="${HOME}"
fi

PROJECT_ROOT="${REAL_HOME}/cybersecurity-portfolio"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

REPORT_DIR="${PROJECT_ROOT}/reports"
EVIDENCE_DIR="${PROJECT_ROOT}/evidence/phase1-wazuh-soc-investigation-${TIMESTAMP}"
REPORT="${REPORT_DIR}/phase1-wazuh-soc-investigation-${TIMESTAMP}.txt"

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

section "PHASE 1 LAB 3 - SOC ALERT INVESTIGATION"

log "Investigation timestamp : ${TIMESTAMP}"
log "Repository              : ${PROJECT_ROOT}"
log "Evidence directory      : ${EVIDENCE_DIR}"

section "1. ENVIRONMENT VALIDATION"

if command -v docker >/dev/null 2>&1; then
    pass "Docker CLI available."
else
    fail "Docker CLI unavailable."
    exit 1
fi

MANAGER_CONTAINER="$(
    docker ps \
        --filter 'name=single-node-wazuh.manager' \
        --format '{{.Names}}' \
        | head -n 1
)"

if [[ -n "${MANAGER_CONTAINER}" ]]; then
    pass "Wazuh manager detected: ${MANAGER_CONTAINER}"
else
    fail "Wazuh manager container not detected."
    exit 1
fi

if docker exec "${MANAGER_CONTAINER}" \
    test -f /var/ossec/logs/alerts/alerts.json; then
    pass "Manager alerts.json available."
else
    fail "Manager alerts.json unavailable."
    exit 1
fi

if command -v jq >/dev/null 2>&1; then
    pass "jq available for structured alert analysis."
else
    fail "jq is required for structured SOC investigation."
    exit 1
fi

section "2. COLLECT RECENT ALERT DATA"

ALERT_SOURCE="${EVIDENCE_DIR}/alerts-source.json"

docker exec "${MANAGER_CONTAINER}" \
    tail -n 250 /var/ossec/logs/alerts/alerts.json \
    > "${ALERT_SOURCE}" 2>/dev/null || true

if [[ -s "${ALERT_SOURCE}" ]]; then
    pass "Recent Wazuh alert data collected."
else
    fail "Unable to collect Wazuh alert data."
    exit 1
fi

section "3. ALERT INVENTORY"

ALERT_INVENTORY="${EVIDENCE_DIR}/alert-inventory.tsv"

printf '%s\n' \
    "timestamp	agent_id	agent_name	rule_id	level	description	decoder	location" \
    > "${ALERT_INVENTORY}"

jq -r '
[
  .timestamp // "N/A",
  .agent.id // "N/A",
  .agent.name // "N/A",
  .rule.id // "N/A",
  .rule.level // "N/A",
  (.rule.description // "N/A" | gsub("[\t\r\n]"; " ")),
  .decoder.name // "N/A",
  .location // "N/A"
] | @tsv
' "${ALERT_SOURCE}" 2>/dev/null \
    >> "${ALERT_INVENTORY}"

ALERT_COUNT="$(
    tail -n +2 "${ALERT_INVENTORY}" | wc -l
)"

log "Alerts analysed: ${ALERT_COUNT}"

if (( ALERT_COUNT > 0 )); then
    pass "Alert inventory created."
else
    warn "No alerts available for investigation."
fi

section "4. RULE DISTRIBUTION"

RULE_SUMMARY="${EVIDENCE_DIR}/rule-summary.txt"

{
    printf '%s\n' "Rule ID | Count | Description"
    printf '%s\n' "----------------------------------------------"

    jq -r '
        [
          (.rule.id // "N/A"),
          (.rule.description // "N/A" | gsub("[\r\n]"; " "))
        ] | @tsv
    ' "${ALERT_SOURCE}" 2>/dev/null \
    | sort \
    | uniq -c \
    | sort -nr
} | tee "${RULE_SUMMARY}"

pass "Rule distribution generated."

section "5. SEVERITY DISTRIBUTION"

SEVERITY_SUMMARY="${EVIDENCE_DIR}/severity-summary.txt"

{
    printf '%s\n' "Severity Level | Count"
    printf '%s\n' "-----------------------"

    jq -r '.rule.level // empty' "${ALERT_SOURCE}" 2>/dev/null \
        | sort -n \
        | uniq -c \
        | awk '{print $2 " | " $1}'
} | tee "${SEVERITY_SUMMARY}"

pass "Severity distribution generated."

section "6. AGENT / HOST CORRELATION"

AGENT_SUMMARY="${EVIDENCE_DIR}/agent-summary.txt"

{
    printf '%s\n' "Agent ID | Agent Name | Alert Count"
    printf '%s\n' "-----------------------------------"

    jq -r '
        [
          (.agent.id // "N/A"),
          (.agent.name // "N/A")
        ] | @tsv
    ' "${ALERT_SOURCE}" 2>/dev/null \
    | sort \
    | uniq -c \
    | awk '{print $2 " | " $3 " | " $1}'
} | tee "${AGENT_SUMMARY}"

pass "Agent correlation generated."

section "7. TIMELINE"

TIMELINE="${EVIDENCE_DIR}/timeline.tsv"

printf '%s\n' \
    "timestamp	agent	rule	level	description	location" \
    > "${TIMELINE}"

jq -r '
[
  (.timestamp // "N/A"),
  (.agent.name // "N/A"),
  (.rule.id // "N/A"),
  (.rule.level // "N/A"),
  (.rule.description // "N/A" | gsub("[\t\r\n]"; " ")),
  (.location // "N/A")
] | @tsv
' "${ALERT_SOURCE}" 2>/dev/null \
    | sort \
    >> "${TIMELINE}"

pass "Chronological alert timeline generated."

section "8. INVESTIGATE SUDO / PRIVILEGE EVENTS"

SUDO_EVIDENCE="${EVIDENCE_DIR}/sudo-events.json"

jq -c '
select(
    (.rule.id == "5402") or
    (.rule.description // "" | ascii_downcase | test("sudo|root|privilege"))
)
' "${ALERT_SOURCE}" 2>/dev/null \
    > "${SUDO_EVIDENCE}"

SUDO_COUNT="$(wc -l < "${SUDO_EVIDENCE}")"

log "Privilege-related alerts: ${SUDO_COUNT}"

if (( SUDO_COUNT > 0 )); then
    pass "Privilege-related alert evidence identified."
else
    warn "No privilege-related alerts found in collected data."
fi

section "9. INVESTIGATE PAM SESSION EVENTS"

PAM_EVIDENCE="${EVIDENCE_DIR}/pam-session-events.json"

jq -c '
select(
    (.rule.id == "5501") or
    (.rule.id == "5502") or
    (.rule.description // "" | ascii_downcase | test("pam|session"))
)
' "${ALERT_SOURCE}" 2>/dev/null \
    > "${PAM_EVIDENCE}"

PAM_COUNT="$(wc -l < "${PAM_EVIDENCE}")"

log "PAM session alerts: ${PAM_COUNT}"

if (( PAM_COUNT > 0 )); then
    pass "PAM session evidence identified."
else
    warn "No PAM session alerts found in collected data."
fi

section "10. JOURNAL CORRELATION"

JOURNAL_EVIDENCE="${EVIDENCE_DIR}/journal-correlation.txt"

journalctl --since "30 minutes ago" 2>/dev/null \
    | grep -Ei \
        'sudo|pam_unix|session opened|session closed|authentication' \
    | tail -n 200 \
    | tee "${JOURNAL_EVIDENCE}" \
    || true

if [[ -s "${JOURNAL_EVIDENCE}" ]]; then
    pass "Relevant journal evidence collected."
else
    warn "No matching journal evidence found."
fi

section "11. AUDITD CORRELATION"

AUDIT_EVIDENCE="${EVIDENCE_DIR}/auditd-correlation.txt"

ausearch -ts recent \
    -m EXECVE,PROCTITLE,SYSCALL,USER_CMD 2>/dev/null \
    | tail -n 250 \
    | tee "${AUDIT_EVIDENCE}" \
    || true

if [[ -s "${AUDIT_EVIDENCE}" ]]; then
    pass "Auditd evidence collected."
else
    warn "No recent Auditd evidence collected."
fi

section "12. PROCESS CONTEXT"

PROCESS_EVIDENCE="${EVIDENCE_DIR}/process-context.txt"

{
    printf '%s\n' "Investigation host:"
    hostname
    printf '\n%s\n' "Current user:"
    id
    printf '\n%s\n' "Recent processes:"
    ps -eo user,pid,ppid,etime,comm,args --sort=-etime | head -n 80
} | tee "${PROCESS_EVIDENCE}"

pass "Process context captured."

section "13. NETWORK CONTEXT"

NETWORK_EVIDENCE="${EVIDENCE_DIR}/network-context.txt"

{
    printf '%s\n' "Listening sockets:"
    ss -tulpen 2>/dev/null || true

    printf '\n%s\n' "Established connections:"
    ss -tunap 2>/dev/null | head -n 100 || true
} | tee "${NETWORK_EVIDENCE}"

pass "Network context captured."

section "14. MITRE ATT&CK MAPPING"

MITRE_MAPPING="${EVIDENCE_DIR}/mitre-attack-mapping.txt"

cat > "${MITRE_MAPPING}" <<'MAP'
MITRE ATT&CK MAPPING
=====================

Important:
Mappings below are investigative hypotheses based on observed telemetry.
They are not asserted as confirmed adversary behavior.

Observed alert: Wazuh rule 5402
Description: Successful sudo to ROOT executed.

Potential ATT&CK relevance:
- T1548.003 - Abuse Elevation Control Mechanism: Sudo and Sudo Caching

Assessment:
The telemetry demonstrates successful sudo elevation to root.
This is consistent with the ATT&CK technique above, but the observed
activity was intentionally generated as part of a controlled lab test.
It must therefore NOT be presented as malicious activity.

Observed alerts: Wazuh rules 5501 / 5502
Descriptions:
- PAM: Login session opened.
- PAM: Login session closed.

Potential ATT&CK relevance:
- Account/session activity provides authentication and session context.
- No ATT&CK technique is asserted solely from these two alerts.

Assessment:
The alerts demonstrate session lifecycle telemetry and can be used
to correlate privilege activity with a user session.

Conclusion:
The evidence demonstrates detection and investigation capability.
It does not demonstrate an actual compromise or adversary intrusion.
MAP

cat "${MITRE_MAPPING}"

pass "MITRE ATT&CK assessment generated with lab-context limitations."

section "15. INVESTIGATION FINDINGS"

FINDINGS="${EVIDENCE_DIR}/investigation-findings.txt"

cat > "${FINDINGS}" <<FINDINGS_EOF
SOC INVESTIGATION FINDINGS
==========================

Incident classification:
Controlled security telemetry validation / lab activity.

Host:
normann-ThinkPad-X260

Observed activity:
1. Successful sudo execution to root.
2. PAM session opened.
3. PAM session closed.

Wazuh evidence:
- Rule 5402
- Rule 5501
- Rule 5502

Severity:
All three observed alerts were Wazuh level 3 in the controlled validation.

Analyst interpretation:
The events form a coherent privilege/session sequence.
The telemetry demonstrates that Wazuh can identify and forward
privilege-related and authentication/session events to the manager.

Security conclusion:
No compromise is established by this evidence.
The activity was deliberately generated for SOC validation.

Recommended analyst follow-up:
- Correlate the originating user and terminal/session.
- Review Auditd EXECVE records for the associated command.
- Review surrounding authentication events.
- Establish whether the activity is expected for the account.
- Escalate only if surrounding evidence indicates unauthorized activity.
FINDINGS_EOF

cat "${FINDINGS}"

pass "Investigation findings documented."

section "16. EVIDENCE MANIFEST"

MANIFEST="${EVIDENCE_DIR}/evidence-manifest.txt"

find "${EVIDENCE_DIR}" \
    -maxdepth 1 \
    -type f \
    -printf '%f\n' \
    | sort \
    | tee "${MANIFEST}"

FILE_COUNT="$(find "${EVIDENCE_DIR}" -maxdepth 1 -type f | wc -l)"

log
log "Evidence files created: ${FILE_COUNT}"

if (( FILE_COUNT >= 10 )); then
    pass "Investigation evidence bundle is populated."
else
    warn "Evidence bundle contains fewer than expected files."
fi

section "17. FINAL ASSESSMENT"

log "Investigation alerts analysed : ${ALERT_COUNT}"
log "Privilege alerts              : ${SUDO_COUNT}"
log "PAM session alerts            : ${PAM_COUNT}"
log "Evidence files                : ${FILE_COUNT}"

log
log "This investigation represents controlled laboratory activity."
log "It must not be presented as evidence of an actual compromise."

log
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
log "============================================================"
log "END OF PHASE 1 LAB 3"
log "============================================================"
