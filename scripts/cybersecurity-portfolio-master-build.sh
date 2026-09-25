#!/usr/bin/env bash
# Cybersecurity Portfolio Master Build v1.0.0
# Validates the existing portfolio and orchestrates the retained Splunk child builder.
# It does not replace individual lab builders or overwrite existing evidence.

set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_VERSION="1.0.0"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
RUN_SPLUNK="$(printenv RUN_SPLUNK 2>/dev/null || printf '0')"
SPLUNK_CHILD="$ROOT/scripts/splunk-labs-03-06-master-build.sh"
EVIDENCE_ROOT="$ROOT/evidence/master-portfolio-build"
CATALOG="$ROOT/CYBERSECURITY-LAB-CATALOG.md"
SUMMARY="$EVIDENCE_ROOT/validation-summary.txt"

PASS=0
WARN=0
FAIL=0
RESULTS_FILE="/tmp/cybersecurity-master-results-$$.txt"
trap 'rm -f "$RESULTS_FILE"' EXIT

pass() { PASS=$((PASS+1)); printf 'PASS|%s\n' "$1" >> "$RESULTS_FILE"; printf '  [PASS] %s\n' "$1"; }
warn() { WARN=$((WARN+1)); printf 'WARN|%s\n' "$1" >> "$RESULTS_FILE"; printf '  [WARN] %s\n' "$1"; }
fail() { FAIL=$((FAIL+1)); printf 'FAIL|%s\n' "$1" >> "$RESULTS_FILE"; printf '  [FAIL] %s\n' "$1"; }
log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }
rel() { printf '%s' "$1" | sed "s#^$ROOT/##"; }

[[ -d "$ROOT/.git" ]] || { fail "Repository root unavailable"; exit 1; }
cd "$ROOT"
mkdir -p "$EVIDENCE_ROOT"
: > "$RESULTS_FILE"

printf '\n============================================================\n'
printf 'Cybersecurity Portfolio Master Build v%s\n' "$SCRIPT_VERSION"
printf '============================================================\n'
printf 'Repository: %s\n' "$ROOT"
printf 'RUN_SPLUNK=%s\n\n' "$RUN_SPLUNK"

# Core structure
log "Validating core portfolio structure."
while IFS='|' read -r label path; do
  [[ -z "$label" ]] && continue
  if [[ -e "$ROOT/$path" ]]; then pass "Repository component: $label"
  else warn "Repository component absent: $label -> $path"; fi
done <<'EOF'
index.md|index.md
SIEM README|SIEM/README.md
Splunk README|SIEM/Splunk/README.md
Scripts|scripts
Web Security|Web-Security
Cloud Security|Cloud-Security
SOC|SOC
EOF

# Bash syntax
log "Validating Bash scripts."
script_count=0
syntax_failures=0
while IFS= read -r -d '' file; do
  script_count=$((script_count+1))
  if ! bash -n "$file" >/dev/null 2>&1; then
    syntax_failures=$((syntax_failures+1))
    fail "Bash syntax: $(rel "$file")"
  fi
done < <(find "$ROOT/scripts" -type f -name '*.sh' -print0)
if [[ "$syntax_failures" -eq 0 ]]; then
  pass "Bash syntax validation: $script_count scripts"
fi

# Existing portfolio domains
log "Discovering existing security domains."
while IFS='|' read -r label path; do
  [[ -z "$label" ]] && continue
  if [[ -e "$ROOT/$path" ]]; then pass "Portfolio domain: $label"
  else warn "Portfolio domain absent: $label -> $path"; fi
done <<'EOF'
DVWA|Web-Security/DVWA
SIEM|SIEM
Wazuh|SIEM/Wazuh
Splunk|SIEM/Splunk
Network Security|Network-Security
Cloud Security|Cloud-Security
SOC|SOC
Security Automation|scripts
Coursework|Coursework
EOF

