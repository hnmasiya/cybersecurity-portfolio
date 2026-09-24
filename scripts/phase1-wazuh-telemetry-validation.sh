#!/usr/bin/env bash
# ============================================================
# Phase 1 — Lab 2
# Wazuh Telemetry & Detection Validation
#
# Purpose:
#   Generate controlled security telemetry and verify that
#   Wazuh can observe, process, and generate alerts from it.
#
# Safety:
#   - Local lab only
#   - No destructive actions
#   - No credential attacks
#   - No persistence
#   - No external targets
#   - Temporary test artifacts are removed
#   - Wazuh configuration is NOT modified
#
# Portfolio:
#   hnmasiya/cybersecurity-portfolio
# ============================================================

set -uo pipefail

SCRIPT_NAME="phase1-wazuh-telemetry-validation"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPORT_DIR="$REPO_ROOT/reports"
EVIDENCE_DIR="$REPO_ROOT/evidence/${SCRIPT_NAME}-${TIMESTAMP}"

REPORT="$REPORT_DIR/${SCRIPT_NAME}-${TIMESTAMP}.txt"

mkdir -p "$REPORT_DIR" "$EVIDENCE_DIR"

PASS=0
WARN=0
FAIL=0

TEST_TAG="WAZUH_LAB_${TIMESTAMP}"
TEST_FILE="/tmp/${TEST_TAG}.txt"

MANAGER_CONTAINER="single-node-wazuh.manager-1"
AGENT_LOG="/var/ossec/logs/ossec.log"
ALERT_LOG="/var/ossec/logs/alerts/alerts.json"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

section() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

log() {
    echo "$*" | tee -a "$REPORT"
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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

timestamp_epoch() {
    date +%s
}

# ------------------------------------------------------------
# Start report
# ------------------------------------------------------------

cat > "$REPORT" <<EOF
============================================================
WAZUH TELEMETRY & DETECTION VALIDATION
============================================================

Script:       $SCRIPT_NAME
Timestamp:    $(date '+%Y-%m-%d %H:%M:%S %Z')
Host:         $(hostname)
Test Tag:     $TEST_TAG

PURPOSE
-------
Generate controlled security telemetry and validate the
Wazuh collection -> analysis -> alert pipeline.

NO WAZUH CONFIGURATION CHANGES ARE PERFORMED.

============================================================

EOF

section "1. ENVIRONMENT PRE-CHECK"

if ! command_exists docker; then
    fail "Docker CLI not available."
else
    pass "Docker CLI available."
fi

if ! command_exists curl; then
    warn "curl unavailable. HTTP telemetry validation will be limited."
fi

if [[ -d /var/ossec ]]; then
    pass "Wazuh agent installation detected."
else
    fail "Wazuh agent installation not detected."
fi

if docker ps --format '{{.Names}}' | grep -qx "$MANAGER_CONTAINER"; then
    pass "Wazuh manager container is running."
else
    fail "Wazuh manager container is not running."
fi

if [[ -f "$ALERT_LOG" ]]; then
    pass "Wazuh alerts.json exists."
else
    warn "Wazuh alerts.json not found."
fi


# ------------------------------------------------------------
# 2. BASELINE ALERT COUNTER
# ------------------------------------------------------------

section "2. ALERT BASELINE"

BASELINE_LINES=0
BASELINE_TIME="$(timestamp_epoch)"

if [[ -f "$ALERT_LOG" ]]; then
    BASELINE_LINES="$(wc -l < "$ALERT_LOG")"
    log "Existing alerts.json lines: $BASELINE_LINES"
    log "Baseline epoch: $BASELINE_TIME"

    tail -20 "$ALERT_LOG" > "$EVIDENCE_DIR/alerts-before.json"
else
    warn "Unable to establish alerts.json baseline."
fi


# ------------------------------------------------------------
# 3. FILE INTEGRITY TELEMETRY
# ------------------------------------------------------------

section "3. FILE INTEGRITY MONITORING TEST"

log "Creating controlled test file:"
log "$TEST_FILE"

echo "Wazuh telemetry validation test: $TEST_TAG" > "$TEST_FILE"

if [[ -f "$TEST_FILE" ]]; then
    pass "Controlled test file created."
else
    fail "Could not create controlled test file."
fi

sleep 2

log "Modifying controlled test file."

echo "Modification event: $(date '+%Y-%m-%d %H:%M:%S %Z')" >> "$TEST_FILE"

sleep 2

log "Calculating test file hash:"
sha256sum "$TEST_FILE" |
    tee "$EVIDENCE_DIR/test-file-hash.txt" |
    tee -a "$REPORT"

pass "File creation/modification telemetry generated."

rm -f "$TEST_FILE"

if [[ ! -e "$TEST_FILE" ]]; then
    pass "Temporary test file removed."
else
    warn "Temporary test file remains."
fi


# ------------------------------------------------------------
# 4. PRIVILEGE / SUDO TELEMETRY
# ------------------------------------------------------------

section "4. PRIVILEGE ACTIVITY TEST"

if command_exists sudo; then

    log "Generating a harmless sudo authentication event."

    sudo -n true >/dev/null 2>&1
    SUDO_RC=$?

    case "$SUDO_RC" in
        0)
            log "Existing sudo authorization succeeded without prompting."
            pass "Controlled sudo event executed."
            ;;
        1)
            warn "Sudo authorization returned non-zero; no destructive command was executed."
            ;;
        *)
            warn "Sudo test returned code $SUDO_RC."
            ;;
    esac

