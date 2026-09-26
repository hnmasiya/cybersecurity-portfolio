#!/usr/bin/env bash
set -uo pipefail

START_TS="$(date --iso-8601=seconds)"
STAMP="$(date +%Y%m%d-%H%M%S)"

if [[ -n "${SUDO_USER:-}" ]]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER="$(id -un)"
fi

REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6 2>/dev/null || true)"
[[ -z "$REAL_HOME" ]] && REAL_HOME="$HOME"

REPO="${REAL_HOME}/cybersecurity-portfolio"
[[ ! -d "$REPO" ]] && REPO="$(pwd)"

REPORT_DIR="$REPO/reports"
EVIDENCE_DIR="$REPO/evidence/phase1-wazuh-incident-response-simulation-${STAMP}"
REPORT_FILE="$REPORT_DIR/phase1-wazuh-incident-response-simulation-${STAMP}.txt"

mkdir -p "$REPORT_DIR" "$EVIDENCE_DIR"

PASS=0
WARN=0
FAIL=0

log() {
    printf '%s\n' "$*" | tee -a "$REPORT_FILE"
}

section() {
    printf '\n================================================================\n' | tee -a "$REPORT_FILE"
    printf '%s\n' "$*" | tee -a "$REPORT_FILE"
    printf '================================================================\n' | tee -a "$REPORT_FILE"
}

pass() {
    PASS=$((PASS + 1))
    printf '[PASS] %s\n' "$*" | tee -a "$REPORT_FILE"
}

warn() {
    WARN=$((WARN + 1))
    printf '[WARN] %s\n' "$*" | tee -a "$REPORT_FILE"
}

