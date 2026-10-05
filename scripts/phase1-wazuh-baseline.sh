#!/usr/bin/env bash
# ============================================================
# Phase 1 — Wazuh Baseline & Health Audit
# Portfolio: hnmasiya/cybersecurity-portfolio
#
# Purpose:
#   Perform a read-only security/SIEM baseline assessment of
#   the local Wazuh deployment and generate evidence suitable
#   for cybersecurity portfolio documentation.
#
# Scope:
#   - Host OS and resources
#   - Wazuh agent version/status
#   - Wazuh Docker manager/indexer/dashboard versions
#   - Agent registration
#   - Manager/agent connectivity
#   - Wazuh log sources
#   - Relevant listening ports
#   - Recent Wazuh errors/warnings
#   - Indexer connectivity
#
# IMPORTANT:
#   This script makes NO configuration changes.
# ============================================================

set -uo pipefail

SCRIPT_NAME="phase1-wazuh-baseline"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$REPO_ROOT/reports"
EVIDENCE_DIR="$REPO_ROOT/evidence/${SCRIPT_NAME}-${TIMESTAMP}"

REPORT="$REPORT_DIR/${SCRIPT_NAME}-${TIMESTAMP}.txt"

mkdir -p "$REPORT_DIR" "$EVIDENCE_DIR"

PASS=0
WARN=0
FAIL=0

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

run_capture() {
    local outfile="$1"
    shift

    "$@" > "$outfile" 2>&1
    local rc=$?

    cat "$outfile" >> "$REPORT"
    return "$rc"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# Start report
# ------------------------------------------------------------

cat > "$REPORT" <<EOF
============================================================
WAZUH BASELINE & HEALTH AUDIT
============================================================

Script:       $SCRIPT_NAME
Timestamp:    $(date '+%Y-%m-%d %H:%M:%S %Z')
Host:         $(hostname)
Repository:   $REPO_ROOT

PURPOSE
-------
Read-only baseline assessment of the local Wazuh deployment.

NO CONFIGURATION CHANGES ARE PERFORMED BY THIS SCRIPT.

============================================================

EOF

section "1. HOST INFORMATION"

log "Hostname:"
hostname 2>&1 | tee -a "$REPORT"

log
log "Kernel:"
uname -a 2>&1 | tee -a "$REPORT"

log
log "Operating System:"
if [[ -f /etc/os-release ]]; then
    cat /etc/os-release | tee -a "$REPORT"
else
    warn "/etc/os-release not found."
fi

log
log "CPU:"
if command_exists lscpu; then
    lscpu | grep -E '^(Model name|CPU\(s\)|Architecture)' | tee -a "$REPORT"
else
    warn "lscpu unavailable."
fi

log
log "Memory:"
free -h | tee -a "$REPORT"

log
log "Disk:"
df -h / | tee -a "$REPORT"

log
log "Systemd failed units:"
FAILED_UNITS="$(systemctl --failed --no-legend 2>/dev/null || true)"

if [[ -z "$FAILED_UNITS" ]]; then
    pass "No failed systemd units detected."
else
    warn "Failed systemd units detected:"
    echo "$FAILED_UNITS" | tee -a "$REPORT"
fi


# ------------------------------------------------------------
# 2. WAZUH AGENT
# ------------------------------------------------------------

section "2. WAZUH AGENT"

if [[ -x /var/ossec/bin/wazuh-control ]]; then

    log "Wazuh agent version:"
    AGENT_VERSION_RAW="$(
        /var/ossec/bin/wazuh-control info 2>/dev/null |
        grep -iE 'VERSION|WAZUH_VERSION' |
        head -1 || true
    )"

    if [[ -z "$AGENT_VERSION_RAW" ]]; then
        AGENT_VERSION_RAW="$(
            /var/ossec/bin/wazuh-control -V 2>/dev/null |
            head -1 || true
        )"
    fi

    echo "$AGENT_VERSION_RAW" | tee -a "$REPORT"

    AGENT_VERSION="$(
        echo "$AGENT_VERSION_RAW" |
        grep -oE '[0-9]+\.[0-9]+\.[0-9]+' |
        head -1 || true
    )"

    if [[ -n "$AGENT_VERSION" ]]; then
        pass "Detected Wazuh agent version: $AGENT_VERSION"
    else
        warn "Could not reliably parse the Wazuh agent version."
    fi

    log
    log "Wazuh agent service:"
    if systemctl is-active --quiet wazuh-agent; then
        pass "wazuh-agent service is active."
    else
        fail "wazuh-agent service is not active."
    fi

    log
    log "Wazuh agent process status:"
    /var/ossec/bin/wazuh-control status 2>&1 | tee -a "$REPORT"

