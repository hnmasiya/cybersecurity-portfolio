#!/usr/bin/env bash

set -uo pipefail

SCRIPT_NAME="phase1-wazuh-promiscuous-mode-investigation"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REPORT_DIR="${REPO_DIR}/reports"
EVIDENCE_DIR="${REPO_DIR}/evidence/${SCRIPT_NAME}-${TIMESTAMP}"
REPORT_FILE="${REPORT_DIR}/${SCRIPT_NAME}-${TIMESTAMP}.txt"

mkdir -p "$REPORT_DIR" "$EVIDENCE_DIR"

PASS=0
WARN=0
FAIL=0

log() {
    printf '%s\n' "$*" | tee -a "$REPORT_FILE"
}

section() {
    printf '\n================================================================\n' | tee -a "$REPORT_FILE"
    printf '%s\n' "$1" | tee -a "$REPORT_FILE"
    printf '================================================================\n' | tee -a "$REPORT_FILE"
}

pass() {
    PASS=$((PASS + 1))
    log "[PASS] $1"
}

warn() {
    WARN=$((WARN + 1))
    log "[WARN] $1"
}

fail() {
    FAIL=$((FAIL + 1))
    log "[FAIL] $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

{
    echo "PHASE 1 LAB 3.2 — WAZUH RULE 80710 FOCUSED INVESTIGATION"
    echo
    echo "Started:       $(date --iso-8601=seconds)"
    echo "Repository:    ${REPO_DIR}"
    echo "Evidence:      ${EVIDENCE_DIR}"
    echo "Report:        ${REPORT_FILE}"
    echo "Host:          $(hostname)"
    echo "Kernel:        $(uname -sr)"
} > "$REPORT_FILE"

section "1. ENVIRONMENT VALIDATION"

if command_exists docker; then
    pass "Docker is available"
else
    fail "Docker is unavailable"
fi

if docker info >/dev/null 2>&1; then
    pass "Docker daemon is accessible"
else
    fail "Docker daemon is inaccessible"
fi

WAZUH_MANAGER="$(docker ps --format '{{.Names}}' 2>/dev/null | grep 'wazuh.manager' | head -n1 || true)"

if [[ -n "$WAZUH_MANAGER" ]]; then
    pass "Wazuh manager container detected: ${WAZUH_MANAGER}"
else
    fail "Wazuh manager container not detected"
fi

section "2. CAPTURE RULE 80710 ALERTS"

if [[ -n "$WAZUH_MANAGER" ]]; then

    docker exec "$WAZUH_MANAGER" \
        sh -c 'tail -n 5000 /var/ossec/logs/alerts/alerts.json' \
        > "${EVIDENCE_DIR}/alerts-recent.jsonl" 2>/dev/null || true

    if [[ -s "${EVIDENCE_DIR}/alerts-recent.jsonl" ]]; then
        pass "Recent manager alert data captured"
    else
        fail "Unable to capture recent manager alert data"
    fi

    if command_exists jq; then
        jq -c '
            select((.rule.id // "") == "80710")
        ' "${EVIDENCE_DIR}/alerts-recent.jsonl" \
            > "${EVIDENCE_DIR}/rule-80710-alerts.jsonl" 2>/dev/null || true

        PROMISC_COUNT="$(wc -l < "${EVIDENCE_DIR}/rule-80710-alerts.jsonl" 2>/dev/null || echo 0)"

        if [[ "$PROMISC_COUNT" -eq 6 ]]; then
            pass "Captured all 6 observed Rule 80710 alerts"
        elif [[ "$PROMISC_COUNT" -gt 0 ]]; then
            warn "Captured ${PROMISC_COUNT} Rule 80710 alerts; expected 6 based on Lab 3.1 evidence"
        else
            fail "No Rule 80710 alerts captured"
        fi

        jq -r '
            [
                .timestamp,
                (.agent.id // ""),
                (.agent.name // ""),
                (.rule.id // ""),
                (.rule.level // ""),
                (.rule.description // ""),
                (.decoder.name // ""),
                (.location // "")
            ] | @tsv
        ' "${EVIDENCE_DIR}/rule-80710-alerts.jsonl" \
            > "${EVIDENCE_DIR}/rule-80710-timeline.tsv" 2>/dev/null || true
    else
        fail "jq is unavailable"
    fi
fi

section "3. RULE 80710 ALERT TIMELINE"

if [[ -s "${EVIDENCE_DIR}/rule-80710-timeline.tsv" ]]; then
    cat "${EVIDENCE_DIR}/rule-80710-timeline.tsv" | tee -a "$REPORT_FILE"
    pass "Rule 80710 timeline generated"
else
    warn "Rule 80710 timeline unavailable"
fi

section "4. NETWORK INTERFACE STATE"

if command_exists ip; then
    ip -details link show > "${EVIDENCE_DIR}/ip-link-details.txt" 2>&1 || true
    ip -brief link show > "${EVIDENCE_DIR}/ip-link-brief.txt" 2>&1 || true
    ip -brief address show > "${EVIDENCE_DIR}/ip-addresses.txt" 2>&1 || true

    pass "Current network interface state captured"

    awk '
        /^[0-9]+:/ {
            iface=$2
            sub(/:/, "", iface)
        }
        /PROMISC/ {
            print iface
        }
    ' "${EVIDENCE_DIR}/ip-link-details.txt" \
        | sort -u \
        > "${EVIDENCE_DIR}/promisc-interfaces.txt"

    if [[ -s "${EVIDENCE_DIR}/promisc-interfaces.txt" ]]; then
        log "Interfaces currently reporting PROMISC:"
        cat "${EVIDENCE_DIR}/promisc-interfaces.txt" | tee -a "$REPORT_FILE"
        warn "One or more interfaces currently report PROMISC; historical causation is not established"
    else
        pass "No currently reported PROMISC interface in ip-link state"
    fi
else
    fail "ip command unavailable"
fi

section "5. INTERFACE FLAG STATE"

{
    echo "Interface flag analysis"
    echo

    for iface_path in /sys/class/net/*; do
        [[ -e "$iface_path" ]] || continue

        iface="$(basename "$iface_path")"
        flags="$(cat "$iface_path/flags" 2>/dev/null || true)"

        if [[ -n "$flags" ]]; then
            printf '%s\t%s\t' "$iface" "$flags"

            if (( flags & 0x100 )); then
                printf 'PROMISC=YES\n'
            else
                printf 'PROMISC=NO\n'
            fi
        fi
    done
} > "${EVIDENCE_DIR}/interface-flags.tsv"

cat "${EVIDENCE_DIR}/interface-flags.tsv" | tee -a "$REPORT_FILE"

section "6. SOCKET AND PROCESS CONTEXT"

if command_exists ss; then
    ss -tulpen > "${EVIDENCE_DIR}/ss-listening-sockets.txt" 2>&1 || true
    ss -tpn > "${EVIDENCE_DIR}/ss-process-connections.txt" 2>&1 || true
    pass "Current socket and process/network context captured"
else
    warn "ss command unavailable"
fi

if command_exists ps; then
    ps auxww > "${EVIDENCE_DIR}/process-list.txt" 2>&1 || true
    pass "Current process inventory captured"
else
    warn "ps command unavailable"
fi

section "7. PACKET-CAPTURE TOOLING CONTEXT"

if command_exists tcpdump; then
    tcpdump --version > "${EVIDENCE_DIR}/tcpdump-version.txt" 2>&1 || true
    tcpdump -D > "${EVIDENCE_DIR}/tcpdump-interfaces.txt" 2>&1 || true
    pass "tcpdump availability and interface inventory captured"
else
    warn "tcpdump is not installed"
fi

if command_exists wireshark; then
    wireshark --version > "${EVIDENCE_DIR}/wireshark-version.txt" 2>&1 || true
    pass "Wireshark is installed"
else
    warn "Wireshark executable not found"
fi

section "8. NETWORKMANAGER CONTEXT"

if command_exists nmcli; then
    nmcli general status > "${EVIDENCE_DIR}/nmcli-general.txt" 2>&1 || true
    nmcli device status > "${EVIDENCE_DIR}/nmcli-devices.txt" 2>&1 || true
    pass "NetworkManager state captured"
else
    warn "nmcli unavailable"
fi

section "9. AUDITD CORRELATION"

if [[ -r /var/log/audit/audit.log ]]; then
    cp /var/log/audit/audit.log \
        "${EVIDENCE_DIR}/audit.log" 2>/dev/null || true

    grep -Ei \
        'promisc|promiscuous|PACKET_MMAP|AF_PACKET|tcpdump|wireshark|dumpcap|tshark|ip link|iproute|netlink' \
        /var/log/audit/audit.log \
        > "${EVIDENCE_DIR}/audit-network-relevant.txt" 2>/dev/null || true

    pass "Auditd network-relevant telemetry captured"
else
    if sudo -n test -r /var/log/audit/audit.log 2>/dev/null; then
        sudo -n cat /var/log/audit/audit.log \
            > "${EVIDENCE_DIR}/audit.log" 2>/dev/null || true

        sudo -n grep -Ei \
            'promisc|promiscuous|PACKET_MMAP|AF_PACKET|tcpdump|wireshark|dumpcap|tshark|ip link|iproute|netlink' \
            /var/log/audit/audit.log \
            > "${EVIDENCE_DIR}/audit-network-relevant.txt" 2>/dev/null || true

        pass "Auditd network-relevant telemetry captured with non-interactive sudo"
    else
        warn "Auditd log is not readable without interactive privilege escalation"
    fi
fi

if [[ ! -s "${EVIDENCE_DIR}/audit-network-relevant.txt" ]]; then
    log "No matching network/promiscuous-mode Auditd strings were found in the captured audit log."
fi

section "10. JOURNAL CORRELATION"

if command_exists journalctl; then
    journalctl --no-pager -k \
        > "${EVIDENCE_DIR}/kernel-journal.txt" 2>&1 || true

    journalctl --no-pager \
        | grep -Ei \
            'promisc|promiscuous|tcpdump|wireshark|dumpcap|tshark|networkmanager|network|link' \
        > "${EVIDENCE_DIR}/journal-network-relevant.txt" 2>/dev/null || true

    pass "Journal network-context telemetry captured"
else
    warn "journalctl unavailable"
fi

section "11. USER-SPACE PACKET CAPTURE PROCESS CHECK"

if command_exists pgrep; then
    {
        echo "tcpdump:"
        pgrep -a tcpdump || true
        echo
        echo "dumpcap:"
        pgrep -a dumpcap || true
        echo
        echo "tshark:"
        pgrep -a tshark || true
        echo
        echo "wireshark:"
        pgrep -a wireshark || true
    } > "${EVIDENCE_DIR}/packet-capture-processes.txt"

    cat "${EVIDENCE_DIR}/packet-capture-processes.txt" | tee -a "$REPORT_FILE"
    pass "Packet-capture process check completed"
else
    warn "pgrep unavailable"
fi

section "12. RULE 80710 CONTEXTUAL ASSESSMENT"

cat > "${EVIDENCE_DIR}/investigation-assessment.txt" <<'ASSESSMENT'
RULE 80710 — CONTEXTUAL INVESTIGATION

Alert:
  Wazuh Rule 80710
  "Auditd: Device enables promiscuous mode."
  Level: 10

Observed frequency:
  Six alerts were observed in the Lab 3.1 evidence.

Investigation approach:
  1. Preserve the original Wazuh alerts.
  2. Capture current network interface state.
  3. Inspect interface PROMISC flags.
  4. Capture socket/process context.
  5. Check packet-capture tooling and active packet-capture processes.
  6. Correlate available Auditd telemetry.
  7. Correlate relevant system journal telemetry.

Disposition principle:
  The Rule 80710 alert is treated as a high-severity contextual
  signal requiring investigation.

  Presence of Rule 80710 alone does NOT establish malicious activity,
  unauthorized packet capture, or compromise.

  A final disposition must be based on correlated endpoint,
  Auditd, process, network-interface, and user/session evidence.

Current-state limitation:
  Current interface state does not by itself prove what happened at
  the historical alert timestamp.

Historical causation limitation:
  This investigation does not infer a process, user, or intent unless
  the available telemetry directly supports that conclusion.
ASSESSMENT

cat "${EVIDENCE_DIR}/investigation-assessment.txt" | tee -a "$REPORT_FILE"
pass "Contextual assessment documented without asserting unsupported compromise"

section "13. EVIDENCE MANIFEST"

find "$EVIDENCE_DIR" \
    -maxdepth 1 \
    -type f \
    -printf '%f\n' \
    | sort \
    > "${EVIDENCE_DIR}/evidence-manifest.txt"

MANIFEST_COUNT="$(wc -l < "${EVIDENCE_DIR}/evidence-manifest.txt" 2>/dev/null || echo 0)"

cat "${EVIDENCE_DIR}/evidence-manifest.txt" | tee -a "$REPORT_FILE"

if [[ "$MANIFEST_COUNT" -gt 0 ]]; then
    pass "Evidence manifest generated with ${MANIFEST_COUNT} files"
else
    fail "Evidence manifest is empty"
fi

section "14. FINAL INVESTIGATION ASSESSMENT"

log "Rule 80710 investigation completed."
log
log "Observed Rule 80710 alerts: ${PROMISC_COUNT:-0}"
log
log "Current interface PROMISC state:"
if [[ -s "${EVIDENCE_DIR}/promisc-interfaces.txt" ]]; then
    cat "${EVIDENCE_DIR}/promisc-interfaces.txt" | tee -a "$REPORT_FILE"
else
    log "  No currently reported PROMISC interfaces"
fi

log
log "Important:"
log "  Current-state evidence and historical alerts must not be conflated."
log "  Rule 80710 remains a contextual investigation finding."
log "  No compromise is established by this procedure alone."

section "15. VALIDATION SUMMARY"

log "PASS: ${PASS}"
log "WARN: ${WARN}"
log "FAIL: ${FAIL}"
log
log "Completed: $(date --iso-8601=seconds)"
log
log "Report:   ${REPORT_FILE}"
log "Evidence: ${EVIDENCE_DIR}"

if [[ "$FAIL" -eq 0 ]]; then
    log
    log "RESULT: RULE 80710 INVESTIGATION COMPLETED WITHOUT HARD FAILURES"
else
    log
    log "RESULT: INVESTIGATION COMPLETED WITH FAILURES"
fi
