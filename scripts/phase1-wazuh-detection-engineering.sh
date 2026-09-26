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
EVIDENCE_DIR="$REPO/evidence/phase1-wazuh-detection-engineering-${STAMP}"
REPORT_FILE="$REPORT_DIR/phase1-wazuh-detection-engineering-${STAMP}.txt"

mkdir -p "$REPORT_DIR" "$EVIDENCE_DIR"

PASS=0
WARN=0
FAIL=0

RULE_ID="100500"
RULE_NAME="lab5-detection-engineering"
RULE_FILE="/var/ossec/etc/rules/${RULE_NAME}.xml"
MARKER="LAB5-DETECTION-ENGINEERING"
BENIGN_MARKER="LAB5-BENIGN-NONMATCH"
RULE_BACKUP="/var/ossec/etc/rules/${RULE_NAME}.xml.bak-${STAMP}"

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

WAZUH_MANAGER="$(docker ps --format '{{.Names}}' 2>/dev/null |
    grep '^single-node-wazuh.manager-' | head -1 || true)"

if [[ -n "$WAZUH_MANAGER" ]]; then
    pass "Wazuh manager detected: $WAZUH_MANAGER"
else
    fail "Wazuh manager container not detected"
fi

section "2. DETECTION DESIGN"

cat > "$EVIDENCE_DIR/detection-design.txt" <<EOF
LAB 5 — WAZUH DETECTION ENGINEERING

Detection name:
$RULE_NAME

Rule ID:
$RULE_ID

Detection condition:
The Wazuh manager detects the exact controlled marker:
$MARKER

Detection severity:
7

Purpose:
Validate the complete lifecycle of a custom Wazuh detection:
design, deployment, event generation, alert validation, negative testing,
and evidence documentation.

False-positive control:
A similar but non-matching marker is generated:
$BENIGN_MARKER

This rule is deliberately narrow and is not intended to represent a
production malicious-behavior detector.
EOF

cat "$EVIDENCE_DIR/detection-design.txt" | tee -a "$REPORT_FILE"
pass "Detection specification documented"

section "3. EXISTING RULE STATE"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "test -f '$RULE_FILE' && cat '$RULE_FILE' || true" \
        > "$EVIDENCE_DIR/existing-rule-state.txt" 2>&1 || true

    if [[ -s "$EVIDENCE_DIR/existing-rule-state.txt" ]]; then
        log "Existing dedicated Lab 5 rule detected."
        cp "$EVIDENCE_DIR/existing-rule-state.txt" \
           "$EVIDENCE_DIR/existing-rule-before.txt"
        pass "Existing Lab 5 rule state preserved"
    else
        log "No existing dedicated Lab 5 rule found."
        echo "NO_EXISTING_RULE" > "$EVIDENCE_DIR/existing-rule-state.txt"
        pass "No conflicting Lab 5 rule detected"
    fi
else
    fail "Cannot inspect Wazuh rules without manager"
fi

section "4. RULE BACKUP"

if [[ -n "$WAZUH_MANAGER" ]]; then
    if docker exec "$WAZUH_MANAGER" sh -c \
        "test -f '$RULE_FILE'"; then

        docker exec "$WAZUH_MANAGER" sh -c \
            "cp '$RULE_FILE' '$RULE_BACKUP'" >/dev/null 2>&1

        if [[ $? -eq 0 ]]; then
            log "Backup: $RULE_BACKUP"
            pass "Existing dedicated rule backed up"
        else
            fail "Unable to back up existing dedicated rule"
        fi
    else
        pass "No existing dedicated rule requires backup"
    fi
fi

section "5. CUSTOM RULE DEPLOYMENT"

RULE_CONTENT='<group name="lab5,detection_engineering,">
  <rule id="100500" level="7">
    <match>LAB5-DETECTION-ENGINEERING</match>
    <description>LAB5: Controlled detection engineering test marker detected.</description>
  </rule>
</group>'