else
    fail "Wazuh agent control utility not found at /var/ossec/bin/wazuh-control."
    AGENT_VERSION=""
fi


# ------------------------------------------------------------
# 3. WAZUH CONFIGURATION
# ------------------------------------------------------------

section "3. WAZUH AGENT CONFIGURATION"

AGENT_CONFIG="/var/ossec/etc/ossec.conf"

if [[ -f "$AGENT_CONFIG" ]]; then

    pass "Wazuh agent configuration exists: $AGENT_CONFIG"

    log
    log "Configured manager endpoints:"
    grep -nE '<address>|<port>|<protocol>' "$AGENT_CONFIG" 2>/dev/null |
        tee "$EVIDENCE_DIR/manager-endpoint-config.txt" |
        tee -a "$REPORT"

    log
    log "Configured local log sources:"
    grep -nE '<localfile>|<log_format>|<location>|<command>|<full_command>' \
        "$AGENT_CONFIG" 2>/dev/null |
        tee "$EVIDENCE_DIR/localfile-config.txt" |
        tee -a "$REPORT"

    LOCALFILE_COUNT="$(
        grep -c '<localfile>' "$AGENT_CONFIG" 2>/dev/null || echo 0
    )"

    log
    log "Localfile blocks detected: $LOCALFILE_COUNT"

    if [[ "$LOCALFILE_COUNT" -gt 0 ]]; then
        pass "Wazuh is configured with $LOCALFILE_COUNT local log collection blocks."
    else
        warn "No <localfile> blocks detected."
    fi

else
    fail "Wazuh configuration file not found: $AGENT_CONFIG"
fi


# ------------------------------------------------------------
# 4. DOCKER WAZUH STACK
# ------------------------------------------------------------

section "4. DOCKER WAZUH STACK"

if command_exists docker; then

    pass "Docker CLI detected."

    MANAGER_CONTAINER="$(docker ps \
        --filter 'name=single-node-wazuh.manager' \
        --format '{{.Names}}' |
        head -1)"

    INDEXER_CONTAINER="$(docker ps \
        --filter 'name=single-node-wazuh.indexer' \
        --format '{{.Names}}' |
        head -1)"

    DASHBOARD_CONTAINER="$(docker ps \
        --filter 'name=single-node-wazuh.dashboard' \
        --format '{{.Names}}' |
        head -1)"

    log
    log "Wazuh containers:"
    docker ps \
        --filter 'name=single-node-wazuh' \
        --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' |
        tee "$EVIDENCE_DIR/wazuh-containers.txt" |
        tee -a "$REPORT"

    # Manager
    if [[ -n "$MANAGER_CONTAINER" ]]; then
        MANAGER_IMAGE="$(
            docker inspect "$MANAGER_CONTAINER" \
            --format '{{.Config.Image}}' 2>/dev/null || true
        )"

        log
        log "Manager container:"
        log "  Name:  $MANAGER_CONTAINER"
        log "  Image: $MANAGER_IMAGE"

        if [[ "$MANAGER_IMAGE" =~ :([0-9]+\.[0-9]+\.[0-9]+) ]]; then
            MANAGER_VERSION="${BASH_REMATCH[1]}"
            pass "Detected Wazuh manager version: $MANAGER_VERSION"
        else
            MANAGER_VERSION=""
            warn "Could not parse manager version from image."
        fi
    else
        fail "Wazuh manager container not found/running."
        MANAGER_VERSION=""
    fi

    # Indexer
    if [[ -n "$INDEXER_CONTAINER" ]]; then
        INDEXER_IMAGE="$(
            docker inspect "$INDEXER_CONTAINER" \
            --format '{{.Config.Image}}' 2>/dev/null || true
        )"

        log
        log "Indexer container:"
        log "  Name:  $INDEXER_CONTAINER"
        log "  Image: $INDEXER_IMAGE"

        if [[ "$INDEXER_IMAGE" =~ :([0-9]+\.[0-9]+\.[0-9]+) ]]; then
            INDEXER_VERSION="${BASH_REMATCH[1]}"
            pass "Detected Wazuh indexer version: $INDEXER_VERSION"
        else
            INDEXER_VERSION=""
            warn "Could not parse indexer version."
        fi
    else
        fail "Wazuh indexer container not found/running."
        INDEXER_VERSION=""
    fi

    # Dashboard
    if [[ -n "$DASHBOARD_CONTAINER" ]]; then
        DASHBOARD_IMAGE="$(
            docker inspect "$DASHBOARD_CONTAINER" \
            --format '{{.Config.Image}}' 2>/dev/null || true
        )"

        log
        log "Dashboard container:"
        log "  Name:  $DASHBOARD_CONTAINER"
        log "  Image: $DASHBOARD_IMAGE"

        if [[ "$DASHBOARD_IMAGE" =~ :([0-9]+\.[0-9]+\.[0-9]+) ]]; then
            DASHBOARD_VERSION="${BASH_REMATCH[1]}"
            pass "Detected Wazuh dashboard version: $DASHBOARD_VERSION"
        else
            DASHBOARD_VERSION=""
            warn "Could not parse dashboard version."
        fi
    else
        fail "Wazuh dashboard container not found/running."
        DASHBOARD_VERSION=""
    fi

