#!/usr/bin/env bash
# Microsoft Defender XDR + Microsoft Sentinel Master Build / Validate v1.0.0
# Builds the complete lab track, preserves evidence boundaries, and validates artifacts.
# This script NEVER fabricates cloud execution results and NEVER deletes lab data.

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_VERSION="1.0.0"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
RUN_CLOUD_CHECKS="${RUN_CLOUD_CHECKS:-0}"
MICROSOFT_ROOT="$ROOT/SIEM/Microsoft"
SENTINEL_ROOT="$MICROSOFT_ROOT/Sentinel"
EVIDENCE_ROOT="$MICROSOFT_ROOT/evidence/master-build"
MANIFEST="$MICROSOFT_ROOT/manifests/microsoft-defender-sentinel-manifest.json"
SUMMARY="$EVIDENCE_ROOT/validation-summary.txt"
PASS=0; WARN=0; FAIL=0
RESULTS="$(mktemp)"
trap 'rm -f "$RESULTS"' EXIT

pass(){ PASS=$((PASS+1)); printf 'PASS|%s\n' "$1" >> "$RESULTS"; printf '  [PASS] %s\n' "$1"; }
warn(){ WARN=$((WARN+1)); printf 'WARN|%s\n' "$1" >> "$RESULTS"; printf '  [WARN] %s\n' "$1"; }
fail(){ FAIL=$((FAIL+1)); printf 'FAIL|%s\n' "$1" >> "$RESULTS"; printf '  [FAIL] %s\n' "$1"; }

mkdir -p "$SENTINEL_ROOT" "$MICROSOFT_ROOT/manifests" "$EVIDENCE_ROOT"

command -v bash >/dev/null && pass "Bash available" || fail "Bash unavailable"
command -v git >/dev/null && pass "Git available" || fail "Git unavailable"
git rev-parse --show-toplevel >/dev/null 2>&1 && pass "Git repository detected" || fail "Git repository not detected"

if command -v jq >/dev/null 2>&1; then pass "jq available"; else warn "jq unavailable; Python JSON validation will be preferred"; fi
if command -v python3 >/dev/null 2>&1; then pass "Python 3 available"; else warn "Python 3 unavailable; JSON validation is limited"; fi

if command -v az >/dev/null 2>&1; then
  pass "Azure CLI available"
  if [[ "$RUN_CLOUD_CHECKS" == "1" ]]; then
    if az account show >/dev/null 2>&1; then pass "Azure CLI authenticated"
    else warn "Azure CLI installed but no active authenticated account detected"; fi
  else
    warn "Cloud checks disabled; use RUN_CLOUD_CHECKS=1 for Azure authentication status"
  fi
else
  warn "Azure CLI not installed; cloud execution checks skipped"
fi

declare -a LABS=(
"01|Sentinel Foundations"
"02|KQL Threat Hunting"
"03|Detection Engineering"
"04|Incident Investigation"
"05|Defender XDR Advanced Hunting"
"06|Response Automation"
"07|End-to-End SOC Case"
)

for item in "${LABS[@]}"; do
  IFS='|' read -r id title <<< "$item"
  dir="$SENTINEL_ROOT/Lab-$id-$title"
  mkdir -p "$dir/data" "$dir/evidence" "$dir/kql" "$dir/reports"
  touch "$dir/evidence/.gitkeep"
  cat > "$dir/README.md" <<EOF
# Lab $id — $title

**Status:** PREPARATION — not yet executed against a live Microsoft cloud environment.

## Objective
$title.

## Evidence boundary
This lab becomes EXECUTED only after the corresponding Microsoft cloud activity has actually been performed and validated. No screenshots, incidents, alerts, connector states, or cloud results are claimed until genuine evidence exists.

## Execution record
- Execution status: PREPARATION
- Environment: Not yet recorded
- Execution date: Not yet recorded
- Evidence: Not yet captured

## Validation
Run scripts/microsoft-defender-sentinel-MASTER-BUILD-VALIDATE.sh.
EOF
  cat > "$dir/evidence/README.md" <<EOF
# Evidence — Lab $id

No execution evidence is claimed yet.

When executed, document what was performed, when it was performed, the authorized environment, what the evidence demonstrates, and any limitations or redactions.

Never commit credentials, tokens, private keys, or sensitive tenant data.
EOF
  cat > "$dir/reports/validation.md" <<EOF
# Validation — Lab $id: $title

## Current status
PREPARATION

## Promotion requirements
- [ ] Microsoft service configuration actually performed
- [ ] Query, rule, or workflow actually tested
- [ ] Result independently reviewed
- [ ] Genuine evidence captured
- [ ] Evidence manifest completed
- [ ] No secrets or sensitive tenant data committed
EOF
done

cat > "$SENTINEL_ROOT/Lab-01-Sentinel Foundations/kql/README.md" <<'EOF'
# Lab 01 KQL
No cloud schema is assumed. Confirm the actual Sentinel tables and columns before writing executable queries.
EOF

cat > "$SENTINEL_ROOT/Lab-02-KQL Threat Hunting/kql/identity-hunting.kql" <<'EOF'
/*
Lab 02 — KQL Threat Hunting
Confirm the target table and columns exist before execution.
*/
SecurityEvent
| where TimeGenerated > ago(24h)
| summarize EventCount=count() by Account, Activity
| order by EventCount desc
EOF

cat > "$SENTINEL_ROOT/Lab-03-Detection Engineering/kql/detection-rule.kql" <<'EOF'
/*
Lab 03 — Detection Engineering
Schema and field semantics must be confirmed before deployment as an analytics rule.
*/
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID in (4624, 4625)
| summarize Attempts=count() by Account, Computer, EventID
| where Attempts >= 5
EOF