fail() {
    FAIL=$((FAIL + 1))
    printf '[FAIL] %s\n' "$*" | tee -a "$REPORT_FILE"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

INCIDENT_ID="LAB4-${STAMP}"
LAB_ROOT="/tmp/${INCIDENT_ID}"
LAB_FILE="${LAB_ROOT}/incident-marker.txt"

section "1. ENVIRONMENT VALIDATION"

if [[ -d "$REPO/.git" ]]; then
    pass "Git repository detected: $REPO"
else
    fail "Git repository not detected"
fi

if command_exists docker && docker info >/dev/null 2>&1; then
    pass "Docker is available and accessible"
else
    fail "Docker unavailable"
fi

WAZUH_MANAGER="$(docker ps --format '{{.Names}}' 2>/dev/null | grep '^single-node-wazuh.manager-' | head -1 || true)"

if [[ -n "$WAZUH_MANAGER" ]]; then
    pass "Wazuh manager detected: $WAZUH_MANAGER"
else
    fail "Wazuh manager container not detected"
fi

section "2. INCIDENT INITIALIZATION"

mkdir -p "$LAB_ROOT"

cat > "$LAB_FILE" <<EOF
LAB4 CONTROLLED INCIDENT MARKER
Incident ID: $INCIDENT_ID
Created: $START_TS
Purpose: Controlled SOC incident-response simulation
Owner: $REAL_USER
This file is a temporary lab artifact.
EOF

chmod 600 "$LAB_FILE"

log "Incident ID: $INCIDENT_ID"
log "Lab artifact: $LAB_FILE"

if [[ -f "$LAB_FILE" ]]; then
    pass "Controlled incident artifact created"
else
    fail "Controlled incident artifact was not created"
fi

section "3. PRE-ACTIVITY BASELINE"

date --iso-8601=seconds > "$EVIDENCE_DIR/baseline-timestamp.txt"

ps -eo pid,ppid,user,lstart,comm,args --sort=pid \
    > "$EVIDENCE_DIR/baseline-processes.txt" 2>&1 || true

ss -tulpen \
    > "$EVIDENCE_DIR/baseline-listening-sockets.txt" 2>&1 || true

ip -brief address show \
    > "$EVIDENCE_DIR/baseline-network.txt" 2>&1 || true

if command_exists journalctl; then
    journalctl -n 100 --no-pager \
        > "$EVIDENCE_DIR/baseline-journal.txt" 2>&1 || true
fi

pass "Pre-activity endpoint baseline captured"

section "4. CONTROLLED SECURITY ACTIVITY"

ACTIVITY_START="$(date --iso-8601=seconds)"

{
    echo "INCIDENT_ID=$INCIDENT_ID"
    echo "ACTIVITY_START=$ACTIVITY_START"
    echo "USER=$REAL_USER"
    echo "HOST=$(hostname)"
    echo "UID=$(id -u)"
    echo "PWD=$(pwd)"
    echo "ACTION=controlled privileged command execution"
} >> "$EVIDENCE_DIR/generated-activity.txt"

if sudo -n true >/dev/null 2>&1; then
    sudo -n sh -c "printf 'LAB4 privileged validation\n' >> '$LAB_FILE'"
    SUDO_STATUS=$?
else
    sudo sh -c "printf 'LAB4 privileged validation\n' >> '$LAB_FILE'"
    SUDO_STATUS=$?
fi

ACTIVITY_END="$(date --iso-8601=seconds)"

{
    echo "ACTIVITY_END=$ACTIVITY_END"
    echo "SUDO_EXIT_CODE=$SUDO_STATUS"
} >> "$EVIDENCE_DIR/generated-activity.txt"

if [[ "$SUDO_STATUS" -eq 0 ]]; then
    pass "Controlled privileged activity completed"
else
    fail "Controlled privileged activity failed"
fi

sync

section "5. IMMEDIATE ACTIVITY EVIDENCE"

cat "$LAB_FILE" \
    > "$EVIDENCE_DIR/lab-artifact-state.txt" 2>&1 || true

ps -eo pid,ppid,user,lstart,comm,args --sort=lstart \
    > "$EVIDENCE_DIR/post-activity-processes.txt" 2>&1 || true

ss -tulpen \
    > "$EVIDENCE_DIR/post-activity-listening-sockets.txt" 2>&1 || true

if command_exists journalctl; then
    journalctl --since "$ACTIVITY_START" --no-pager \
        > "$EVIDENCE_DIR/post-activity-journal.txt" 2>&1 || true
fi

if command_exists ausearch; then
    ausearch -m USER_CMD,USER_START,USER_END,EXECVE,SYSCALL -ts recent -i \
        > "$EVIDENCE_DIR/post-activity-auditd.txt" 2>&1 || true
fi

pass "Post-activity endpoint evidence captured"

section "6. WAZUH ALERT COLLECTION"

ALERT_FILE="$EVIDENCE_DIR/wazuh-alerts.jsonl"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "tail -n 5000 /var/ossec/logs/alerts/alerts.json" \
        > "$ALERT_FILE" 2>/dev/null || true

    ALERT_COUNT="$(wc -l < "$ALERT_FILE" 2>/dev/null || echo 0)"

    if [[ "$ALERT_COUNT" -gt 0 ]]; then
        pass "Captured $ALERT_COUNT Wazuh manager alerts"
    else
        warn "No Wazuh alerts were captured"
    fi
else
    fail "Cannot collect Wazuh alerts without manager"
fi

section "7. INCIDENT-SCOPED ALERT ANALYSIS"

if command_exists jq && [[ -s "$ALERT_FILE" ]]; then
    jq -c \
        --arg start "$ACTIVITY_START" \
        '. as $a |
         select(
           (($a.timestamp // "") >= $start) or
           (($a.data.command // "") | contains("LAB4")) or
           (($a.full_log // "") | contains("LAB4")) or
           (($a.rule.description // "") | test("sudo|PAM|command|authentication"; "i"))
         )' \
        "$ALERT_FILE" \
        > "$EVIDENCE_DIR/incident-alerts.jsonl" 2>/dev/null || true

    jq -r '
        [
          (.timestamp // ""),
          (.agent.id // ""),
          (.agent.name // ""),
          (.rule.id // ""),
          (.rule.level // ""),
          (.rule.description // ""),
          (.decoder.name // ""),
          (.location // "")
        ] | @tsv
    ' "$EVIDENCE_DIR/incident-alerts.jsonl" \
        > "$EVIDENCE_DIR/incident-alert-timeline.tsv" 2>/dev/null || true

    INCIDENT_ALERT_COUNT="$(wc -l < "$EVIDENCE_DIR/incident-alerts.jsonl" 2>/dev/null || echo 0)"

    if [[ "$INCIDENT_ALERT_COUNT" -gt 0 ]]; then
        pass "Incident-scoped Wazuh alerts identified: $INCIDENT_ALERT_COUNT"
    else
        warn "No incident-scoped Wazuh alerts identified"
    fi
else
    warn "jq or Wazuh alert data unavailable for structured analysis"
    INCIDENT_ALERT_COUNT=0
fi

section "8. AUDITD CORRELATION"

if [[ -s "$EVIDENCE_DIR/post-activity-auditd.txt" ]]; then
    grep -Ei \
        'LAB4|EXECVE|USER_CMD|USER_START|USER_END|sudo|auid=|uid=|pid=|ppid=' \
        "$EVIDENCE_DIR/post-activity-auditd.txt" \
        > "$EVIDENCE_DIR/incident-auditd-relevant.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/incident-auditd-relevant.txt" ]]; then
        pass "Auditd activity correlated with incident window"
    else
        warn "Auditd data captured but no directly matching records found"
    fi
else
    warn "Auditd evidence unavailable"
fi

section "9. JOURNAL/PAM CORRELATION"

if [[ -s "$EVIDENCE_DIR/post-activity-journal.txt" ]]; then
    grep -Ei \
        'LAB4|sudo|pam|session opened|session closed|authentication|COMMAND=' \
        "$EVIDENCE_DIR/post-activity-journal.txt" \
        > "$EVIDENCE_DIR/incident-journal-relevant.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/incident-journal-relevant.txt" ]]; then
        pass "Journal/PAM activity correlated"
    else
        warn "Journal captured but no matching authentication records found"
    fi
else
    warn "Journal evidence unavailable"
fi

section "10. PROCESS AND NETWORK CORRELATION"

grep -Ei \
    'sudo|bash|sh|LAB4' \
    "$EVIDENCE_DIR/post-activity-processes.txt" \
    > "$EVIDENCE_DIR/incident-process-relevant.txt" 2>/dev/null || true

if [[ -s "$EVIDENCE_DIR/incident-process-relevant.txt" ]]; then
    pass "Relevant process evidence extracted"
else
    warn "No directly matching process evidence extracted"
fi

if [[ -s "$EVIDENCE_DIR/post-activity-listening-sockets.txt" ]]; then
    cp "$EVIDENCE_DIR/post-activity-listening-sockets.txt" \
       "$EVIDENCE_DIR/incident-network-context.txt"
    pass "Network context captured"
else
    warn "Network context unavailable"
fi

section "11. MITRE ATT&CK CONTEXT"

cat > "$EVIDENCE_DIR/mitre-mapping.txt" <<EOF
LAB4 MITRE ATT&CK CONTEXT

Incident: $INCIDENT_ID

Potential technique:
T1548.003 - Abuse Elevation Control Mechanism: Sudo and Sudo Caching

Use:
The technique is documented as investigative context because the controlled
lab activity intentionally used sudo.

Important limitation:
This mapping does NOT indicate malicious activity. The activity was generated
by the analyst as part of a controlled SOC simulation.

PAM session events are supporting authentication/session telemetry and are not
independently treated as an ATT&CK technique.
EOF

pass "MITRE context documented with controlled-lab limitation"

section "12. CONTROLLED CONTAINMENT"

CONTAINMENT_TS="$(date --iso-8601=seconds)"

if [[ -f "$LAB_FILE" ]]; then
    chmod 000 "$LAB_FILE"
    CONTAINMENT_STATUS=$?

    {
        echo "CONTAINMENT_TIMESTAMP=$CONTAINMENT_TS"
        echo "ACTION=chmod 000 on temporary lab artifact"
        echo "TARGET=$LAB_FILE"
        echo "EXIT_CODE=$CONTAINMENT_STATUS"
    } > "$EVIDENCE_DIR/response-action.txt"

    if [[ "$CONTAINMENT_STATUS" -eq 0 ]]; then
        pass "Safe containment action applied to temporary lab artifact"
    else
        fail "Containment action failed"
    fi
else
    fail "Temporary lab artifact unavailable for containment"
fi

section "13. CONTAINMENT VERIFICATION"

if [[ -f "$LAB_FILE" ]]; then
    FILE_MODE="$(stat -c '%a' "$LAB_FILE" 2>/dev/null || echo UNKNOWN)"
    log "Contained artifact mode: $FILE_MODE"

    if [[ "$FILE_MODE" == "0" ]]; then
        pass "Containment verified"
        {
            echo "VERIFICATION=PASS"
            echo "MODE=$FILE_MODE"
            echo "TARGET=$LAB_FILE"
        } > "$EVIDENCE_DIR/response-verification.txt"
    else
        warn "Artifact exists but mode is $FILE_MODE"
    fi
else
    fail "Contained artifact disappeared unexpectedly"
fi

section "14. INCIDENT TIMELINE"

{
    printf 'TIMESTAMP\tEVENT\n'
    printf '%s\tIncident initialized\n' "$START_TS"
    printf '%s\tControlled privileged activity started\n' "$ACTIVITY_START"
    printf '%s\tControlled privileged activity completed\n' "$ACTIVITY_END"
    printf '%s\tContainment action applied\n' "$CONTAINMENT_TS"
} > "$EVIDENCE_DIR/incident-timeline.tsv"

cat "$EVIDENCE_DIR/incident-timeline.tsv" | tee -a "$REPORT_FILE"

pass "Incident timeline generated"

section "15. INCIDENT DISPOSITION"

cat > "$EVIDENCE_DIR/incident-disposition.txt" <<EOF
LAB4 INCIDENT DISPOSITION

Incident ID:
$INCIDENT_ID

Nature:
Controlled SOC incident-response simulation.

Ground truth:
The analyst intentionally generated privileged command execution using sudo
against a temporary lab artifact.

Detection:
Wazuh manager telemetry was collected after the activity.

Investigation:
Wazuh, Auditd, journald/PAM, process, and network evidence were collected
where available.

Containment:
The temporary lab artifact was restricted with chmod 000.

Verification:
The containment state was checked after the response action.

Security conclusion:
This exercise does not represent a real compromise. It demonstrates the
SOC workflow of detection, triage, evidence correlation, containment,
verification, and documentation.

ATT&CK context:
T1548.003 may be used as investigative context because sudo was deliberately
used. This is not a malicious-technique determination.
EOF

cat "$EVIDENCE_DIR/incident-disposition.txt" | tee -a "$REPORT_FILE"

pass "Incident disposition documented"

section "16. CLEANUP VERIFICATION"

if [[ -e "$LAB_FILE" ]]; then
    rm -f "$LAB_FILE"
fi

if [[ ! -e "$LAB_FILE" ]]; then
    rmdir "$LAB_ROOT" 2>/dev/null || true
    pass "Temporary lab artifact cleaned up"
else
    warn "Temporary lab artifact remains and requires manual cleanup"
fi

section "17. EVIDENCE MANIFEST"

find "$EVIDENCE_DIR" -maxdepth 1 -type f -printf '%f\n' |
    sort > "$EVIDENCE_DIR/evidence-manifest.txt"

MANIFEST_COUNT="$(wc -l < "$EVIDENCE_DIR/evidence-manifest.txt" 2>/dev/null || echo 0)"

cat "$EVIDENCE_DIR/evidence-manifest.txt" | tee -a "$REPORT_FILE"

if [[ "$MANIFEST_COUNT" -gt 0 ]]; then
    pass "Evidence manifest contains $MANIFEST_COUNT files"
else
    fail "Evidence manifest is empty"
fi

section "18. FINAL VALIDATION"

log "PASS: $PASS"
log "WARN: $WARN"
log "FAIL: $FAIL"
log
log "Incident ID: $INCIDENT_ID"
log "Completed: $(date --iso-8601=seconds)"
log
log "Report:   $REPORT_FILE"
log "Evidence: $EVIDENCE_DIR"

if [[ "$FAIL" -eq 0 ]]; then
    log
    log "RESULT: LAB 4 INCIDENT RESPONSE SIMULATION COMPLETED WITHOUT HARD FAILURES"
else
    log
    log "RESULT: LAB 4 COMPLETED WITH FAILURES"
fi