else
    fail "Docker CLI is not available."
    MANAGER_VERSION=""
    INDEXER_VERSION=""
    DASHBOARD_VERSION=""
fi


# ------------------------------------------------------------
# 5. VERSION CONSISTENCY
# ------------------------------------------------------------

section "5. VERSION CONSISTENCY"

log "Agent version:     ${AGENT_VERSION:-UNKNOWN}"
log "Manager version:   ${MANAGER_VERSION:-UNKNOWN}"
log "Indexer version:   ${INDEXER_VERSION:-UNKNOWN}"
log "Dashboard version: ${DASHBOARD_VERSION:-UNKNOWN}"

if [[ -n "$AGENT_VERSION" && -n "$MANAGER_VERSION" ]]; then

    if [[ "$AGENT_VERSION" == "$MANAGER_VERSION" ]]; then
        pass "Wazuh agent and manager versions match."
    else
        warn "VERSION MISMATCH: agent=$AGENT_VERSION manager=$MANAGER_VERSION"
        log
        log "ACTION REQUIRED:"
        log "Investigate version alignment before performing upgrades."
        log "Do NOT blindly upgrade or downgrade the Wazuh stack."
    fi
else
    warn "Unable to perform complete agent/manager version comparison."
fi

if [[ -n "$MANAGER_VERSION" && -n "$INDEXER_VERSION" ]]; then
    if [[ "$MANAGER_VERSION" == "$INDEXER_VERSION" ]]; then
        pass "Manager and indexer versions match."
    else
        warn "Manager/indexer version mismatch detected."
    fi
fi

if [[ -n "$MANAGER_VERSION" && -n "$DASHBOARD_VERSION" ]]; then
    if [[ "$MANAGER_VERSION" == "$DASHBOARD_VERSION" ]]; then
        pass "Manager and dashboard versions match."
    else
        warn "Manager/dashboard version mismatch detected."
    fi
fi


# ------------------------------------------------------------
# 6. MANAGER STATUS
# ------------------------------------------------------------

section "6. WAZUH MANAGER STATUS"

if [[ -n "$MANAGER_CONTAINER" ]]; then

    log "Manager process status:"
    docker exec "$MANAGER_CONTAINER" \
        /var/ossec/bin/wazuh-control status 2>&1 |
        tee "$EVIDENCE_DIR/manager-status.txt" |
        tee -a "$REPORT"

    MANAGER_STATUS="$(
        docker exec "$MANAGER_CONTAINER" \
        /var/ossec/bin/wazuh-control status 2>/dev/null || true
    )"

    if echo "$MANAGER_STATUS" |
        grep -qE 'wazuh-remoted is running|wazuh-analysisd is running'; then
        pass "Core Wazuh manager services are running."
    else
        warn "Could not confirm expected core manager services."
    fi

else
    fail "Manager status could not be checked."
fi


# ------------------------------------------------------------
# 7. REGISTERED AGENTS
# ------------------------------------------------------------

section "7. REGISTERED WAZUH AGENTS"

if [[ -n "$MANAGER_CONTAINER" ]]; then

    log "Registered agents:"
    docker exec "$MANAGER_CONTAINER" \
        /var/ossec/bin/manage_agents -l 2>&1 |
        tee "$EVIDENCE_DIR/registered-agents.txt" |
        tee -a "$REPORT"

    REGISTERED_COUNT="$(
        docker exec "$MANAGER_CONTAINER" \
        /var/ossec/bin/manage_agents -l 2>/dev/null |
        grep -cE 'ID: [0-9]+' || echo 0
    )"

    log
    log "Registered agent records detected: $REGISTERED_COUNT"

    if [[ "$REGISTERED_COUNT" -gt 0 ]]; then
        pass "At least one Wazuh agent is registered."
    else
        warn "No registered agents detected."
    fi

