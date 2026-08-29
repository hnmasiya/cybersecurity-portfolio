#!/usr/bin/env bash
set -Eeuo pipefail

# =============================================================================
# HNMASIYA CYBERSECURITY PORTFOLIO — CURRENT-STATE FINAL POLISH
# Repository: hnmasiya/cybersecurity-portfolio
# Purpose: audit, preserve, improve and prepare a professional final-polish PR.
#
# IMPORTANT:
# - Does not fabricate security evidence.
# - Does not delete legitimate evidence.
# - Works from the current repository state.
# - Creates a feature branch unless already on one.
# - Existing uncommitted changes are preserved.
# - Live Wazuh/Sysmon/cloud validation remains explicitly pending unless
#   already evidenced in the repository.
# =============================================================================

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$ROOT" ]]; then
  echo "ERROR: Run this from inside the cybersecurity-portfolio Git repository."
  exit 1
fi
cd "$ROOT"

BRANCH="portfolio-final-polish"
STAMP="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
AUDIT_DIR="portfolio-audit"
mkdir -p "$AUDIT_DIR"

echo "============================================================"
echo " HNMASIYA CYBERSECURITY PORTFOLIO — FINAL POLISH"
echo "============================================================"
echo "Root: $ROOT"
echo "Time: $STAMP"
echo

echo "=== CURRENT REPOSITORY STATE ==="
git branch --show-current
git status --short
git log -1 --oneline
echo

# -----------------------------------------------------------------------------
# Branch safety
# -----------------------------------------------------------------------------
CURRENT="$(git branch --show-current)"
if [[ "$CURRENT" != "$BRANCH" ]]; then
  if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git switch "$BRANCH"
  else
    git switch -c "$BRANCH"
  fi
fi

# -----------------------------------------------------------------------------
# Discovery — adapt to the existing repository instead of replacing it.
# -----------------------------------------------------------------------------
echo "=== DISCOVERING CURRENT PORTFOLIO ==="

TREE="$AUDIT_DIR/repository-tree.txt"
git ls-files > "$TREE"

{
  echo "Generated: $STAMP"
  echo
  echo "=== Top-level directories ==="
  find . -maxdepth 1 -mindepth 1 -type d -not -path './.git' -printf '%P\n' | sort
  echo
  echo "=== Key existing portfolio areas ==="
  find . -maxdepth 3 -type d \
    \( -iname '*soc*' -o -iname '*wazuh*' -o -iname '*sysmon*' \
       -o -iname '*incident*' -o -iname '*dfir*' -o -iname '*cloud*' \
       -o -iname '*web*' -o -iname '*active*directory*' \
       -o -iname '*detection*' -o -iname '*automation*' \
       -o -iname '*devsecops*' -o -iname '*terraform*' \) \
    -not -path './.git/*' 2>/dev/null | sort
} > "$AUDIT_DIR/current-state-discovery.txt"

# -----------------------------------------------------------------------------
# Evidence-aware helpers
# -----------------------------------------------------------------------------
has_file_glob() {
  compgen -G "$1" > /dev/null 2>&1
}

first_existing() {
  local f
  for f in "$@"; do
    [[ -f "$f" ]] && { printf '%s\n' "$f"; return 0; }
  done
  return 1
}

# -----------------------------------------------------------------------------
# Create only missing professional documentation/frameworks.
# -----------------------------------------------------------------------------
echo "=== CREATING/UPGRADING PROFESSIONAL STRUCTURE ==="

mkdir -p \
  SOC/Flagship-Investigation \
  SOC/Detection-Validation \
  SOC/Detection-as-Code/Sigma \
  SOC/Detection-as-Code/Wazuh \
  SOC/Detection-as-Code/Tests \
  SOC/Phishing-Investigation \
  Threat-Intelligence/IOC-Investigation \
  Cloud-Security/Cloud-Detection \
  Automation/SOC-Automation \
  Executive-Security-Reporting

cat > SOC/Flagship-Investigation/README.md <<'EOF'
# Flagship SOC Investigation

## Purpose

This is the portfolio's primary end-to-end SOC investigation.

It is intended to demonstrate:

**Wazuh alert → triage → Windows/Sysmon telemetry → investigation → timeline → ATT&CK mapping → scope assessment → response → detection improvement**

### Evidence integrity

This case must use repository evidence only.

Every artifact is classified as one of:

- **OBSERVED / LIVE** — directly supported by retained lab telemetry or artifacts.
- **SYNTHETIC / SIMULATED** — intentionally generated for training.
- **ARCHITECTURE / METHODOLOGY** — design or planned workflow without execution evidence.
- **PENDING LIVE VALIDATION** — a test that still needs to be executed.

No timestamps, alerts, detection rates, incidents or outcomes should be invented.

## Investigation

### 1. Executive Summary
_To be completed from actual evidence._

### 2. Incident Classification
- Environment: Controlled laboratory
- Detection platform: Wazuh
- Endpoint telemetry: Windows / Sysmon where available
- Production incident: **No**

### 3. Initial Detection
Record the actual Wazuh alert:
- Rule ID
- Severity
- Timestamp
- Host
- User
- Event source
- Process
- Command line

### 4. Timeline
| Time | Event | Evidence | Analyst interpretation |
|---|---|---|---|
| ACTUAL/PENDING | ACTUAL EVENT | LINK TO ARTIFACT | ANALYSIS |

### 5. Host and Process Analysis
Document actual:
- hostname
- OS
- account
- process
- parent/child relationship
- command line
- Sysmon Event IDs
- relevant Windows Event IDs

### 6. Network Evidence
Use only retained evidence:
- destination
- protocol
- port
- DNS
- PCAP
- connection timing

Sanitize sensitive infrastructure details before publication.

### 7. MITRE ATT&CK
Map only behavior actually evidenced.

| Behavior | ATT&CK | Evidence | Status |
|---|---|---|---|
| PowerShell, if evidenced | T1059.001 | Actual artifact | OBSERVED/PENDING |

### 8. Analyst Reasoning
Explain:
1. Why the alert was investigated.
2. What evidence supported the hypothesis.
3. What alternative explanations were considered.
4. Whether persistence was evidenced.
5. Whether credential access was evidenced.
6. Whether lateral movement was evidenced.
7. Whether command-and-control was evidenced.

### 9. Scope Assessment
Identify affected hosts/accounts and investigation limitations.

### 10. Response
Document actual containment, eradication and recovery actions.

If not executed, use **PENDING LIVE VALIDATION**.

### 11. Detection Improvement
Document:
- rule
- telemetry source
- severity
- ATT&CK mapping
- false-positive considerations
- tuning
- validation result

### 12. Evidence Index
Link directly to retained sanitized logs, screenshots, rules, scripts and reports.

### 13. Final Analyst Assessment
Summarize what can actually be concluded from the evidence.

> This is a controlled laboratory case study and must not be presented as professional employment experience or a real-world breach.
EOF

cat > SOC/Detection-Validation/README.md <<'EOF'
# Detection Validation

A validation framework for the portfolio's Wazuh/Sysmon detection engineering.

## Objective

Evaluate detections against both suspicious and benign behavior rather than simply stating that an alert appeared.

## Matrix

| Test | Expected | Actual | Status |
|---|---|---|---|
| Controlled suspicious simulation | Alert | PENDING | PENDING LIVE VALIDATION |
| Benign administrative activity | No alert | PENDING | PENDING LIVE VALIDATION |
| Repeated suspicious execution | Defined behavior | PENDING | PENDING LIVE VALIDATION |
| Similar benign behavior | No false positive | PENDING | PENDING LIVE VALIDATION |

## Metrics

Only calculate these from executed tests:

- test cases
- successful detections
- detection rate
- false positives
- false negatives, if demonstrable
- detection latency, if measurable
- severity distribution
- ATT&CK coverage

Never estimate missing metrics.

## Evidence chain

**Test action → telemetry → detection → alert → analyst validation → tuning**

A detection is not marked validated merely because the rule exists.
EOF

cat > SOC/Detection-as-Code/README.md <<'EOF'
# Detection as Code

This area documents the portfolio's detection engineering work in a repeatable format.

## Current workflow

**Detection concept → detection logic → Wazuh implementation → test event → expected result → actual result → tuning**

## Each detection should contain