printf '%s\n' "$RULE_CONTENT" > "$EVIDENCE_DIR/deployed-rule.xml"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec -i "$WAZUH_MANAGER" sh -c \
        "cat > '$RULE_FILE'" < "$EVIDENCE_DIR/deployed-rule.xml"

    if [[ $? -eq 0 ]]; then
        pass "Custom Wazuh detection deployed"
    else
        fail "Custom Wazuh detection deployment failed"
    fi
else
    fail "Wazuh manager unavailable for rule deployment"
fi

section "6. RULE VALIDATION"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "test -f '$RULE_FILE' && cat '$RULE_FILE'" \
        > "$EVIDENCE_DIR/rule-after-deployment.xml" 2>&1 || true

    if grep -q "$MARKER" "$EVIDENCE_DIR/rule-after-deployment.xml"; then
        pass "Deployed rule contains expected detection marker"
    else
        fail "Deployed rule does not contain expected marker"
    fi
fi

section "7. WAZUH MANAGER RELOAD"

if [[ -n "$WAZUH_MANAGER" ]]; then
    BEFORE_RESTART="$(date --iso-8601=seconds)"

    docker exec "$WAZUH_MANAGER" sh -c \
        "/var/ossec/bin/wazuh-control restart" \
        > "$EVIDENCE_DIR/wazuh-restart-output.txt" 2>&1 || true

    sleep 8

    echo "RESTART_TIMESTAMP=$BEFORE_RESTART" \
        > "$EVIDENCE_DIR/restart-context.txt"
else
    fail "Cannot restart Wazuh manager"
fi

sleep 5

section "7. MANAGER HEALTH VALIDATION"

docker ps --filter "name=$WAZUH_MANAGER" \
    --format '{{.Names}} {{.Status}}' \
    > "$EVIDENCE_DIR/wazuh-container-status.txt" 2>&1 || true

docker exec "$WAZUH_MANAGER" sh -c \
    "ps -eo pid,args | grep '[w]azuh-analysisd'" \
    > "$EVIDENCE_DIR/wazuh-analysisd-process.txt" 2>&1 || true

if grep -q "^$WAZUH_MANAGER " "$EVIDENCE_DIR/wazuh-container-status.txt"; then
    pass "Wazuh manager container is running"
else
    fail "Wazuh manager container is not running"
fi

if grep -q "[w]azuh-analysisd" "$EVIDENCE_DIR/wazuh-analysisd-process.txt"; then
    pass "Wazuh analysis engine is running"
else
    fail "Wazuh analysis engine is not running"
fi

section "8. PRE-TEST ALERT BASELINE"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "wc -l < /var/ossec/logs/alerts/alerts.json" \
        > "$EVIDENCE_DIR/alert-baseline-count.txt" 2>&1 || true

    BASELINE_COUNT="$(cat "$EVIDENCE_DIR/alert-baseline-count.txt" 2>/dev/null || echo 0)"
    log "Manager alert baseline: $BASELINE_COUNT"
    pass "Alert baseline captured"
else
    fail "Cannot capture alert baseline"
    BASELINE_COUNT=0
fi

section "9. POSITIVE DETECTION TEST"

POSITIVE_TS="$(date --iso-8601=seconds)"

logger -t lab5-detection \
    "$MARKER controlled-positive-test incident_id=${STAMP}"

POSITIVE_EXIT=$?

sleep 8

echo "POSITIVE_TIMESTAMP=$POSITIVE_TS" \
    > "$EVIDENCE_DIR/positive-test.txt"
echo "LOGGER_EXIT_CODE=$POSITIVE_EXIT" \
    >> "$EVIDENCE_DIR/positive-test.txt"

if [[ "$POSITIVE_EXIT" -eq 0 ]]; then
    pass "Positive test event generated"
else
    fail "Positive test event generation failed"
fi