else
    fail "Unable to inspect registered agents."
fi


# ------------------------------------------------------------
# 8. NETWORK LISTENING PORTS
# ------------------------------------------------------------

section "8. WAZUH NETWORK PORTS"

PORTS=(1514 1515 55000 9200 443)

if command_exists ss; then

    ss -lntup 2>/dev/null |
        tee "$EVIDENCE_DIR/listening-ports.txt" |
        tee -a "$REPORT"

    log

    for PORT in "${PORTS[@]}"; do

        if ss -lntup 2>/dev/null | grep -qE ":${PORT}\b"; then
            pass "Port $PORT is listening."
        else
            warn "Port $PORT is not detected as listening."
        fi

    done

else
    warn "ss command unavailable; port audit skipped."
fi


# ------------------------------------------------------------
# 9. INDEXER CONNECTIVITY
# ------------------------------------------------------------

section "9. WAZUH INDEXER CONNECTIVITY"

INDEXER_CHECK="$EVIDENCE_DIR/indexer-connectivity.txt"

if command_exists curl; then

    HTTP_CODE="$(
        curl -sk \
            --connect-timeout 5 \
            --max-time 10 \
            -o "$INDEXER_CHECK" \
            -w '%{http_code}' \
            https://127.0.0.1:9200 2>/dev/null || true
    )"

    log "Indexer HTTPS response code: ${HTTP_CODE:-NO_RESPONSE}"

    case "$HTTP_CODE" in
        200|401|403)
            pass "Wazuh indexer HTTPS endpoint is reachable."
            ;;
        000|"")
            fail "Wazuh indexer HTTPS endpoint could not be reached."
            ;;
        *)
            warn "Indexer responded with HTTP status $HTTP_CODE."
            ;;
    esac

    log
    log "Indexer response:"
    cat "$INDEXER_CHECK" 2>/dev/null | head -20 | tee -a "$REPORT"

else
    warn "curl unavailable; indexer connectivity test skipped."
fi


# ------------------------------------------------------------
# 10. AGENT CONNECTIVITY
# ------------------------------------------------------------

section "10. WAZUH AGENT CONNECTIVITY"

AGENT_LOG="/var/ossec/logs/ossec.log"

if [[ -f "$AGENT_LOG" ]]; then

    log "Recent agent connectivity events:"
    grep -Ei \
        'Connected to the server|Agent is now online|Connection refused|SSL error|Waiting for server reply|Unable to connect|No available server' \
        "$AGENT_LOG" |
        tail -40 |
        tee "$EVIDENCE_DIR/agent-connectivity-events.txt" |
        tee -a "$REPORT"

    if grep -qE 'Agent is now online|Connected to the server' "$AGENT_LOG"; then
        pass "Agent log contains successful manager connectivity events."
    else
        warn "No recent successful agent connectivity event was detected."
    fi

else
    warn "Agent log not found: $AGENT_LOG"
fi


# ------------------------------------------------------------
# 11. MANAGER LOG REVIEW
# ------------------------------------------------------------

section "11. MANAGER ERROR/WARNING REVIEW"

if [[ -n "$MANAGER_CONTAINER" ]]; then

    docker exec "$MANAGER_CONTAINER" \
        sh -c '
            if [ -f /var/ossec/logs/ossec.log ]; then
                grep -Ei "ERROR|WARNING|connection refused|SSL error|indexer" \
                    /var/ossec/logs/ossec.log |
                tail -100
            fi
        ' 2>&1 |
        tee "$EVIDENCE_DIR/manager-errors-warnings.txt" |
        tee -a "$REPORT"

    MANAGER_ERRORS="$(
        docker exec "$MANAGER_CONTAINER" \
        sh -c '
            if [ -f /var/ossec/logs/ossec.log ]; then
                grep -Eic "ERROR|connection refused|SSL error" /var/ossec/logs/ossec.log
            else
                echo 0
            fi
        ' 2>/dev/null || echo 0
    )"

    log
    log "Manager error/connection-related event count: $MANAGER_ERRORS"

    if [[ "$MANAGER_ERRORS" -eq 0 ]]; then
        pass "No matching manager ERROR/connection-refused events detected."
    else
        warn "Manager contains $MANAGER_ERRORS matching ERROR/connection-related events. Review evidence."
    fi