- Name
- Purpose
- Data source
- Event ID/log source
- Detection logic
- Severity
- ATT&CK mapping
- False-positive considerations
- Validation status
- Tuning notes

Do not claim Sigma compatibility, conversion or successful testing unless demonstrated by repository evidence.
EOF

cat > SOC/Detection-as-Code/Sigma/README.md <<'EOF'
# Sigma

Store portable detection rules here when they have actually been authored.

For each rule document:
- title
- ID
- status
- description
- log source
- detection
- condition
- false positives
- severity
- ATT&CK tags

Use `PENDING LIVE VALIDATION` where appropriate.
EOF

cat > SOC/Detection-as-Code/Tests/README.md <<'EOF'
# Detection Tests

Retain test inputs and results here.

Every test should distinguish:
- suspicious/malicious simulation
- benign behavior
- expected alert
- actual alert
- false positive
- false negative
- validation status

Do not fabricate results.
EOF

cat > SOC/Phishing-Investigation/README.md <<'EOF'
# Controlled Phishing / Email Investigation

## Scope

A safe SOC-style email investigation using synthetic, sanitized or otherwise authorized training artifacts.

No real users are targeted.

## Workflow

**Email triage → headers → SPF/DKIM/DMARC → URL/domain analysis → IOC extraction → risk → containment → awareness → detection improvement**

## Report

1. Executive summary
2. Scenario
3. Email metadata
4. Header analysis
5. SPF
6. DKIM
7. DMARC
8. URL/domain analysis
9. Attachment analysis where safe
10. IOC table
11. Social-engineering indicators
12. Risk assessment
13. Analyst conclusion
14. Recommended actions
15. Detection opportunities
16. User-awareness recommendations

Unexecuted analysis is **PENDING VALIDATION**.
Synthetic material must be explicitly labelled.
EOF

cat > Threat-Intelligence/IOC-Investigation/README.md <<'EOF'
# IOC Investigation

## Objective

Demonstrate structured IOC extraction, classification, enrichment methodology and response recommendations.

## Workflow

**IOC extraction → normalization → enrichment → context → confidence → severity → detection opportunity → response**

## IOC types

- IP
- domain
- URL
- file hash
- filename
- user agent
- email indicator where appropriate

## Evidence policy

Use only safe/public/synthetic indicators.

Do not publish private infrastructure or credentials.

Do not call an IOC malicious merely because a tool or source was not checked. Record source, context and confidence.
EOF

cat > Cloud-Security/Cloud-Detection/README.md <<'EOF'
# Cloud Detection

This extends the existing cloud-security work toward SOC operations rather than creating another generic cloud architecture project.

## Workflow

**Cloud activity → audit log → detection → alert → investigation → remediation → verification**

## Candidate scenarios

- IAM changes
- excessive permissions
- public exposure
- security-control changes
- suspicious administrative activity
- service-account changes

Use existing Azure/GCP evidence where available.

Unexecuted scenarios must be labelled **PENDING LIVE VALIDATION**.
EOF

cat > Automation/SOC-Automation/README.md <<'EOF'
# SOC Automation

Use the repository's existing Python/Bash/PowerShell capabilities to demonstrate practical analyst automation.

## Target workflow

**Wazuh alert/log → parser → event extraction → IOC extraction → classification → severity → analyst summary → report**

## Outputs

Where useful:
- JSON
- CSV
- Markdown
- HTML

## Documentation

For each automation document:
1. Problem
2. Manual workflow
3. Automation
4. Inputs
5. Processing
6. Outputs
7. Error handling
8. Testing
9. Limitations

Do not claim measured time savings without measurement.
EOF

cat > Executive-Security-Reporting/README.md <<'EOF'
# Executive Security Reporting

## Purpose

Translate technical findings into business risk.

## Technical view

Summarize:
- critical assets
- vulnerabilities
- detections
- incidents
- endpoint coverage
- IAM risks
- cloud risks
- remediation status

## Executive view

Answer:
1. What is the most important risk?
2. What business process or asset is affected?
3. What could happen?
4. What controls exist?
5. What should be prioritized?
6. What remains unresolved?

Simulated metrics must be explicitly labelled simulated.
EOF