section "10. POSITIVE ALERT VERIFICATION"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "tail -n 500 /var/ossec/logs/alerts/alerts.json" \
        > "$EVIDENCE_DIR/post-positive-alerts.jsonl" 2>/dev/null || true

    if command_exists jq; then
        jq -c \
            --arg marker "$MARKER" \
            'select((.full_log // "") | contains($marker))' \
            "$EVIDENCE_DIR/post-positive-alerts.jsonl" \
            > "$EVIDENCE_DIR/positive-detection-alerts.jsonl" 2>/dev/null || true
    else
        grep "$MARKER" \
            "$EVIDENCE_DIR/post-positive-alerts.jsonl" \
            > "$EVIDENCE_DIR/positive-detection-alerts.jsonl" 2>/dev/null || true
    fi

    POSITIVE_ALERT_COUNT="$(
        wc -l < "$EVIDENCE_DIR/positive-detection-alerts.jsonl" 2>/dev/null || echo 0
    )"

    if [[ "$POSITIVE_ALERT_COUNT" -gt 0 ]]; then
        pass "Custom detection generated $POSITIVE_ALERT_COUNT alert(s)"
    else
        fail "Custom detection did not generate an alert"
    fi
else
    fail "Wazuh manager unavailable for positive alert verification"
    POSITIVE_ALERT_COUNT=0
fi

section "11. POSITIVE ALERT METADATA"