cat > "$SENTINEL_ROOT/Lab-04-Incident Investigation/kql/incident-hunting.kql" <<'EOF'
/*
Lab 04 — Incident Investigation
Pivot only through telemetry actually available in the authorized environment.
*/
SecurityEvent
| where TimeGenerated > ago(24h)
| summarize FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated), Events=count() by Account, Computer
| order by LastSeen desc
EOF

cat > "$SENTINEL_ROOT/Lab-05-Defender XDR Advanced Hunting/kql/advanced-hunting.kql" <<'EOF'
/*
Lab 05 — Defender XDR Advanced Hunting
Run in Microsoft Defender Advanced Hunting only when the relevant tables are available.
*/
DeviceLogonEvents
| where Timestamp > ago(24h)
| summarize Logons=count(), FirstSeen=min(Timestamp), LastSeen=max(Timestamp) by DeviceName, AccountName, LogonType
| order by Logons desc
EOF

cat > "$SENTINEL_ROOT/Lab-06-Response Automation/kql/response-validation.kql" <<'EOF'
/*
Lab 06 — Response Automation
Automation must be tested only in an authorized controlled environment.
*/
SecurityIncident
| where TimeGenerated > ago(7d)
| summarize Incidents=count(), LastIncident=max(TimeGenerated) by Severity, Status
| order by LastIncident desc
EOF

cat > "$SENTINEL_ROOT/Lab-07-End-to-End SOC Case/kql/end-to-end-case.kql" <<'EOF'
/*
Lab 07 — End-to-End SOC Case
Correlate the confirmed investigation scope before documenting a case.
*/
SecurityIncident
| where TimeGenerated > ago(30d)
| project TimeGenerated, IncidentNumber, Title, Severity, Status, Owner
| order by TimeGenerated desc
EOF

cat > "$MANIFEST" <<'EOF'
{
  "track": "Microsoft Defender XDR + Microsoft Sentinel",
  "script_version": "1.0.0",
  "status": "PREPARATION",
  "evidence_policy": "Only genuinely executed cloud activity may be marked EXECUTED.",
  "labs": [
    {"lab":"01","name":"Sentinel Foundations","status":"PREPARATION"},
    {"lab":"02","name":"KQL Threat Hunting","status":"PREPARATION"},
    {"lab":"03","name":"Detection Engineering","status":"PREPARATION"},
    {"lab":"04","name":"Incident Investigation","status":"PREPARATION"},
    {"lab":"05","name":"Defender XDR Advanced Hunting","status":"PREPARATION"},
    {"lab":"06","name":"Response Automation","status":"PREPARATION"},
    {"lab":"07","name":"End-to-End SOC Case","status":"PREPARATION"}
  ]
}
EOF

cat > "$MICROSOFT_ROOT/README.md" <<'EOF'
# Microsoft Defender XDR + Microsoft Sentinel

This is the next planned enterprise SIEM/security operations track following the completed Wazuh and Splunk work.

## Progression
Wazuh → Splunk → Microsoft Sentinel + Microsoft Defender XDR

## Labs
1. Sentinel Foundations
2. KQL Threat Hunting
3. Detection Engineering
4. Incident Investigation
5. Defender XDR Advanced Hunting
6. Response Automation
7. End-to-End SOC Case

All labs start as PREPARATION. They are promoted to EXECUTED only after genuine Microsoft cloud activity and evidence are captured.

## Master controller
Run:
scripts/microsoft-defender-sentinel-MASTER-BUILD-VALIDATE.sh

For an Azure authentication status check:
RUN_CLOUD_CHECKS=1 scripts/microsoft-defender-sentinel-MASTER-BUILD-VALIDATE.sh

The script never stores credentials.
EOF

if command -v python3 >/dev/null 2>&1; then
  python3 - "$MANIFEST" <<'PY'
import json,sys
with open(sys.argv[1],encoding="utf-8") as f: json.load(f)
PY
  if [[ $? -eq 0 ]]; then pass "Manifest JSON valid"; else fail "Manifest JSON invalid"; fi
else
  warn "Manifest JSON not parsed because Python 3 is unavailable"
fi

[[ -f "$MANIFEST" ]] && pass "Manifest present" || fail "Manifest missing"
[[ -f "$MICROSOFT_ROOT/README.md" ]] && pass "Microsoft track README present" || fail "Microsoft track README missing"
[[ "${#LABS[@]}" -eq 7 ]] && pass "Seven lab definitions registered" || fail "Expected seven lab definitions"

for item in "${LABS[@]}"; do
  IFS='|' read -r id title <<< "$item"
  dir="$SENTINEL_ROOT/Lab-$id-$title"
  for f in README.md evidence/README.md reports/validation.md; do
    [[ -f "$dir/$f" ]] && pass "Lab $id artifact: $f" || fail "Lab $id missing: $f"
  done
done

if git diff --name-only 2>/dev/null | grep -Eq '(^|/)\.env$|\.pem$|\.key$|credentials|secrets'; then
  fail "Potential credential/secret filename detected in working tree"
else
  pass "No obvious credential/secret filenames detected"
fi

cat > "$SUMMARY" <<EOF
Microsoft Defender XDR + Microsoft Sentinel Master Build v$SCRIPT_VERSION
Generated: $(date -Is)
Status: PREPARATION
PASS: $PASS
WARN: $WARN
FAIL: $FAIL
Cloud execution claims: NONE
EOF

echo
echo "============================================================"
echo "Microsoft Defender XDR + Microsoft Sentinel Master Build"
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
if (( FAIL == 0 )); then
  echo "RESULT: PASS WITH WARNINGS"
  exit 0
else
  echo "RESULT: FAIL"
  exit 1
fi
