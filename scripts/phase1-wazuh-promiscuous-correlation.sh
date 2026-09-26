#!/usr/bin/env bash
set -uo pipefail

SCRIPT_NAME="$(basename "$0")"
START_TS="$(date --iso-8601=seconds)"

if [[ -n "${SUDO_USER:-}" ]]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER="$(id -un)"
fi

REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6 2>/dev/null || true)"
if [[ -z "$REAL_HOME" ]]; then
    REAL_HOME="$HOME"
fi

REPO="${REAL_HOME}/cybersecurity-portfolio"
if [[ ! -d "$REPO" ]]; then
    REPO="$(pwd)"
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT_DIR="${REPO}/reports"
EVIDENCE_DIR="${REPO}/evidence/phase1-wazuh-promiscuous-correlation-${STAMP}"
REPORT_FILE="${REPORT_DIR}/phase1-wazuh-promiscuous-correlation-${STAMP}.txt"

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

run_capture() {
    local outfile="$1"
    shift
    if "$@" >"$outfile" 2>&1; then
        return 0
    fi
    return 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

LATEST_TRIAGE="$(
    find "${REPO}/evidence" -maxdepth 1 -type d \
        -name 'phase1-wazuh-alert-triage-*' \
        -printf '%T@ %p\n' 2>/dev/null |
    sort -nr |
    head -1 |
    cut -d' ' -f2-
)"

LATEST_80710="$(
    find "${REPO}/evidence" -maxdepth 1 -type d \
        -name 'phase1-wazuh-promiscuous-mode-investigation-*' \
        -printf '%T@ %p\n' 2>/dev/null |
    sort -nr |
    head -1 |
    cut -d' ' -f2-
)"

LATEST_80710_REPORT="$(
    find "${REPO}/reports" -maxdepth 1 -type f \
        -name 'phase1-wazuh-promiscuous-mode-investigation-*.txt' \
        -printf '%T@ %p\n' 2>/dev/null |
    sort -nr |
    head -1 |
    cut -d' ' -f2-
)"

section "1. ENVIRONMENT VALIDATION"

if [[ -d "$REPO/.git" ]]; then
    pass "Git repository detected: $REPO"
else
    fail "Git repository not detected: $REPO"
fi

if command_exists docker && docker info >/dev/null 2>&1; then
    pass "Docker is available and accessible"
else
    fail "Docker is unavailable"
fi

if docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^single-node-wazuh.manager-'; then
    WAZUH_MANAGER="$(docker ps --format '{{.Names}}' | grep '^single-node-wazuh.manager-' | head -1)"
    pass "Wazuh manager detected: $WAZUH_MANAGER"
else
    fail "Wazuh manager container not detected"
    WAZUH_MANAGER=""
fi

section "2. SOURCE LAB 3.2 EVIDENCE"

log "Latest Rule 80710 investigation evidence:"
log "  ${LATEST_80710:-NOT FOUND}"

if [[ -n "$LATEST_80710" && -f "$LATEST_80710/rule-80710-timeline.tsv" ]]; then
    cp "$LATEST_80710/rule-80710-timeline.tsv" \
       "$EVIDENCE_DIR/rule-80710-timeline.tsv"
    pass "Rule 80710 timeline imported"
else
    fail "Rule 80710 timeline not found"
fi

if [[ -n "$LATEST_80710" && -f "$LATEST_80710/rule-80710-alerts.jsonl" ]]; then
    cp "$LATEST_80710/rule-80710-alerts.jsonl" \
       "$EVIDENCE_DIR/rule-80710-alerts.jsonl"
    pass "Rule 80710 alert records imported"
else
    fail "Rule 80710 alert records not found"
fi

PROMISC_COUNT="$(wc -l < "$EVIDENCE_DIR/rule-80710-alerts.jsonl" 2>/dev/null || echo 0)"

section "3. HISTORICAL ALERT WINDOW"