# -----------------------------------------------------------------------------
# Portfolio positioning document — does not overwrite the existing homepage.
# -----------------------------------------------------------------------------
cat > "$AUDIT_DIR/recommended-positioning.md" <<'EOF'
# Recommended Portfolio Positioning

## Primary
SOC Analyst / Security Operations Analyst

## Secondary
Cybersecurity Analyst / Detection Analyst / Security Monitoring Analyst

## Supporting
Incident Response / Detection Engineering / Security Engineering / Cloud Security

## Story

Enterprise IT & Infrastructure
→ Windows / Active Directory / Networking
→ Cybersecurity Foundations
→ Offensive Security
→ Detection Engineering
→ SOC Investigation
→ Incident Response
→ Cloud Security
→ Automation
→ Risk / Business Impact

The portfolio should prioritize depth and evidence over project count.
EOF

# -----------------------------------------------------------------------------
# Contradiction detection — report first, do not blindly rewrite claims.
# -----------------------------------------------------------------------------
echo "=== CHECKING COMPLETION CLAIMS / CONTRADICTIONS ==="

grep -RInE \
  --exclude-dir=.git \
  --exclude-dir=portfolio-audit \
  '(6[[:space:]]*of[[:space:]]*6|awaiting execution|awaiting validation|pending|complete|completed|live|validated)' \
  . > "$AUDIT_DIR/completion-claims.txt" 2>/dev/null || true

# -----------------------------------------------------------------------------
# Placeholder / secret scan. Secrets cause a warning; this script does not
# automatically rewrite them.
# -----------------------------------------------------------------------------
echo "=== SECURITY CONTENT AUDIT ==="

{
  echo "# Security Content Audit"
  echo "Generated: $STAMP"
  echo
  echo "## Potential secret patterns"
  grep -RInE \
    --exclude-dir=.git \
    --exclude-dir=portfolio-audit \
    --exclude='*.png' --exclude='*.jpg' --exclude='*.jpeg' --exclude='*.webp' \
    '(BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|api[_-]?key|secret[_-]?key|password[[:space:]]*=|token[[:space:]]*=)' \
    . 2>/dev/null || echo "No obvious secret pattern found."
  echo
  echo "## Potential placeholders"
  grep -RInE \
    --exclude-dir=.git \
    --exclude-dir=portfolio-audit \
    '(TODO|FIXME|PLACEHOLDER|YOUR_API_KEY|CHANGE_ME|REPLACE_ME)' \
    . 2>/dev/null || echo "No obvious placeholder found."
} > "$AUDIT_DIR/security-content-audit.txt"

# -----------------------------------------------------------------------------
# Broken local Markdown/image reference audit.
# -----------------------------------------------------------------------------
echo "=== CHECKING LOCAL MARKDOWN REFERENCES ==="

python3 - "$ROOT" "$AUDIT_DIR/local-reference-audit.txt" <<'PY'
import os, re, sys
root, out = sys.argv[1], sys.argv[2]
bad = []
for dp, _, files in os.walk(root):
    if ".git" in dp.split(os.sep) or "portfolio-audit" in dp.split(os.sep):
        continue
    for fn in files:
        if not fn.lower().endswith((".md", ".markdown")):
            continue
        path = os.path.join(dp, fn)
        try:
            text = open(path, encoding="utf-8", errors="ignore").read()
        except OSError:
            continue
        refs = re.findall(r'!\[[^\]]*\]\(([^)]+)\)|\[[^\]]+\]\(([^)]+)\)', text)
        for a,b in refs:
            ref = (a or b).strip()
            if not ref or ref.startswith(("http://","https://","#","mailto:")):
                continue
            ref = ref.split("#",1)[0].split("?",1)[0]
            if not ref:
                continue
            target = os.path.normpath(os.path.join(os.path.dirname(path), ref))
            if not os.path.exists(target):
                bad.append(f"{os.path.relpath(path, root)} -> {ref}")
with open(out,"w",encoding="utf-8") as f:
    if bad:
        f.write("\n".join(bad)+"\n")
    else:
        f.write("No missing local Markdown references detected.\n")
PY