# Splunk continuity
log "Validating Splunk Labs 01-06."
lab=1
while IFS= read -r path; do
  if [[ -d "$ROOT/$path" ]]; then
    printf -v lab_id '%02d' "$lab"
    pass "Splunk Lab $lab_id exists"
  else
    printf -v lab_id '%02d' "$lab"
    warn "Splunk Lab $lab_id absent: $path"
  fi
  lab=$((lab+1))
done <<'EOF'
SIEM/Splunk/Lab-01-SSH-Authentication-Hunting
SIEM/Splunk/Lab-02-Windows-Sysmon-Process-Investigation
SIEM/Splunk/Lab-03-Web-Attack-HTTP-Investigation
SIEM/Splunk/Lab-04-Detection-Engineering-SPL-Alert-Logic
SIEM/Splunk/Lab-05-Dashboarding-SOC-Monitoring
SIEM/Splunk/Lab-06-End-to-End-SOC-Investigation
EOF

while IFS= read -r builder; do
  if [[ -f "$ROOT/$builder" ]]; then pass "Retained builder: $builder"
  else fail "Required builder missing: $builder"; fi
done <<'EOF'
scripts/splunk-lab-01-build.sh
scripts/splunk-lab-02-build.sh
scripts/splunk-labs-03-06-master-build.sh
EOF

# Dashboard safety preflight
log "Running dashboard preflight."
json_count=0
json_failures=0
while IFS= read -r -d '' file; do
  json_count=$((json_count+1))
  if ! python3 - "$file" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as fh:
    json.load(fh)
PY
  then
    json_failures=$((json_failures+1))
    fail "Invalid JSON: $(rel "$file")"
  fi
done < <(find "$ROOT/SIEM/Splunk" -type f -name '*.json' -print0 2>/dev/null)

if [[ "$json_count" -gt 0 && "$json_failures" -eq 0 ]]; then
  pass "Splunk JSON syntax validation: $json_count files"
elif [[ "$json_count" -eq 0 ]]; then
  warn "No Splunk JSON dashboard definitions found yet"
fi

if grep -RqsE 'layoutDefinitions|dataSources|visualizations' "$ROOT/SIEM/Splunk" 2>/dev/null; then
  pass "Dashboard Studio structural definitions detected"
else
  warn "Dashboard Studio structural definitions not detected"
fi

# Cross-domain discovery
log "Checking cross-domain evidence."
while IFS='|' read -r label path; do
  [[ -z "$label" ]] && continue
  if [[ -e "$ROOT/$path" ]]; then pass "Cross-domain evidence: $label"
  else warn "Cross-domain path absent: $label -> $path"; fi
done <<'EOF'
DVWA|Web-Security/DVWA
Wazuh|SIEM/Wazuh
Splunk|SIEM/Splunk
Nmap|Nmap
Wireshark|Wireshark
MITRE ATT&CK|SOC/MITRE-ATT&CK
Cloud Security|Cloud-Security
EOF

# Master catalog
log "Generating master catalog."
python3 - "$ROOT" "$CATALOG" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
out = Path(sys.argv[2])
labs = [
("01","SSH Authentication Hunting","Authentication hunting","SIEM/Splunk/Lab-01-SSH-Authentication-Hunting"),
("02","Windows / Sysmon Process Investigation","Endpoint investigation","SIEM/Splunk/Lab-02-Windows-Sysmon-Process-Investigation"),
("03","Web Attack / HTTP Investigation","Web attack investigation","SIEM/Splunk/Lab-03-Web-Attack-HTTP-Investigation"),
("04","Detection Engineering / SPL Alert Logic","Detection engineering","SIEM/Splunk/Lab-04-Detection-Engineering-SPL-Alert-Logic"),
("05","Dashboarding / SOC Monitoring","SOC monitoring","SIEM/Splunk/Lab-05-Dashboarding-SOC-Monitoring"),
("06","End-to-End SOC Investigation","Incident response","SIEM/Splunk/Lab-06-End-to-End-SOC-Investigation"),
]
domains = [
("Web Security","Web-Security"),("DVWA","Web-Security/DVWA"),
("Wazuh","SIEM/Wazuh"),("Splunk","SIEM/Splunk"),
("Network Security","Network-Security"),("Cloud Security","Cloud-Security"),
("SOC / Detection Engineering","SOC"),("Security Automation","scripts"),
("Coursework","Coursework"),
]
lines = [
"# Cybersecurity Lab Catalog","",
"> Generated by cybersecurity-portfolio-master-build.sh v1.0.0.","",
"## Splunk SOC progression","",
"| Lab | Focus | Role | Status |","|---|---|---|---|"
]
for num,name,role,path in labs:
    status = "Present" if (root/path).is_dir() else "Planned / not present"
    lines.append(f"| {num} | {name} | {role} | {status} |")