else
    warn "sudo command unavailable."
fi


# ------------------------------------------------------------
# 5. AUTHENTICATION TELEMETRY
# ------------------------------------------------------------

section "5. AUTHENTICATION TELEMETRY TEST"

log "Current user:"
id | tee "$EVIDENCE_DIR/current-user.txt" | tee -a "$REPORT"

log
log "Current session:"
who | tee "$EVIDENCE_DIR/current-session.txt" | tee -a "$REPORT"

log
log "Recent login records:"
last -n 5 |
    tee "$EVIDENCE_DIR/recent-logins.txt" |
    tee -a "$REPORT"

pass "Authentication/session telemetry queried."


# ------------------------------------------------------------
# 6. PROCESS / SYSTEM TELEMETRY
# ------------------------------------------------------------

section "6. PROCESS & SYSTEM TELEMETRY TEST"

log "Current process snapshot:"
ps -eo user,pid,ppid,comm,%cpu,%mem --sort=-%mem |
    head -20 |
    tee "$EVIDENCE_DIR/process-snapshot.txt" |
    tee -a "$REPORT"

log
log "Current network listeners:"
ss -tulpn 2>/dev/null |
    tee "$EVIDENCE_DIR/network-listeners.txt" |
    tee -a "$REPORT"

pass "Process and network telemetry captured."


# ------------------------------------------------------------
# 7. APACHE TELEMETRY
# ------------------------------------------------------------

section "7. APACHE WEB TELEMETRY TEST"

APACHE_URL="http://127.0.0.1/"

if command_exists curl; then

    log "Requesting local Apache endpoint:"
    log "$APACHE_URL"

    HTTP_RESULT="$(
        curl -sS \
            --max-time 10 \
            -o "$EVIDENCE_DIR/apache-response-body.txt" \
            -w 'HTTP_STATUS=%{http_code}\nTIME_TOTAL=%{time_total}\n' \
            "$APACHE_URL" 2>&1 || true
    )"

    echo "$HTTP_RESULT" |
        tee "$EVIDENCE_DIR/apache-request-result.txt" |
        tee -a "$REPORT"

    if echo "$HTTP_RESULT" | grep -q 'HTTP_STATUS=2'; then
        pass "Local Apache request generated successfully."
    elif echo "$HTTP_RESULT" | grep -q 'HTTP_STATUS=3'; then
        pass "Local Apache request generated a redirect."
    else
        warn "Apache request did not return a 2xx/3xx response."
    fi

else
    warn "curl unavailable; Apache telemetry test skipped."
fi


# ------------------------------------------------------------
# 8. JOURNAL / SYSTEM LOG TELEMETRY
# ------------------------------------------------------------

section "8. JOURNAL TELEMETRY"

if command_exists journalctl; then

    journalctl --since "10 minutes ago" --no-pager |
        tail -100 |
        tee "$EVIDENCE_DIR/recent-journal.txt" |
        tee -a "$REPORT"

    pass "Recent journald telemetry captured."

else
    warn "journalctl unavailable."
fi


# ------------------------------------------------------------
# 9. AUDITD TELEMETRY
# ------------------------------------------------------------

section "9. AUDITD TELEMETRY"

if [[ -f /var/log/audit/audit.log ]]; then

    tail -100 /var/log/audit/audit.log |
        tee "$EVIDENCE_DIR/recent-audit.log" |
        tee -a "$REPORT"

    pass "Auditd telemetry available."

else
    warn "Audit log not found."
fi


# ------------------------------------------------------------
# 10. WAIT FOR WAZUH PROCESSING
# ------------------------------------------------------------

section "10. WAZUH PROCESSING WINDOW"

log "Waiting for Wazuh to process generated telemetry..."
sleep 15

log "Processing window completed."


# ------------------------------------------------------------
# 11. ALERT DIFFERENCE
# ------------------------------------------------------------

section "11. ALERT PIPELINE VALIDATION"

