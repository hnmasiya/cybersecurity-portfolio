#!/usr/bin/env bash
#
# Phase 2 - Lab 6
# Network Reconnaissance & Packet Investigation
#
# Controlled local-only investigation:
#   - Nmap reconnaissance against 127.0.0.1
#   - TShark packet capture on loopback
#   - Controlled local Python HTTP service
#   - HTTP traffic generation
#   - Packet analysis and Nmap/packet correlation
#   - Negative/control validation
#   - SHA-256 evidence manifest
#   - Analyst report
#
# Safety:
#   - Target is hard-coded to 127.0.0.1
#   - Capture is hard-coded to loopback interface "lo"
#   - No external scanning
#   - No credentials or secrets collected
#   - No destructive actions
#

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"
SCRIPT_VERSION="1.0.0"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
ISO_START="$(date --iso-8601=seconds)"

EVIDENCE_DIR="$REPO_ROOT/evidence/phase2-network-investigation-$TIMESTAMP"
REPORT_ROOT="$REPO_ROOT/reports"
REPORT_FILE="$REPORT_ROOT/phase2-network-investigation-$TIMESTAMP.txt"

TARGET_IP="127.0.0.1"
LO_INTERFACE="lo"
TEST_PORT="8765"
TEST_URL="http://${TARGET_IP}:${TEST_PORT}/"

HTTP_PID=""
CAPTURE_PID=""

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

declare -a FINDINGS=()
declare -a WARNINGS=()
declare -a FAILURES=()

mkdir -p "$EVIDENCE_DIR" "$REPORT_ROOT"

log() {
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    printf '[PASS] %s\n' "$*"
}

warn() {
    WARN_COUNT=$((WARN_COUNT + 1))
    WARNINGS+=("$*")
    printf '[WARN] %s\n' "$*"
}

fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILURES+=("$*")
    printf '[FAIL] %s\n' "$*" >&2
}