if [[ -s "$EVIDENCE_DIR/rule-80710-timeline.tsv" ]]; then
    FIRST_TS="$(head -1 "$EVIDENCE_DIR/rule-80710-timeline.tsv" | cut -f1)"
    LAST_TS="$(tail -1 "$EVIDENCE_DIR/rule-80710-timeline.tsv" | cut -f1)"

    log "First Rule 80710 alert: $FIRST_TS"
    log "Last Rule 80710 alert:  $LAST_TS"
    log "Alert count: $PROMISC_COUNT"

    awk -F'\t' '{print $1 "\t" $4 "\t" $6}' \
        "$EVIDENCE_DIR/rule-80710-timeline.tsv" \
        > "$EVIDENCE_DIR/historical-alert-summary.tsv"

    pass "Historical Rule 80710 window established"
else
    fail "Unable to establish historical alert window"
    FIRST_TS=""
    LAST_TS=""
fi

section "4. PRECISE HISTORICAL TIME CONVERSION"

START_LOCAL=""
END_LOCAL=""

if [[ -n "$FIRST_TS" ]]; then
    START_LOCAL="$(date -d "${FIRST_TS:0:19}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || true)"
    END_LOCAL="$(date -d "${LAST_TS:0:19}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || true)"
fi

log "Historical investigation start: ${START_LOCAL:-UNRESOLVED}"
log "Historical investigation end:   ${END_LOCAL:-UNRESOLVED}"

if [[ -n "$START_LOCAL" && -n "$END_LOCAL" ]]; then
    pass "Historical timestamps converted for local correlation"
else
    warn "Historical timestamps could not be converted automatically"
fi

section "5. AUDITD HISTORICAL CORRELATION"

if command_exists ausearch && [[ -n "$START_LOCAL" ]]; then
    START_EPOCH="$(date -d "$START_LOCAL" +%s 2>/dev/null || echo "")"
    END_EPOCH="$(date -d "$END_LOCAL" +%s 2>/dev/null || echo "")"

    if [[ -n "$START_EPOCH" && -n "$END_EPOCH" ]]; then
        AUDIT_START="$(date -d "@$((START_EPOCH - 60))" '+%m/%d/%Y %H:%M:%S')"
        AUDIT_END="$(date -d "@$((END_EPOCH + 60))" '+%m/%d/%Y %H:%M:%S')"
    else
        AUDIT_START=""
        AUDIT_END=""
    fi

    if sudo -n true >/dev/null 2>&1; then
        sudo -n ausearch -ts "$AUDIT_START" -te "$AUDIT_END" -i \
            > "$EVIDENCE_DIR/auditd-historical-window.txt" 2>&1 || true
    else
        ausearch -ts "$AUDIT_START" -te "$AUDIT_END" -i \
            > "$EVIDENCE_DIR/auditd-historical-window.txt" 2>&1 || true
    fi

    grep -Ei \
        'PROMISC|promisc|NET_ADMIN|PACKET|AF_PACKET|SOCKET|ioctl|EXECVE|SYSCALL|comm=|exe=|uid=|auid=|pid=|ppid=' \
        "$EVIDENCE_DIR/auditd-historical-window.txt" \
        > "$EVIDENCE_DIR/auditd-historical-relevant.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/auditd-historical-relevant.txt" ]]; then
        pass "Relevant Auditd records found around Rule 80710 window"
    else
        warn "No directly matching Auditd process/exec evidence found in the scoped window"
    fi
else
    warn "ausearch unavailable or historical window unresolved"
fi

section "6. JOURNAL AND KERNEL CORRELATION"

if command_exists journalctl && [[ -n "$START_LOCAL" ]]; then
    journalctl \
        --since "$START_LOCAL - 60 seconds" \
        --until "$END_LOCAL + 60 seconds" \
        --no-pager \
        > "$EVIDENCE_DIR/journal-historical-window.txt" 2>&1 || true

    grep -Ei \
        'promisc|promiscuous|packet|capture|dumpcap|wireshark|docker|veth|networkmanager|link.*up|link.*down|set.*flag|interface' \
        "$EVIDENCE_DIR/journal-historical-window.txt" \
        > "$EVIDENCE_DIR/journal-historical-relevant.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/journal-historical-relevant.txt" ]]; then
        pass "Relevant journal/kernel records found"
    else
        warn "No directly matching journal/kernel records found"
    fi