if [[ -f "$ALERT_LOG" ]]; then

    FINAL_LINES="$(wc -l < "$ALERT_LOG")"

    log "Alerts before test: $BASELINE_LINES"
    log "Alerts after test : $FINAL_LINES"

    if [[ "$FINAL_LINES" -gt "$BASELINE_LINES" ]]; then
        NEW_ALERTS=$((FINAL_LINES - BASELINE_LINES))

        pass "Wazuh generated $NEW_ALERTS new alert record(s)."

        tail -n "$NEW_ALERTS" "$ALERT_LOG" |
            tee "$EVIDENCE_DIR/new-alerts.json" |
            tee -a "$REPORT"

    else
        NEW_ALERTS=0
        warn "No new alert records detected during the processing window."
        log "This does not necessarily mean telemetry was not collected."
        log "Some events may not meet a Wazuh rule threshold."
    fi

else
    fail "alerts.json unavailable after telemetry generation."
    NEW_ALERTS=0
fi


# ------------------------------------------------------------
# 12. SEARCH FOR TEST-RELATED EVENTS
# ------------------------------------------------------------

section "12. TEST EVENT CORRELATION"

log "Searching Wazuh agent logs for telemetry-validation events."

if [[ -f "$AGENT_LOG" ]]; then

    grep -Ei \
        "$TEST_TAG|queue is full|Analyzing file|audit|apache" \
        "$AGENT_LOG" |
        tail -100 |
        tee "$EVIDENCE_DIR/agent-correlated-events.txt" |
        tee -a "$REPORT"

    if grep -qiE "$TEST_TAG|Analyzing file|audit|apache" "$AGENT_LOG"; then
        pass "Relevant telemetry-processing evidence found in agent logs."
    else
        warn "No direct correlation found in agent log."
    fi

else
    warn "Agent log unavailable for correlation."
fi


# ------------------------------------------------------------
# 13. ALERT SEVERITY SUMMARY
# ------------------------------------------------------------

section "13. ALERT SEVERITY SUMMARY"

if [[ -f "$EVIDENCE_DIR/new-alerts.json" ]]; then

    log "Extracting alert levels and rule IDs."

    grep -oE \
        '"level":[[:space:]]*[0-9]+' \
        "$EVIDENCE_DIR/new-alerts.json" |
        sort |
        uniq -c |
        tee "$EVIDENCE_DIR/alert-level-summary.txt" |
        tee -a "$REPORT"

    log
    grep -oE \
        '"id":"[^"]+"' \
        "$EVIDENCE_DIR/new-alerts.json" |
        sort |
        uniq -c |
        head -50 |
        tee "$EVIDENCE_DIR/alert-rule-summary.txt" |
        tee -a "$REPORT"

else
    warn "No new alerts available for severity/rule analysis."
fi


# ------------------------------------------------------------
# 14. CLEANUP VERIFICATION
# ------------------------------------------------------------

section "14. CLEANUP VERIFICATION"

if [[ ! -e "$TEST_FILE" ]]; then
    pass "Temporary telemetry artifact successfully removed."
else
    warn "Temporary telemetry artifact still exists: $TEST_FILE"
fi


# ------------------------------------------------------------
# 15. FINAL ASSESSMENT
# ------------------------------------------------------------

section "15. TELEMETRY VALIDATION ASSESSMENT"

log "Checks passed : $PASS"
log "Warnings      : $WARN"
log "Failures      : $FAIL"

log
log "Validation objectives:"
log "- Controlled telemetry generated"
log "- Wazuh collection pipeline evaluated"
log "- Wazuh alert pipeline evaluated"
log "- Alert evidence captured where available"
log "- Temporary artifacts cleaned up"
log "- No Wazuh configuration changes performed"

log
log "Evidence directory:"
log "$EVIDENCE_DIR"

log
log "Report:"
log "$REPORT"

log
log "============================================================"
log "END OF TELEMETRY VALIDATION"
log "============================================================"


# ------------------------------------------------------------
# Machine-readable summary
# ------------------------------------------------------------

cat > "$EVIDENCE_DIR/summary.txt" <<EOF
Wazuh Telemetry & Detection Validation
=======================================

Timestamp: $TIMESTAMP
Host: $(hostname)
Test Tag: $TEST_TAG

Alerts Before: ${BASELINE_LINES:-UNKNOWN}
Alerts After:  ${FINAL_LINES:-UNKNOWN}
New Alerts:    ${NEW_ALERTS:-UNKNOWN}

PASS: $PASS
WARN: $WARN
FAIL: $FAIL

Tests performed:
- File integrity telemetry
- Privilege/sudo activity
- Authentication/session telemetry
- Process telemetry
- Network listener telemetry
- Apache HTTP telemetry
- Journald telemetry
- Auditd telemetry
- Wazuh alert pipeline validation

No Wazuh configuration changes were performed.
Temporary test artifacts were removed.
EOF

echo
echo "============================================================"
echo "TELEMETRY VALIDATION COMPLETE"
echo "============================================================"
echo "Report:   $REPORT"
echo "Evidence: $EVIDENCE_DIR"
echo
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "============================================================"

if [[ "$FAIL" -gt 0 ]]; then
    exit 2
fi

exit 0