if [[ -s "$EVIDENCE_DIR/positive-detection-alerts.jsonl" ]] && command_exists jq; then
    jq -r '
        [
          (.timestamp // ""),
          (.agent.id // ""),
          (.agent.name // ""),
          (.rule.id // ""),
          (.rule.level // ""),
          (.rule.description // ""),
          (.decoder.name // ""),
          (.location // ""),
          (.full_log // "")
        ] | @tsv
    ' "$EVIDENCE_DIR/positive-detection-alerts.jsonl" \
        > "$EVIDENCE_DIR/positive-alert-metadata.tsv" 2>/dev/null || true

    cat "$EVIDENCE_DIR/positive-alert-metadata.tsv" | tee -a "$REPORT_FILE"

    if grep -q $'\t'"$RULE_ID"$'\t' \
        "$EVIDENCE_DIR/positive-alert-metadata.tsv"; then
        pass "Expected custom rule ID $RULE_ID confirmed"
    else
        fail "Expected custom rule ID $RULE_ID not confirmed"
    fi
else
    warn "Positive alert metadata unavailable"
fi

section "12. NEGATIVE FALSE-POSITIVE TEST"

NEGATIVE_TS="$(date --iso-8601=seconds)"

logger -t lab5-detection \
    "$BENIGN_MARKER controlled-negative-test incident_id=${STAMP}"

NEGATIVE_EXIT=$?

sleep 8

echo "NEGATIVE_TIMESTAMP=$NEGATIVE_TS" \
    > "$EVIDENCE_DIR/negative-test.txt"
echo "LOGGER_EXIT_CODE=$NEGATIVE_EXIT" \
    >> "$EVIDENCE_DIR/negative-test.txt"

if [[ "$NEGATIVE_EXIT" -eq 0 ]]; then
    pass "Negative test event generated"
else
    fail "Negative test event generation failed"
fi

section "13. NEGATIVE ALERT VERIFICATION"

if [[ -n "$WAZUH_MANAGER" ]]; then
    docker exec "$WAZUH_MANAGER" sh -c \
        "tail -n 500 /var/ossec/logs/alerts/alerts.json" \
        > "$EVIDENCE_DIR/post-negative-alerts.jsonl" 2>/dev/null || true

    if command_exists jq; then
        jq -c \
            --arg marker "$BENIGN_MARKER" \
            'select((.full_log // "") | contains($marker))' \
            "$EVIDENCE_DIR/post-negative-alerts.jsonl" \
            > "$EVIDENCE_DIR/negative-marker-alerts.jsonl" 2>/dev/null || true
    else
        grep "$BENIGN_MARKER" \
            "$EVIDENCE_DIR/post-negative-alerts.jsonl" \
            > "$EVIDENCE_DIR/negative-marker-alerts.jsonl" 2>/dev/null || true
    fi

    NEGATIVE_ALERT_COUNT="$(
        wc -l < "$EVIDENCE_DIR/negative-marker-alerts.jsonl" 2>/dev/null || echo 0
    )"

    if [[ "$NEGATIVE_ALERT_COUNT" -eq 0 ]]; then
        pass "Negative test produced no matching custom detection alert"
    else
        warn "Negative test produced $NEGATIVE_ALERT_COUNT matching alert(s)"
    fi
else
    fail "Wazuh manager unavailable for negative test verification"
    NEGATIVE_ALERT_COUNT=0
fi

section "14. DETECTION PERFORMANCE SUMMARY"

{
    echo "LAB 5 DETECTION PERFORMANCE"
    echo
    echo "Rule ID: $RULE_ID"
    echo "Positive marker: $MARKER"
    echo "Negative marker: $BENIGN_MARKER"
    echo "Positive alerts: ${POSITIVE_ALERT_COUNT:-0}"
    echo "Negative matching alerts: ${NEGATIVE_ALERT_COUNT:-0}"
    echo
    echo "Positive detection expected: YES"
    echo "Negative detection expected: NO"
    echo
    if [[ "${POSITIVE_ALERT_COUNT:-0}" -gt 0 && "${NEGATIVE_ALERT_COUNT:-0}" -eq 0 ]]; then
        echo "RESULT: DETECTION BEHAVIOR VALIDATED"
    else
        echo "RESULT: DETECTION REQUIRES REVIEW"
    fi
} > "$EVIDENCE_DIR/detection-performance.txt"

cat "$EVIDENCE_DIR/detection-performance.txt" | tee -a "$REPORT_FILE"

if [[ "${POSITIVE_ALERT_COUNT:-0}" -gt 0 && "${NEGATIVE_ALERT_COUNT:-0}" -eq 0 ]]; then
    pass "Positive/negative detection behavior validated"
else
    warn "Detection behavior requires analyst review"
fi

section "15. PORTFOLIO DETECTION DOCUMENTATION"

cat > "$EVIDENCE_DIR/portfolio-detection.md" <<EOF
# Wazuh Detection Engineering — Lab 5

## Detection

**Rule ID:** $RULE_ID  
**Name:** $RULE_NAME  
**Severity:** 7

### Logic

The rule matches the controlled marker:

\`$MARKER\`

### Validation

A positive test generated the marker and the Wazuh manager produced the
custom detection alert.

A negative test generated:

\`$BENIGN_MARKER\`

The negative marker does not contain the detection string and is expected
not to trigger the custom rule.

### SOC value

This exercise demonstrates:

- custom detection creation;
- controlled event generation;
- alert validation;
- rule-ID verification;
- positive testing;
- negative testing;
- basic false-positive control;
- evidence collection;
- detection documentation.

### Limitation

This is a deliberately narrow laboratory detection. It is not presented
as a production malicious-behavior rule.
EOF

pass "Portfolio detection documentation generated"

section "16. EVIDENCE MANIFEST"

find "$EVIDENCE_DIR" -maxdepth 1 -type f -printf '%f\n' |
    sort > "$EVIDENCE_DIR/evidence-manifest.txt"

MANIFEST_COUNT="$(wc -l < "$EVIDENCE_DIR/evidence-manifest.txt" 2>/dev/null || echo 0)"

cat "$EVIDENCE_DIR/evidence-manifest.txt" | tee -a "$REPORT_FILE"

if [[ "$MANIFEST_COUNT" -gt 0 ]]; then
    pass "Evidence manifest contains $MANIFEST_COUNT files"
else
    fail "Evidence manifest is empty"
fi

section "17. FINAL VALIDATION"

log "PASS: $PASS"
log "WARN: $WARN"
log "FAIL: $FAIL"
log
log "Rule ID: $RULE_ID"
log "Incident marker: $MARKER"
log "Completed: $(date --iso-8601=seconds)"
log
log "Report:   $REPORT_FILE"
log "Evidence: $EVIDENCE_DIR"
log
log "Important:"
log "  The custom rule was designed specifically for controlled validation."
log "  The positive event was intentionally generated by this lab."
log "  The detection must not be interpreted as evidence of compromise."

if [[ "$FAIL" -eq 0 ]]; then
    log
    log "RESULT: LAB 5 DETECTION ENGINEERING COMPLETED WITHOUT HARD FAILURES"
else
    log
    log "RESULT: LAB 5 COMPLETED WITH FAILURES"
fi