lines += [
"","### Investigation-to-response chain","",
"Telemetry → Investigation → Detection Engineering → SOC Monitoring → Incident Response",
"",
"Lab 01: authentication threat hunting.",
"Lab 02: endpoint/process investigation.",
"Lab 03: web/application attack investigation.",
"Lab 04: detection engineering and validation.",
"Lab 05: SOC monitoring and visualization.",
"Lab 06: end-to-end incident investigation.",
"",
"## Existing portfolio domains","",
"| Domain | Path | Status |","|---|---|---|"
]
for name,path in domains:
    status = "Present" if (root/path).exists() else "Not present at expected path"
    lines.append(f"| {name} | {path} | {status} |")
lines += [
"","## Integration rule","",
"Individual builders remain authoritative. The master build validates and catalogs them; it does not replace existing evidence.",
]
out.write_text("\n".join(lines)+"\n", encoding="utf-8")
PY
pass "Master catalog generated: $(rel "$CATALOG")"

# Retained child builder
if [[ "$RUN_SPLUNK" == "1" ]]; then
  log "Executing retained Splunk Labs 03-06 builder."
  if bash "$SPLUNK_CHILD"; then pass "Splunk Labs 03-06 child builder completed"
  else fail "Splunk Labs 03-06 child builder failed"; fi
else
  log "Live Splunk execution skipped; running child artifact-only validation."
  preflight="/tmp/splunk-labs-03-06-master-preflight.log"
  if RUN_SPLUNK=0 bash "$SPLUNK_CHILD" >"$preflight" 2>&1; then
    pass "Splunk Labs 03-06 artifact validation"
  else
    fail "Splunk Labs 03-06 artifact validation failed"
    sed -n '1,100p' "$preflight" || true
  fi
fi

# Machine-readable evidence
python3 - "$EVIDENCE_ROOT/portfolio-inventory.json" "$ROOT" <<'PY'
import json, sys
from pathlib import Path
root = Path(sys.argv[2])
data = {"master_version":"1.0.0","preserves_individual_builders":True,
        "child_builder":"scripts/splunk-labs-03-06-master-build.sh","splunk_labs":{}}
for n in range(1,7):
    matches = list((root/"SIEM/Splunk").glob(f"Lab-{n:02d}-*"))
    data["splunk_labs"][f"{n:02d}"] = {
        "present": bool(matches),
        "paths": [str(p.relative_to(root)) for p in matches],
    }
Path(sys.argv[1]).write_text(json.dumps(data, indent=2)+"\n", encoding="utf-8")
PY

{
  echo "Cybersecurity Portfolio Master Build v$SCRIPT_VERSION"
  echo "UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Repository: $ROOT"
  echo "PASS=$PASS WARN=$WARN FAIL=$FAIL"
  cat "$RESULTS_FILE"
} > "$SUMMARY"

printf '\n============================================================\n'
printf 'MASTER BUILD SUMMARY\n'
printf '============================================================\n'
printf 'PASS: %s\nWARN: %s\nFAIL: %s\n' "$PASS" "$WARN" "$FAIL"
printf 'Catalog: %s\n' "$(rel "$CATALOG")"
printf 'Evidence: %s\n' "$(rel "$EVIDENCE_ROOT")"

if [[ "$FAIL" -gt 0 ]]; then
  printf '\nMASTER BUILD RESULT: FAIL\n'
  exit 1
fi

printf '\nMASTER BUILD RESULT: PASS WITH WARNINGS\n'