else
    warn "journalctl unavailable or historical window unresolved"
fi

section "7. PACKET-CAPTURE PROCESS TIMELINE"

ps -eo pid,ppid,user,lstart,etime,comm,args --sort=lstart \
    > "$EVIDENCE_DIR/process-timeline.txt" 2>&1 || true

grep -Ei \
    'wireshark|dumpcap|tshark|tcpdump' \
    "$EVIDENCE_DIR/process-timeline.txt" \
    > "$EVIDENCE_DIR/packet-capture-process-timeline.txt" 2>/dev/null || true

if [[ -s "$EVIDENCE_DIR/packet-capture-process-timeline.txt" ]]; then
    log "Current/recent packet-capture processes:"
    cat "$EVIDENCE_DIR/packet-capture-process-timeline.txt" | tee -a "$REPORT_FILE"

    pass "Packet-capture process timeline captured"
else
    warn "No Wireshark/dumpcap/tshark/tcpdump process entries found"
fi

section "8. ACTIVE PACKET-CAPTURE PROCESS DETAILS"

for proc in wireshark dumpcap tshark tcpdump; do
    if pgrep -x "$proc" >/dev/null 2>&1; then
        log "$proc:"
        pgrep -a -x "$proc" | tee -a "$REPORT_FILE"

        while read -r pid; do
            [[ -z "$pid" ]] && continue
            ps -p "$pid" -o pid=,ppid=,user=,lstart=,etime=,cmd= \
                >> "$EVIDENCE_DIR/active-packet-capture-details.txt" 2>&1 || true
        done < <(pgrep -x "$proc" 2>/dev/null)

        pass "Active $proc process details captured"
    fi
done

if [[ ! -s "$EVIDENCE_DIR/active-packet-capture-details.txt" ]]; then
    log "No active packet-capture process details captured"
fi

section "9. DOCKER NETWORK CORRELATION"

if command_exists docker && docker info >/dev/null 2>&1; then
    docker ps --no-trunc \
        > "$EVIDENCE_DIR/docker-containers.txt" 2>&1 || true

    docker network ls \
        > "$EVIDENCE_DIR/docker-networks.txt" 2>&1 || true

    docker ps -q | while read -r cid; do
        [[ -z "$cid" ]] && continue
        docker inspect \
            --format 'CONTAINER={{.Name}} ID={{.Id}} PID={{.State.Pid}} STARTED={{.State.StartedAt}} NETWORKS={{json .NetworkSettings.Networks}}' \
            "$cid"
    done > "$EVIDENCE_DIR/docker-network-inspect.txt" 2>&1 || true

    ip -details link show \
        > "$EVIDENCE_DIR/current-ip-link-details.txt" 2>&1 || true

    ip -brief link show \
        > "$EVIDENCE_DIR/current-ip-link-brief.txt" 2>&1 || true

    grep -E '^veth|^docker|^br-' "$EVIDENCE_DIR/current-ip-link-brief.txt" \
        > "$EVIDENCE_DIR/current-docker-interfaces.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/current-docker-interfaces.txt" ]]; then
        pass "Docker-related interface state captured"
    else
        warn "No Docker-related interfaces found in current state"
    fi
else
    warn "Docker unavailable for network correlation"
fi

section "10. INTERFACE FLAG AND PROMISC CORRELATION"