finding() {
    FINDINGS+=("$*")
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

cleanup() {
    local rc=$?

    if [[ -n "${HTTP_PID:-}" ]] && kill -0 "$HTTP_PID" 2>/dev/null; then
        kill "$HTTP_PID" 2>/dev/null || true
        wait "$HTTP_PID" 2>/dev/null || true
    fi

    if [[ -n "${CAPTURE_PID:-}" ]] && kill -0 "$CAPTURE_PID" 2>/dev/null; then
        kill "$CAPTURE_PID" 2>/dev/null || true
        wait "$CAPTURE_PID" 2>/dev/null || true
    fi

    return "$rc"
}

trap cleanup EXIT INT TERM

validate_environment() {
    log "Validating required tools..."

    local required=(
        nmap
        tshark
        python3
        curl
        ip
        ss
        sha256sum
    )

    local missing=0

    for tool in "${required[@]}"; do
        if command_exists "$tool"; then
            pass "Required tool available: $tool"
        else
            fail "Required tool missing: $tool"
            missing=1
        fi
    done

    (( missing == 0 )) || return 1

    if ip link show "$LO_INTERFACE" >/dev/null 2>&1; then
        pass "Loopback interface available: $LO_INTERFACE"
    else
        fail "Loopback interface unavailable: $LO_INTERFACE"
        return 1
    fi

    if [[ "$TARGET_IP" == "127.0.0.1" ]]; then
        pass "Target safety validation passed: 127.0.0.1"
    else
        fail "Safety validation failed: target is not loopback"
        return 1
    fi

    if [[ "$TEST_PORT" =~ ^[0-9]+$ ]] &&
       (( TEST_PORT >= 1024 && TEST_PORT <= 65535 )); then
        pass "Test port validated: $TEST_PORT"
    else
        fail "Invalid test port: $TEST_PORT"
        return 1
    fi
}

collect_environment() {
    log "Collecting environment information..."

    {
        echo "===== HOST ====="
        hostnamectl 2>/dev/null || hostname
        echo
        echo "===== KERNEL ====="
        uname -a
        echo
        echo "===== DATE ====="
        date --iso-8601=seconds
        echo
        echo "===== USER ====="
        id
        echo
        echo "===== LOOPBACK ====="
        ip addr show "$LO_INTERFACE"
        echo
        echo "===== ROUTING ====="
        ip route
        echo
        echo "===== LISTENING SOCKETS BEFORE LAB ====="
        ss -ltnp
        echo
        echo "===== NMAP ====="
        nmap --version | head -n 4
        echo
        echo "===== TSHARK ====="
        tshark --version | head -n 3
        echo
        echo "===== PYTHON ====="
        python3 --version
    } > "$EVIDENCE_DIR/environment.txt" 2>&1

    pass "Environment information collected"
}

check_port() {
    if ss -ltn 2>/dev/null |
        awk '{print $4}' |
        grep -Eq "(^|:)$TEST_PORT$"; then
        fail "Port $TEST_PORT is already in use; refusing to interfere with an existing service"
        ss -ltnp 2>/dev/null |
            grep -E "(^|:)$TEST_PORT\b" \
            > "$EVIDENCE_DIR/preexisting-port-$TEST_PORT.txt" || true
        return 1
    fi

    pass "Controlled HTTP test port $TEST_PORT is available"
}

start_http_service() {
    log "Starting controlled local HTTP service..."

    local webroot="$EVIDENCE_DIR/http-test-root"
    mkdir -p "$webroot"

    cat > "$webroot/index.html" <<'EOF'
<!doctype html>
<html>
<head><title>Phase 2 Network Investigation</title></head>
<body>
<h1>Controlled Phase 2 Network Investigation Test Service</h1>
<p>Local-only traffic generation for Lab 6.</p>
</body>
</html>
EOF

    (
        cd "$webroot"
        exec python3 -m http.server "$TEST_PORT" --bind "$TARGET_IP"
    ) > "$EVIDENCE_DIR/http-service.log" 2>&1 &

    HTTP_PID=$!
    sleep 2

    if kill -0 "$HTTP_PID" 2>/dev/null &&
       curl --silent --show-error --fail --max-time 3 \
       "$TEST_URL" > "$EVIDENCE_DIR/http-service-healthcheck.html"; then
        pass "Controlled HTTP service started successfully"
        pass "HTTP health check succeeded"
    else
        fail "Controlled HTTP service failed to start"
        return 1
    fi

    ss -ltnp 2>/dev/null |
        grep -E "(^|:)$TEST_PORT\b" \
        > "$EVIDENCE_DIR/http-listening-socket.txt" || true
}

run_nmap() {
    log "Running controlled Nmap reconnaissance against 127.0.0.1..."

    nmap \
        -Pn \
        -n \
        -sT \
        -sV \
        --version-light \
        -p "$TEST_PORT" \
        "$TARGET_IP" \
        -oN "$EVIDENCE_DIR/nmap-scan.txt" \
        -oX "$EVIDENCE_DIR/nmap-scan.xml" \
        > "$EVIDENCE_DIR/nmap-console.log" 2>&1

    if grep -Eq "open|filtered|closed" "$EVIDENCE_DIR/nmap-scan.txt"; then
        pass "Nmap completed against controlled loopback target"
    else
        warn "Nmap completed but no expected port-state line was detected"
    fi

    if grep -Eq "${TEST_PORT}/tcp[[:space:]]+open" \
        "$EVIDENCE_DIR/nmap-scan.txt"; then
        pass "Nmap identified TCP/$TEST_PORT as open"
        finding "Nmap confirmed the controlled TCP/$TEST_PORT service on 127.0.0.1."
    else
        warn "Nmap did not report TCP/$TEST_PORT as open"
    fi
}

start_capture() {
    log "Starting bounded loopback packet capture..."

    tshark \
        -i "$LO_INTERFACE" \
        -f "host $TARGET_IP and tcp port $TEST_PORT" \
        -a duration:12 \
        -w "$EVIDENCE_DIR/phase2-network-investigation.pcapng" \
        > "$EVIDENCE_DIR/tshark-capture.log" 2>&1 &

    CAPTURE_PID=$!
    sleep 2

    if kill -0 "$CAPTURE_PID" 2>/dev/null; then
        pass "TShark packet capture started"
    else
        fail "TShark packet capture failed to start"
        return 1
    fi
}

generate_traffic() {
    log "Generating controlled HTTP traffic..."

    {
        echo "===== CONTROLLED HTTP REQUEST 1 ====="
        date --iso-8601=seconds
        curl --silent --show-error --fail --max-time 3 -D - "$TEST_URL"

        echo
        echo "===== CONTROLLED HTTP REQUEST 2 ====="
        date --iso-8601=seconds
        curl --silent --show-error --fail --max-time 3 -D - "$TEST_URL"

        echo
        echo "===== CONTROLLED HTTP REQUEST 3 ====="
        date --iso-8601=seconds
        curl --silent --show-error --fail --max-time 3 -D - "$TEST_URL"
    } > "$EVIDENCE_DIR/controlled-http-traffic.txt" 2>&1

    pass "Controlled HTTP traffic generated"

    if grep -q "200 OK" "$EVIDENCE_DIR/controlled-http-traffic.txt"; then
        pass "HTTP 200 responses observed"
        finding "Controlled HTTP requests produced successful HTTP 200 responses."
    else
        warn "No HTTP 200 response found in traffic evidence"
    fi

    sleep 3

    if [[ -n "${CAPTURE_PID:-}" ]] &&
       kill -0 "$CAPTURE_PID" 2>/dev/null; then
        wait "$CAPTURE_PID" 2>/dev/null || true
        CAPTURE_PID=""
    fi

    if [[ -s "$EVIDENCE_DIR/phase2-network-investigation.pcapng" ]]; then
        pass "Packet capture file created"
    else
        fail "Packet capture file is missing or empty"
        return 1
    fi
}

analyze_packets() {
    log "Analyzing captured packets..."

    local pcap="$EVIDENCE_DIR/phase2-network-investigation.pcapng"

    tshark -r "$pcap" -q -z io,phs \
        > "$EVIDENCE_DIR/protocol-hierarchy.txt" 2>&1 || \
        warn "Protocol hierarchy extraction returned a non-zero status"

    tshark -r "$pcap" \
        -T fields -E header=y -E separator=$'\t' \
        -e frame.number -e frame.time \
        -e ip.src -e ip.dst \
        -e tcp.srcport -e tcp.dstport \
        -e http.request.method -e http.request.uri \
        -e http.response.code \
        > "$EVIDENCE_DIR/http-packet-fields.tsv" 2>&1 || \
        warn "HTTP field extraction returned a non-zero status"

    tshark -r "$pcap" -Y "http" \
        -T fields \
        -e frame.number -e ip.src -e ip.dst \
        -e http.request.method -e http.request.uri \
        -e http.response.code \
        > "$EVIDENCE_DIR/http-conversations.txt" 2>&1 || \
        warn "HTTP conversation extraction returned a non-zero status"

    tshark -r "$pcap" -Y "tcp" \
        -T fields \
        -e frame.number -e ip.src -e tcp.srcport \
        -e ip.dst -e tcp.dstport -e tcp.flags.str \
        > "$EVIDENCE_DIR/tcp-conversations.txt" 2>&1 || \
        warn "TCP conversation extraction returned a non-zero status"

    if grep -q "GET" "$EVIDENCE_DIR/http-conversations.txt"; then
        pass "HTTP GET requests identified in packet evidence"
        finding "Packet analysis identified controlled HTTP GET traffic."
    else
        warn "HTTP GET requests were not identified in decoded packet fields"
    fi

    if grep -q "200" "$EVIDENCE_DIR/http-conversations.txt"; then
        pass "HTTP 200 response identified in packet evidence"
    else
        warn "HTTP 200 response was not identified in decoded packet fields"
    fi

    if grep -q "127.0.0.1" "$EVIDENCE_DIR/tcp-conversations.txt"; then
        pass "Loopback TCP communication confirmed"
    else
        warn "Loopback TCP address was not identified in decoded TCP fields"
    fi
}

negative_test() {
    log "Running negative/control validation..."

    local unrelated_port="8766"

    if grep -Eq "[[:space:]]$unrelated_port([[:space:]]|$)" \
        "$EVIDENCE_DIR/http-conversations.txt" 2>/dev/null; then
        fail "Unexpected unrelated port $unrelated_port found in HTTP evidence"
    else
        pass "Negative test: unrelated port $unrelated_port absent"
    fi

    if grep -Eq "tcp.*$unrelated_port|$unrelated_port.*tcp" \
        "$EVIDENCE_DIR/tcp-conversations.txt" 2>/dev/null; then
        fail "Unexpected TCP/$unrelated_port activity detected"
    else
        pass "Negative test: unrelated TCP/$unrelated_port activity absent"
    fi
}

correlate() {
    log "Correlating Nmap and packet evidence..."

    local nmap_open=0
    local packet_http=0

    if grep -Eq "${TEST_PORT}/tcp[[:space:]]+open" \
        "$EVIDENCE_DIR/nmap-scan.txt"; then
        nmap_open=1
    fi

    if grep -q "GET" "$EVIDENCE_DIR/http-conversations.txt"; then
        packet_http=1
    fi

    if (( nmap_open == 1 && packet_http == 1 )); then
        pass "Nmap and packet evidence correlate"
        finding "Nmap service discovery and packet capture independently corroborated the controlled HTTP service."
    elif (( nmap_open == 1 )); then
        warn "Nmap identified the service but packet HTTP evidence was incomplete"
    elif (( packet_http == 1 )); then
        warn "Packet evidence identified HTTP activity but Nmap did not confirm the port"
    else
        warn "Nmap and packet evidence did not fully correlate"
    fi
}

generate_hashes() {
    log "Generating SHA-256 evidence manifest..."

    (
        cd "$EVIDENCE_DIR"
        find . -type f ! -name "SHA256SUMS.txt" -print0 |
            sort -z |
            xargs -0 sha256sum
    ) > "$EVIDENCE_DIR/SHA256SUMS.txt"

    if [[ -s "$EVIDENCE_DIR/SHA256SUMS.txt" ]]; then
        pass "SHA-256 evidence manifest generated"
    else
        fail "SHA-256 evidence manifest is empty"
    fi
}

generate_report() {
    local end_time
    end_time="$(date --iso-8601=seconds)"

    {
        echo "PHASE 2 — LAB 6"
        echo "NETWORK RECONNAISSANCE & PACKET INVESTIGATION"
        echo "================================================"
        echo
        echo "Script: $SCRIPT_NAME"
        echo "Version: $SCRIPT_VERSION"
        echo "Start: $ISO_START"
        echo "End: $end_time"
        echo
        echo "CONTROLLED SCOPE"
        echo "---------------"
        echo "Target: $TARGET_IP"
        echo "Interface: $LO_INTERFACE"
        echo "TCP port: $TEST_PORT"
        echo "URL: $TEST_URL"
        echo "External systems scanned: NO"
        echo
        echo "VALIDATION SUMMARY"
        echo "------------------"
        echo "PASS: $PASS_COUNT"
        echo "WARN: $WARN_COUNT"
        echo "FAIL: $FAIL_COUNT"
        echo
        echo "KEY FINDINGS"
        echo "------------"

        if (( ${#FINDINGS[@]} == 0 )); then
            echo "None recorded."
        else
            for item in "${FINDINGS[@]}"; do
                echo "- $item"
            done
        fi

        echo
        echo "WARNINGS"
        echo "--------"

        if (( ${#WARNINGS[@]} == 0 )); then
            echo "None."
        else
            for item in "${WARNINGS[@]}"; do
                echo "- $item"
            done
        fi

        echo
        echo "FAILURES"
        echo "--------"

        if (( ${#FAILURES[@]} == 0 )); then
            echo "None."
        else
            for item in "${FAILURES[@]}"; do
                echo "- $item"
            done
        fi

        echo
        echo "EVIDENCE"
        echo "--------"
        find "$EVIDENCE_DIR" -maxdepth 1 -type f -printf '%f\n' |
            sort

        echo
        echo "ANALYST INTERPRETATION"
        echo "----------------------"
        echo "This was a controlled local security investigation."
        echo "Observed network activity was intentionally generated by the lab."
        echo "The evidence demonstrates reconnaissance, packet capture,"
        echo "protocol analysis, and correlation rather than evidence of"
        echo "a real-world compromise."

        echo
        echo "MITRE ATT&CK CONTEXT"
        echo "--------------------"
        echo "Network Service Scanning (T1046) may provide contextual mapping"
        echo "for the controlled Nmap reconnaissance activity."
        echo "This mapping does not establish adversary activity."

        echo
        echo "FINAL DISPOSITION"
        echo "-----------------"

        if (( FAIL_COUNT == 0 )); then
            echo "LAB 6 COMPLETED WITHOUT HARD FAILURES"
        else
            echo "LAB 6 COMPLETED WITH FAILURES REQUIRING REVIEW"
        fi
    } > "$REPORT_FILE"

    pass "Investigation report generated: $REPORT_FILE"
}

main() {
    echo
    echo "============================================================"
    echo " PHASE 2 — LAB 6: NETWORK INVESTIGATION"
    echo "============================================================"
    echo " Target : $TARGET_IP"
    echo " Port   : $TEST_PORT"
    echo " Capture: $LO_INTERFACE"
    echo " Scope  : LOCAL CONTROLLED LAB ONLY"
    echo "============================================================"
    echo

    validate_environment || true
    collect_environment

    if (( FAIL_COUNT > 0 )); then
        generate_report
        return 1
    fi

    check_port || true

    if (( FAIL_COUNT > 0 )); then
        generate_report
        return 1
    fi

    start_http_service || true
    run_nmap || true
    start_capture || true
    generate_traffic || true
    analyze_packets || true
    negative_test || true
    correlate || true
    generate_hashes
    generate_report

    echo
    echo "============================================================"
    echo " LAB 6 SUMMARY"
    echo "============================================================"
    echo " PASS : $PASS_COUNT"
    echo " WARN : $WARN_COUNT"
    echo " FAIL : $FAIL_COUNT"
    echo " REPORT: $REPORT_FILE"
    echo " EVIDENCE: $EVIDENCE_DIR"
    echo "============================================================"

    if (( FAIL_COUNT > 0 )); then
        return 1
    fi

    return 0
}

main "$@"