else
    warn "Manager log review skipped."
fi


# ------------------------------------------------------------
# 12. AGENT LOG REVIEW
# ------------------------------------------------------------

section "12. AGENT ERROR/WARNING REVIEW"

if [[ -f "$AGENT_LOG" ]]; then

    grep -Ei \
        'ERROR|WARNING|connection refused|SSL error|Unable to connect|No available server' \
        "$AGENT_LOG" |
        tail -100 |
        tee "$EVIDENCE_DIR/agent-errors-warnings.txt" |
        tee -a "$REPORT"

else
    warn "Agent log unavailable."
fi


# ------------------------------------------------------------
# 13. SECURITY-RELEVANT LOG SOURCES
# ------------------------------------------------------------

section "13. SECURITY-RELEVANT LOG SOURCES"

if [[ -f "$AGENT_CONFIG" ]]; then

    SECURITY_SOURCES=(
        "/var/log/auth.log"
        "/var/log/syslog"
        "/var/log/audit/audit.log"
        "/var/log/apache2/access.log"
        "/var/log/apache2/error.log"
    )

    for SOURCE in "${SECURITY_SOURCES[@]}"; do

        if grep -Fq "$SOURCE" "$AGENT_CONFIG"; then
            pass "Configured log source: $SOURCE"
        else
            warn "Not explicitly configured in ossec.conf: $SOURCE"
        fi

    done

else
    warn "Cannot evaluate security log sources."
fi


# ------------------------------------------------------------
# 14. DOCKER RESOURCE SNAPSHOT
# ------------------------------------------------------------

section "14. DOCKER RESOURCE SNAPSHOT"

if command_exists docker; then

    docker stats --no-stream \
        --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}' \
        2>/dev/null |
        tee "$EVIDENCE_DIR/docker-resource-snapshot.txt" |
        tee -a "$REPORT"

else
    warn "Docker resource snapshot unavailable."
fi


# ------------------------------------------------------------
# 15. FINAL ASSESSMENT
# ------------------------------------------------------------

section "15. BASELINE ASSESSMENT"

log "Checks passed : $PASS"
log "Warnings      : $WARN"
log "Failures      : $FAIL"

log
log "Key findings:"

if [[ -n "$AGENT_VERSION" && -n "$MANAGER_VERSION" &&
      "$AGENT_VERSION" != "$MANAGER_VERSION" ]]; then

    log "- Wazuh version alignment requires review:"
    log "  Agent   : $AGENT_VERSION"
    log "  Manager : $MANAGER_VERSION"

fi

if [[ -n "$MANAGER_VERSION" && -n "$INDEXER_VERSION" &&
      "$MANAGER_VERSION" != "$INDEXER_VERSION" ]]; then

    log "- Manager and indexer versions are not aligned."

fi

if [[ "$FAIL" -gt 0 ]]; then
    log "- One or more critical baseline checks failed."
fi

if [[ "$WARN" -gt 0 ]]; then
    log "- Warnings require investigation before further lab expansion."
fi

log
log "Evidence directory:"
log "$EVIDENCE_DIR"

log
log "Report:"
log "$REPORT"

log
log "IMPORTANT:"
log "This audit did not intentionally modify Wazuh, Docker, networking,"
log "configuration files, services, packages, or security controls."

log
log "============================================================"
log "END OF WAZUH BASELINE AUDIT"
log "============================================================"


# ------------------------------------------------------------
# Save machine-readable summary
# ------------------------------------------------------------

cat > "$EVIDENCE_DIR/summary.txt" <<EOF
Phase 1 Wazuh Baseline Summary
==============================

Timestamp: $TIMESTAMP
Host: $(hostname)

Agent Version: ${AGENT_VERSION:-UNKNOWN}
Manager Version: ${MANAGER_VERSION:-UNKNOWN}
Indexer Version: ${INDEXER_VERSION:-UNKNOWN}
Dashboard Version: ${DASHBOARD_VERSION:-UNKNOWN}

PASS: $PASS
WARN: $WARN
FAIL: $FAIL

No configuration changes were performed.
EOF

echo
echo "============================================================"
echo "AUDIT COMPLETE"
echo "============================================================"
echo "Report:   $REPORT"
echo "Evidence: $EVIDENCE_DIR"
echo
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "============================================================"

# Exit non-zero only for actual failures.
if [[ "$FAIL" -gt 0 ]]; then
    exit 2
fi

exit 0