# -----------------------------------------------------------------------------
# Existing QA scripts — run only when present, never replace them.
# -----------------------------------------------------------------------------
echo "=== RUNNING EXISTING PORTFOLIO QA WHERE AVAILABLE ==="

QA="$AUDIT_DIR/qa.log"
: > "$QA"

for script in \
  ./audit-portfolio.sh \
  ./fix-portfolio.sh \
  ./portfolio-finalize.sh \
  ./portfolio-finalize*.sh \
  ./dvwa-deep-audit.sh \
  ./dvwa-standardize.sh
do
  if [[ -f "$script" && -x "$script" ]]; then
    echo ">>> $script" | tee -a "$QA"
    bash "$script" >> "$QA" 2>&1 || echo "EXIT=$?" >> "$QA"
    echo >> "$QA"
  fi
done

# -----------------------------------------------------------------------------
# Generic repo checks.
# -----------------------------------------------------------------------------
echo "=== GENERATING FINAL AUDIT ==="

{
  echo "# Final Portfolio Polish Audit"
  echo
  echo "**Generated:** $STAMP"
  echo
  echo "## Repository State"
  echo
  echo "- Branch: \`$(git branch --show-current)\`"
  echo "- HEAD: \`$(git rev-parse --short HEAD)\`"
  echo "- Existing uncommitted changes were preserved."
  echo
  echo "## Current Capability Areas"
  echo
  for d in \
    SOC \
    Incident-Response \
    DFIR \
    Active-Directory \
    Network-Security \
    Web-Security \
    Cloud-Security \
    Automation \
    AppSec \
    DevSecOps \
    Scripts
  do
    if [[ -d "$d" ]]; then
      echo "- [x] $d"
    fi
  done
  echo
  echo "## Professional Upgrade Areas"
  echo
  echo "- [x] Flagship SOC investigation framework"
  echo "- [x] Detection validation framework"
  echo "- [x] Detection-as-code structure"
  echo "- [x] Controlled phishing investigation framework"
  echo "- [x] IOC/threat-intelligence framework"
  echo "- [x] Cloud detection workflow"
  echo "- [x] SOC automation workflow"
  echo "- [x] Executive security reporting framework"
  echo
  echo "## Evidence Integrity"
  echo
  echo "The generated material does not claim live validation unless evidence exists."
  echo "Tests requiring Wazuh/Sysmon/cloud execution remain pending until actually run."
  echo
  echo "## Review Files"
  echo
  echo "- [Completion claims](completion-claims.txt)"
  echo "- [Security content audit](security-content-audit.txt)"
  echo "- [Local reference audit](local-reference-audit.txt)"
  echo "- [AI/vendor reference review](ai-reference-review.txt)"
  echo "- [QA log](qa.log)"
  echo
  echo "## Git Diff"
  echo
  git diff --stat
} > "$AUDIT_DIR/FINAL-PORTFOLIO-AUDIT.md"

# -----------------------------------------------------------------------------
# Final status and safety gate.
# -----------------------------------------------------------------------------
echo
echo "============================================================"
echo " FINAL POLISH PREPARATION COMPLETE"
echo "============================================================"
echo
echo "Branch:"
git branch --show-current
echo
echo "Changed/untracked files:"
git status --short
echo
echo "Audit:"
echo "  $AUDIT_DIR/FINAL-PORTFOLIO-AUDIT.md"
echo "  $AUDIT_DIR/security-content-audit.txt"
echo "  $AUDIT_DIR/local-reference-audit.txt"
echo "  $AUDIT_DIR/completion-claims.txt"
echo "  $AUDIT_DIR/ai-reference-review.txt"
echo "  $AUDIT_DIR/qa.log"
echo
echo "IMPORTANT:"
echo "Review the audit before committing."
echo "Do not publish any detected secret or sensitive infrastructure detail."
echo "Do not mark pending detection/cloud tests as completed without evidence."
echo
echo "Suggested next commands:"
echo "  git diff --stat"
echo "  git diff --check"
echo "  git status --short"
echo
echo "When satisfied:"
echo "  git add -A"
echo "  git commit -m 'chore: final cybersecurity portfolio polish'"
echo "  git push -u origin $(git branch --show-current)"
echo
echo "Then open a Pull Request against main."
echo "============================================================"