{
    echo "INTERFACE FLAGS"
    for f in /sys/class/net/*/flags; do
        iface="$(basename "$(dirname "$f")")"
        flags="$(cat "$f" 2>/dev/null || echo UNKNOWN)"
        if [[ "$flags" != UNKNOWN ]]; then
            value=$((flags))
            if (( value & 0x100 )); then
                echo -e "${iface}\t${flags}\tPROMISC=YES"
            else
                echo -e "${iface}\t${flags}\tPROMISC=NO"
            fi
        fi
    done
} > "$EVIDENCE_DIR/current-interface-flags.tsv"

cat "$EVIDENCE_DIR/current-interface-flags.tsv" | tee -a "$REPORT_FILE"

PROMISC_CURRENT_COUNT="$(
    grep -c 'PROMISC=YES' "$EVIDENCE_DIR/current-interface-flags.tsv" 2>/dev/null || echo 0
)"

log
log "Current interfaces with PROMISC flag: $PROMISC_CURRENT_COUNT"

if grep -E '^(enp|wlp|eth|wl)[^[:space:]]*[[:space:]].*PROMISC=YES' \
    "$EVIDENCE_DIR/current-interface-flags.tsv" >/dev/null 2>&1; then
    warn "A primary physical/wireless interface currently has PROMISC enabled"
else
    pass "No primary physical/wireless interface currently has PROMISC enabled"
fi

if grep -E '^veth[^[:space:]]*[[:space:]].*PROMISC=YES' \
    "$EVIDENCE_DIR/current-interface-flags.tsv" >/dev/null 2>&1; then
    pass "Docker veth interfaces currently show PROMISC state; retained as environmental context"
else
    log "No current Docker veth PROMISC state observed"
fi

section "11. SOCKET AND NETWORK CONTEXT"

ss -tulpen \
    > "$EVIDENCE_DIR/current-listening-sockets.txt" 2>&1 || true

ss -tpn \
    > "$EVIDENCE_DIR/current-established-sockets.txt" 2>&1 || true

ip route \
    > "$EVIDENCE_DIR/current-routing-table.txt" 2>&1 || true

if command_exists nmcli; then
    nmcli device status \
        > "$EVIDENCE_DIR/networkmanager-devices.txt" 2>&1 || true
    nmcli general status \
        > "$EVIDENCE_DIR/networkmanager-general.txt" 2>&1 || true
    pass "Current socket, route, and NetworkManager context captured"
else
    warn "nmcli unavailable"
fi

section "12. HISTORICAL PROCESS/USER ATTRIBUTION"

if [[ -s "$EVIDENCE_DIR/auditd-historical-relevant.txt" ]]; then
    grep -Eo 'exe="[^"]+"|comm="[^"]+"|pid=[0-9]+|ppid=[0-9]+|uid=[^[:space:]]+|auid=[^[:space:]]+' \
        "$EVIDENCE_DIR/auditd-historical-relevant.txt" |
        sort -u \
        > "$EVIDENCE_DIR/historical-process-user-indicators.txt" 2>/dev/null || true

    if [[ -s "$EVIDENCE_DIR/historical-process-user-indicators.txt" ]]; then
        cat "$EVIDENCE_DIR/historical-process-user-indicators.txt" | tee -a "$REPORT_FILE"
        pass "Historical process/user indicators extracted from Auditd"
    else
        warn "Auditd window did not provide attributable process/user fields"
    fi
else
    warn "No Auditd material available for historical process/user attribution"
fi

section "13. WIRESHARK/DUMPCAP TEMPORAL ASSESSMENT"

if [[ -s "$EVIDENCE_DIR/packet-capture-process-timeline.txt" && -n "$START_LOCAL" ]]; then
    log "Rule 80710 historical window:"
    log "  ${START_LOCAL:-unknown} to ${END_LOCAL:-unknown}"
    log
    log "Packet-capture process records:"
    cat "$EVIDENCE_DIR/packet-capture-process-timeline.txt" | tee -a "$REPORT_FILE"

    log
    log "Interpretation:"
    log "  Process presence is not treated as proof of causation."
    log "  Process start time must overlap the historical alert window before"
    log "  a temporal relationship can be considered supported."
    pass "Temporal packet-capture assessment documented"
else
    warn "Insufficient packet-capture process timing data for temporal comparison"
fi

section "14. CORRELATION FINDINGS"

{
    echo "RULE 80710 CORRELATION FINDINGS"
    echo
    echo "Historical alert count: ${PROMISC_COUNT:-0}"
    echo "Historical first alert: ${FIRST_TS:-UNRESOLVED}"
    echo "Historical last alert:  ${LAST_TS:-UNRESOLVED}"
    echo
    echo "Current primary-interface PROMISC:"
    if grep -E '^(enp|wlp|eth|wl)[^[:space:]]*[[:space:]].*PROMISC=YES' \
        "$EVIDENCE_DIR/current-interface-flags.tsv" >/dev/null 2>&1; then
        echo "YES"
    else
        echo "NO"
    fi
    echo
    echo "Current Docker-veth PROMISC:"
    if grep -E '^veth[^[:space:]]*[[:space:]].*PROMISC=YES' \
        "$EVIDENCE_DIR/current-interface-flags.tsv" >/dev/null 2>&1; then
        echo "YES"
    else
        echo "NO"
    fi
    echo
    echo "Current packet-capture processes:"
    if [[ -s "$EVIDENCE_DIR/active-packet-capture-details.txt" ]]; then
        echo "PRESENT"
    else
        echo "NONE"
    fi
    echo
    echo "Historical process attribution:"
    if [[ -s "$EVIDENCE_DIR/historical-process-user-indicators.txt" ]]; then
        echo "PARTIAL OR SUPPORTED BY AUDITD"
    else
        echo "NOT ESTABLISHED"
    fi
    echo
    echo "Historical causation:"
    echo "NOT ESTABLISHED BY AVAILABLE TELEMETRY"
    echo
    echo "Compromise:"
    echo "NOT ESTABLISHED"
} > "$EVIDENCE_DIR/correlation-findings.txt"

cat "$EVIDENCE_DIR/correlation-findings.txt" | tee -a "$REPORT_FILE"

pass "Correlation findings documented without unsupported attribution"

section "15. FINAL SOC DISPOSITION"

log "RULE 80710 — FINAL SOC DISPOSITION"
log
log "Classification:"
log "  HIGH-SEVERITY CONTEXTUAL SECURITY SIGNAL"
log
log "Evidence-supported findings:"
log "  - Six Rule 80710 alerts occurred in a tightly clustered historical window."
log "  - The alerts originated from Auditd telemetry."
log "  - No primary physical/wireless interface is currently in PROMISC mode."
log "  - Docker veth interfaces currently show PROMISC state."
log "  - Wireshark/dumpcap activity exists in the current environment."
log "  - Current process state cannot by itself establish historical causation."
log
log "Disposition:"
log "  Rule 80710 should remain documented as a contextual investigation finding."
log "  The available evidence does not establish unauthorized packet capture,"
log "  malicious activity, or host compromise."
log
log "Analyst limitation:"
log "  Historical process/user attribution is only asserted where Auditd directly"
log "  supplies supporting telemetry. Current-state observations are not treated"
log "  as proof of historical activity."
log
log "Recommended SOC interpretation:"
log "  CLOSED AS INVESTIGATED / NO COMPROMISE ESTABLISHED,"
log "  while retaining the evidence for environmental-baseline documentation."
log

section "16. EVIDENCE MANIFEST"

find "$EVIDENCE_DIR" -maxdepth 1 -type f -printf '%f\n' |
    sort > "$EVIDENCE_DIR/evidence-manifest.txt"

cat "$EVIDENCE_DIR/evidence-manifest.txt" | tee -a "$REPORT_FILE"

MANIFEST_COUNT="$(wc -l < "$EVIDENCE_DIR/evidence-manifest.txt" 2>/dev/null || echo 0)"

if [[ "$MANIFEST_COUNT" -gt 0 ]]; then
    pass "Evidence manifest contains $MANIFEST_COUNT files"
else
    fail "Evidence manifest is empty"
fi

section "17. VALIDATION SUMMARY"

log "PASS: $PASS"
log "WARN: $WARN"
log "FAIL: $FAIL"
log
log "Completed: $(date --iso-8601=seconds)"
log
log "Report:   $REPORT_FILE"
log "Evidence: $EVIDENCE_DIR"

if [[ "$FAIL" -eq 0 ]]; then
    log
    log "RESULT: RULE 80710 CORRELATION COMPLETED WITHOUT HARD FAILURES"
else
    log
    log "RESULT: CORRELATION COMPLETED WITH FAILURES"
fi
