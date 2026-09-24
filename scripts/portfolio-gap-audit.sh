#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="evidence/portfolio-gap-audit"
mkdir -p "$OUT"

REPORT="$OUT/portfolio-gap-audit-$STAMP.md"
PENDING="$OUT/pending-actionable.txt"
REFERENCES="$OUT/pending-references-in-scripts.txt"
VULN="$OUT/vulnerability-scanner-status.txt"

PASS=0; WARN=0; FAIL=0
pass(){ PASS=$((PASS+1)); echo "PASS: $*"; }
warn(){ WARN=$((WARN+1)); echo "WARN: $*"; }
fail(){ FAIL=$((FAIL+1)); echo "FAIL: $*"; }

{
  echo "# Cybersecurity Portfolio Gap Audit"
  echo
  echo "- Run: $STAMP"
  echo "- Repository: $ROOT"
  echo "- Mode: READ-ONLY"
  echo
  echo "## Classification rules"
  echo
  echo "1. Text inside helper/audit scripts is treated as reference material."
  echo "2. Terraform source alone is not deployment evidence."
  echo "3. Tool names in an inventory are not execution evidence."
  echo "4. Pending live-validation markers remain pending until evidence exists."
} >"$REPORT"

echo "# Actionable pending statuses" >"$PENDING"
echo "# Intentional references inside scripts/audit material" >"$REFERENCES"

pending_hits() {
  local f="$1"
  grep -nE \
    '(^|[^[:alnum:]])PENDING LIVE VALIDATION([^[:alnum:]]|$)|(^|[^[:alnum:]])PENDING VALIDATION([^[:alnum:]]|$)|Status:[[:space:]]*(Infrastructure-as-Code, not yet deployed|PENDING)|not yet deployed|planned; not yet started|pending access' \
    "$f" 2>/dev/null |
    grep -vEi 'must be labelled|must be labeled|use[[:space:]].*(PENDING LIVE VALIDATION|PENDING VALIDATION)|where appropriate|if not executed|unexecuted scenarios must|instruction|example' || true
}

find . -type f \( -name '*.md' -o -name '*.html' \) \
  ! -path './.git/*' \
  ! -path './evidence/portfolio-gap-audit/*' \
  ! -path './evidence/portfolio-single-repair-*/*' \
  ! -path './scripts/*' \
  ! -path './setup-tools/*' \
  -print0 |
while IFS= read -r -d '' f; do
  hits="$(pending_hits "$f")"
  [[ -n "$hits" ]] || continue
  {
    printf '%s\n' "$f"
    printf '%s\n' "$hits"
  } >>"$PENDING"
done

if [[ "$(wc -l < "$PENDING")" -gt 1 ]]; then
  warn "Actionable pending statuses found; see $PENDING"
else
  pass "No actionable pending-status markers found in portfolio-facing documentation"
fi

grep -RInE \
  --include='*.sh' \
  --exclude='portfolio-gap-audit.sh' \
  --exclude='portfolio-single-repair.sh' \
  --exclude-dir=.git \
  'PENDING LIVE VALIDATION|PENDING VALIDATION|not yet deployed|not yet started|pending access' \
  . 2>/dev/null >"$REFERENCES" || true

{
  echo
  echo "## Core repository files"
  for f in README.md SECURITY.md .gitignore SOC-ANALYST-EVIDENCE-MAP.md \
           SECURITY-TOOLS-INVENTORY.md verify-portfolio.sh \
           Scripts/portfolio_quality_check.py tests; do
    [[ -e "$f" ]] && echo "- PASS: $f" || { echo "- FAIL: $f missing"; FAIL=$((FAIL+1)); }
  done
} >>"$REPORT"

if grep -RInE --exclude-dir=.git \
   'National Diploma in Information Communication Technology|Harare Polytechnic' \
   . >/dev/null 2>&1; then
  fail "Legacy education reference found"
  echo "- FAIL: legacy education / Harare Polytechnic reference found" >>"$REPORT"
else
  pass "No legacy education reference found"
  echo "- PASS: no legacy education / Harare Polytechnic reference found" >>"$REPORT"
fi

{
  echo
  echo "## Vulnerability scanner evidence"
  scanner_count="$(
    find evidence reports SOC Vulnerability-Assessment Offensive-Security \
      -type f 2>/dev/null |
    grep -Ei '/(nessus|openvas|greenbone|gvm)[^/]*\.(nessus|xml|html|csv|json|txt|md)$' |
    grep -vE '/(README|index|inventory)[^/]*$' |
    wc -l
  )"
  if [[ "${scanner_count:-0}" -gt 0 ]]; then
    echo "- PASS: $scanner_count scanner result/report file(s) found"
  else
    echo "- WARN: no Nessus/OpenVAS/Greenbone/GVM result evidence found"
    echo "- Defensible status: PLANNED / NOT STARTED"
  fi
} >>"$REPORT"

{
  echo
  echo "## GCP Landing Zone"
  gcp_exec="$(
    find evidence reports Cloud-Security -type f 2>/dev/null |
    grep -Ei '(terraform.*(apply|show|plan)|deployment|gcp.*(deployed|apply)|tfstate|outputs)' |
    grep -vE '(README|checklist|index)' |
    wc -l
  )"
  if [[ "${gcp_exec:-0}" -gt 0 ]]; then
    echo "- NOTE: deployment-related artifacts exist; verify content before calling this deployed"
  else
    echo "- WARN: architecture/IaC remains the defensible classification"
  fi
} >>"$REPORT"

{
  echo
  echo "## Microsoft Sentinel / KQL"
  sent_count="$(
    find evidence reports SOC -type f 2>/dev/null |
    grep -Ei 'sentinel|kql|query|execution|alert|result' |
    grep -Ei '\.(json|csv|txt|log|html|md)$' |
    wc -l
  )"
  if [[ "${sent_count:-0}" -gt 0 ]]; then
    echo "- NOTE: related artifacts exist; content review is required before classifying them as live Sentinel execution"
  else
    echo "- WARN: treat Sentinel/KQL as methodology/training unless live execution evidence exists"
  fi
} >>"$REPORT"

{
  echo
  echo "## Validation-sensitive areas"
  echo "- SOC Detection Validation: pending scenarios remain pending unless linked execution evidence exists."
  echo "- Cloud Detection / Unified Cloud Detection: do not convert pending-live-validation text to complete without execution evidence."
  echo "- Phishing Investigation: distinguish simulation/training from independent investigation evidence."
  echo "- MITRE ATT&CK: technique mappings do not by themselves prove execution."
  echo
  echo "## Inventory"
  echo "- README count: $(find . -type f -name 'README.md' ! -path './.git/*' ! -path './evidence/portfolio-gap-audit/*' | wc -l)"
  echo "- Evidence/report count: $(find evidence reports -type f 2>/dev/null | wc -l)"
  echo
  echo "## Git state"
  echo "- Branch: $(git branch --show-current)"
  echo "- Worktree:"
  git status --short
  echo
  echo "## Summary"
  echo "PASS=$PASS WARN=$WARN FAIL=$FAIL"
  echo
  echo "Artifacts:"
  echo "- $REPORT"
  echo "- $PENDING"
  echo "- $REFERENCES"
  echo "- $VULN"
} >>"$REPORT"

echo "Audit complete: $REPORT"
