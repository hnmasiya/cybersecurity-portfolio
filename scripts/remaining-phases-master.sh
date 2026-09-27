#!/usr/bin/env bash
# ==============================================================================
# CYBERSECURITY PORTFOLIO — MASTER REMAINING PHASES EXECUTOR
# ==============================================================================
# Covers the remaining portfolio roadmap:
#   Phase 2 — Network Investigation
#   Phase 3 — Web Security
#   Phase 4 — Detection Engineering
#   Phase 5 — Incident Response / DFIR
#   Phase 6 — Cloud Security
#   Phase 7 — Security Automation
#   Phase 8 — Portfolio Hardening / Recruiter Readiness
#
# Design goals:
#   - Safe-by-default and local-only where network activity is generated.
#   - Idempotent: re-running should preserve prior evidence and refresh reports.
#   - Creates reproducible evidence, SHA-256 hashes, manifests and validation.
#   - Does NOT publish secrets, flags, challenge answers or credentials.
#   - Does NOT attack third-party systems.
#
# Usage:
#   chmod +x scripts/remaining-phases-master.sh
#   ./scripts/remaining-phases-master.sh
#
# Optional:
#   ./scripts/remaining-phases-master.sh --phase 2
#   ./scripts/remaining-phases-master.sh --phase 3
#   ./scripts/remaining-phases-master.sh --phase 4
#   ./scripts/remaining-phases-master.sh --phase 5
#   ./scripts/remaining-phases-master.sh --phase 6
#   ./scripts/remaining-phases-master.sh --phase 7
#   ./scripts/remaining-phases-master.sh --phase 8
#   ./scripts/remaining-phases-master.sh --all
#
# Notes:
#   Some provider-based training (CyberDefenders, LetsDefend, TryHackMe,
#   Microsoft Learn, Splunk, PortSwigger) cannot be completed automatically
#   without logging into those services. This script creates the local evidence
#   framework and local equivalents, and records external-work placeholders
#   rather than pretending those labs were completed.
# ==============================================================================

set -Eeuo pipefail
IFS=$'\n\t'
umask 077

ROOT="${PORTFOLIO_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
SCRIPT_NAME="$(basename "$0")"
EVIDENCE_DIR="$ROOT/evidence/master-remaining-phases"
REPORT_DIR="$EVIDENCE_DIR/reports"
LOG_DIR="$EVIDENCE_DIR/logs"
HASH_DIR="$EVIDENCE_DIR/hashes"
MANIFEST_DIR="$EVIDENCE_DIR/manifests"
TOOLS_DIR="$EVIDENCE_DIR/tools"
LAB_DIR="$EVIDENCE_DIR/labs"
TMP_DIR="$EVIDENCE_DIR/.tmp"
RUN_ID="$(date -u +%Y%m%dT%H%M%SZ)"
LOG_FILE="$LOG_DIR/master-$RUN_ID.log"

mkdir -p "$REPORT_DIR" "$LOG_DIR" "$HASH_DIR" "$MANIFEST_DIR" \
         "$TOOLS_DIR" "$LAB_DIR" "$TMP_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

PASS=0
WARN=0
FAIL=0
SKIP=0

log()  { printf '[%s] %s\n' "$(date -u +%H:%M:%S)" "$*"; }
pass() { PASS=$((PASS+1)); printf 'PASS: %s\n' "$*"; }
warn() { WARN=$((WARN+1)); printf 'WARN: %s\n' "$*"; }
fail() { FAIL=$((FAIL+1)); printf 'FAIL: %s\n' "$*"; }
skip() { SKIP=$((SKIP+1)); printf 'SKIP: %s\n' "$*"; }

die() {
  fail "$*"
  exit 1
}

trap 'rc=$?; if (( rc != 0 )); then fail "Unexpected error at line $LINENO (exit $rc)"; fi' ERR

command_exists() { command -v "$1" >/dev/null 2>&1; }

sha256_file() {
  if command_exists sha256sum; then
    sha256sum "$1"
  elif command_exists shasum; then
    shasum -a 256 "$1"
  else
    return 1
  fi
}

write_file() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  cat > "$path"
}

section() {
  printf '\n%s\n' "================================================================"
  printf '%s\n' "$*"
  printf '%s\n\n' "================================================================"
}

usage() {
  sed -n '1,55p' "$0"
}

PHASES=()
if [[ $# -eq 0 ]]; then
  PHASES=(2 3 4 5 6 7 8)
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --all) PHASES=(2 3 4 5 6 7 8); shift ;;
      --phase)
        [[ $# -ge 2 ]] || die "--phase requires a number"
        PHASES+=("$2"); shift 2 ;;
      --help|-h) usage; exit 0 ;;
      *) die "Unknown argument: $1" ;;
    esac
  done
fi

for p in "${PHASES[@]}"; do
  [[ "$p" =~ ^[2-8]$ ]] || die "Invalid phase: $p"
done

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
section "PRE-FLIGHT"

cd "$ROOT"
log "Portfolio root: $ROOT"
log "Run ID: $RUN_ID"

if [[ -d .git ]]; then
  pass "Git repository detected"
else
  warn "Not a Git repository; Git-specific checks will be limited"
fi

if command_exists bash; then pass "Bash available"; else die "Bash is required"; fi
if command_exists git; then pass "Git available"; else warn "Git unavailable"; fi
if command_exists sha256sum || command_exists shasum; then
  pass "SHA-256 hashing available"
else
  die "sha256sum or shasum is required"
fi

for tool in python3 curl awk sed grep find; do
  if command_exists "$tool"; then
    pass "$tool available"
  else
    warn "$tool unavailable"
  fi
done

if command_exists nmap; then pass "Nmap available"; else warn "Nmap unavailable — Phase 2 Nmap portion will be recorded as skipped"; fi
if command_exists tshark; then pass "TShark available"; else warn "TShark unavailable — packet capture portion will be recorded as skipped"; fi
if command_exists tcpdump; then pass "tcpdump available"; else warn "tcpdump unavailable — packet capture fallback unavailable"; fi
if command_exists curl; then pass "curl available"; else warn "curl unavailable"; fi
if command_exists openssl; then pass "OpenSSL available"; else warn "OpenSSL unavailable"; fi
if command_exists terraform; then pass "Terraform available"; else warn "Terraform unavailable — Phase 6 static validation will be scaffolded"; fi

# Do not create a public/private-key pair or credential. We only document the
# cryptographic tools and hash evidence generated by this run.
write_file "$REPORT_DIR/external-training-status.md" <<'EOF'
# External Training Status

This master script does not claim completion of provider-hosted labs.

Provider tracks to complete manually and document in the portfolio:
- TryHackMe SOC Level 1/free material
- CyberDefenders
- LetsDefend
- Microsoft Security / Sentinel / Defender / Entra
- Splunk
- PortSwigger Academy

For each completed external lab, record:
1. Lab name and provider
2. Date completed
3. Skills demonstrated
4. Detection / investigation steps
5. MITRE ATT&CK mapping where appropriate
6. Sanitized screenshots or evidence
7. Lessons learned

Do not publish challenge flags, answers, credentials, tokens or private customer data.
EOF

# ---------------------------------------------------------------------------
# Phase 2 — Network Investigation
# ---------------------------------------------------------------------------
phase2() {
  section "PHASE 2 — NETWORK INVESTIGATION"

  local out="$LAB_DIR/phase2-network-investigation"
  local port=""
  local server_pid=""
  local capture="$out/localhost-http.pcap"
  local iface="lo"

  mkdir -p "$out"

  write_file "$out/README.md" <<'EOF'
# Phase 2 — Network Reconnaissance & Packet Investigation

Scope: local loopback only (`127.0.0.1`).

Objectives:
- Identify a controlled local HTTP service with Nmap.
- Generate controlled HTTP traffic.
- Capture packets with TShark, with tcpdump as fallback.
- Extract protocol and HTTP evidence.
- Correlate service, request and packet capture.
- Hash the resulting evidence.

Safety:
- Only `127.0.0.1` is used.
- No third-party target is scanned.
- The service is created by this run and is stopped by cleanup.
EOF

  local candidate
  if command_exists ss; then
    for candidate in $(seq 8765 8799); do
      if ! ss -H -ltn "sport = :$candidate" 2>/dev/null | grep -q .; then
        port="$candidate"
        break
      fi
    done
  else
    port=8765
  fi

  if [[ -z "$port" ]]; then
    warn "No free localhost test port in 8765-8799"
    return 0
  fi

  cleanup_phase2() {
    trap - RETURN
    if [[ -n "${server_pid:-}" ]] && kill -0 "$server_pid" 2>/dev/null; then
      kill "$server_pid" 2>/dev/null || true
      wait "$server_pid" 2>/dev/null || true
    fi
  }
  trap cleanup_phase2 RETURN

  if ! command_exists python3; then
    warn "Python 3 unavailable; Phase 2 HTTP generation skipped"
    return 0
  fi

  log "Starting controlled HTTP service on 127.0.0.1:$port"

  (
    cd "$out"
    exec python3 -m http.server "$port" --bind 127.0.0.1 >http-server.log 2>&1
  ) &
  server_pid=$!

  sleep 1

  if ! kill -0 "$server_pid" 2>/dev/null; then
    warn "Controlled localhost HTTP service failed to start"
    [[ -f "$out/http-server.log" ]] && sed -n '1,80p' "$out/http-server.log" || true
    return 0
  fi
  pass "Local HTTP service verified on 127.0.0.1:$port"

  if curl -fsS --max-time 5 "http://127.0.0.1:$port/" >"$out/http-response.html" 2>"$out/http-curl-error.txt"; then
    pass "Controlled HTTP request generated"
  else
    warn "Controlled HTTP request failed"
  fi

  if command_exists nmap; then
    if nmap -Pn -n -sV -p "$port" 127.0.0.1 >"$out/nmap-localhost.txt" 2>&1; then
      pass "Nmap localhost service discovery completed"
    else
      warn "Nmap localhost service discovery returned non-zero status"
    fi
  else
    skip "Nmap unavailable"
  fi

  rm -f "$capture"

  if command_exists tshark; then
    log "Starting TShark loopback capture"
    if tshark -i "$iface" -f "tcp port $port" -a duration:5 -w "$capture" \
      >"$out/tshark-capture.log" 2>&1 &
    then
      local cap_pid=$!
      sleep 1
      curl -fsS --max-time 5 \
        "http://127.0.0.1:$port/?phase=2&source=tshark" \
        >"$out/http-response-second.html" \
        2>"$out/http-curl-second-error.txt" || true
      wait "$cap_pid" 2>/dev/null || true
    else
      warn "TShark capture command could not start"
    fi
  fi

  if [[ ! -s "$capture" ]] && command_exists tcpdump; then
    log "TShark did not produce a capture; trying tcpdump"
    rm -f "$capture"
    if tcpdump -i "$iface" -nn -s 0 -w "$capture" "tcp port $port" \
      >"$out/tcpdump-capture.log" 2>&1 &
    then
      local tcp_pid=$!
      sleep 1
      curl -fsS --max-time 5 \
        "http://127.0.0.1:$port/?phase=2&source=tcpdump" \
        >"$out/http-response-third.html" \
        2>"$out/http-curl-third-error.txt" || true
      sleep 1
      kill "$tcp_pid" 2>/dev/null || true
      wait "$tcp_pid" 2>/dev/null || true
    else
      warn "tcpdump fallback could not start"
    fi
  fi

  if [[ -s "$capture" ]] && command_exists tshark; then
    tshark -r "$capture" -q -z io,phs >"$out/protocol-hierarchy.txt" 2>&1 || true
    tshark -r "$capture" -Y "http" \
      -T fields -e frame.time -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport \
      -e http.request.method -e http.host -e http.request.uri \
      >"$out/http-fields.tsv" 2>&1 || true
    tshark -r "$capture" \
      -T fields -e frame.number -e frame.time -e ip.src -e ip.dst \
      -e tcp.srcport -e tcp.dstport -e _ws.col.protocol -e _ws.col.info \
      >"$out/packet-evidence.tsv" 2>&1 || true
    sha256sum "$capture" >"$out/pcap.sha256"
    pass "Packet capture and protocol evidence generated"
  elif [[ -s "$capture" ]]; then
    sha256sum "$capture" >"$out/pcap.sha256" || true
    pass "Packet capture generated"
  else
    warn "No packet capture was produced"
  fi

  {
    printf 'port=%s\n' "$port"
    printf 'scope=127.0.0.1\n'
    printf 'timestamp_utc=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } >"$out/run-metadata.txt"

  if [[ -f "$out/http-response.html" ]] || \
     [[ -f "$out/http-response-second.html" ]]; then
    pass "Phase 2 network investigation evidence completed"
  else
    warn "Phase 2 completed without a retained HTTP response"
  fi
}


# ---------------------------------------------------------------------------
# Phase 3 — Web Security
# ---------------------------------------------------------------------------
phase3() {
  section "PHASE 3 — WEB SECURITY"

  local out="$LAB_DIR/phase3-web-security"
  mkdir -p "$out"

  write_file "$out/README.md" <<'EOF'
# Phase 3 — Web Security

Safe scope:
- Local files and localhost applications only.
- No scanning of public websites.
- No credential attacks.
- No destructive payloads.

The portfolio should document:
- HTTP request/response structure
- Authentication and authorization concepts
- Input validation
- Security headers
- OWASP Top 10 mapping
- Burp Suite / OWASP ZAP evidence when used manually
- Juice Shop / DVWA evidence where locally hosted
EOF

  # A harmless local web-security fixture for static analysis.
  write_file "$out/insecure-fixture.html" <<'EOF'
<!doctype html>
<html>
<head><title>Security Fixture</title></head>
<body>
<form method="post" action="/login">
  <input name="username">
  <input name="password" type="password">
  <button type="submit">Login</button>
</form>
</body>
</html>
EOF

  write_file "$out/security-checklist.md" <<'EOF'
# Web Security Checklist

- [ ] Authentication controls reviewed
- [ ] Authorization / IDOR controls reviewed
- [ ] Input validation reviewed
- [ ] Output encoding reviewed
- [ ] Session cookie flags reviewed
- [ ] CSRF protection reviewed
- [ ] Security headers reviewed
- [ ] TLS configuration reviewed
- [ ] Error handling reviewed
- [ ] Logging and monitoring reviewed
- [ ] OWASP Top 10 mapping completed
- [ ] Evidence sanitized before publication
EOF

  if command_exists curl; then
    # If a local application is already running, inspect only localhost.
    local urls=("http://127.0.0.1:3000/" "http://127.0.0.1:8080/" "http://127.0.0.1:8000/")
    local found=0
    for url in "${urls[@]}"; do
      if curl -fsSI --max-time 2 "$url" >"$out/$(echo "$url" | sed 's#[/:]#_#g').headers" 2>/dev/null; then
        pass "Detected local web service: $url"
        found=1
      fi
    done
    (( found == 1 )) || warn "No known localhost web service detected; use existing DVWA/Juice Shop manually"
  fi

  write_file "$out/external-lab-record-template.md" <<'EOF'
# External / Existing Web Lab Record

Application:
URL (local/private only):
Date:
Tool:
Scope:
Finding:
Evidence:
OWASP category:
Impact:
Remediation:
Retest result:

Do not publish credentials, flags, tokens or private data.
EOF

  pass "Phase 3 local web-security evidence framework completed"
}

# ---------------------------------------------------------------------------
# Phase 4 — Detection Engineering
# ---------------------------------------------------------------------------
phase4() {
  section "PHASE 4 — DETECTION ENGINEERING"

  local out="$LAB_DIR/phase4-detection-engineering"
  mkdir -p "$out/sigma" "$out/test-logs"

  write_file "$out/test-logs/linux-auth-sample.log" <<'EOF'
Sep 24 12:01:01 lab sshd[1001]: Failed password for invalid user admin from 127.0.0.1 port 41234 ssh2
Sep 24 12:01:03 lab sshd[1002]: Failed password for invalid user admin from 127.0.0.1 port 41235 ssh2
Sep 24 12:01:05 lab sshd[1003]: Failed password for invalid user admin from 127.0.0.1 port 41236 ssh2
Sep 24 12:01:10 lab sshd[1004]: Accepted publickey for analyst from 127.0.0.1 port 41240 ssh2
EOF

  write_file "$out/sigma/linux-ssh-multiple-failures.yml" <<'EOF'
title: Multiple Linux SSH Authentication Failures
id: 6a6dbec7-1c08-4e5e-a0d5-1a5b8d1b3c11
status: experimental
description: Detect repeated SSH authentication failures in Linux authentication logs.
logsource:
  product: linux
  service: sshd
detection:
  selection:
    message|contains: "Failed password"
  condition: selection
falsepositives:
  - User error
  - Password rotation
level: low
tags:
  - attack.credential_access
  - attack.t1110
EOF

  write_file "$out/sigma/linux-sudo-command.yml" <<'EOF'
title: Linux Privileged Command Execution
id: 8f7f6b2c-6d0f-4e0b-bf5b-0d7e0f2c9f44
status: experimental
description: Detect sudo command execution for investigation and audit visibility.
logsource:
  product: linux
  service: sudo
detection:
  selection:
    message|contains: "COMMAND="
  condition: selection
falsepositives:
  - Routine administration
level: informational
tags:
  - attack.privilege_escalation
EOF

  write_file "$out/detection-engineering.md" <<'EOF'
# Detection Engineering Record

For each detection:
1. Hypothesis
2. Data source
3. Detection logic
4. Expected true positives
5. Expected false positives
6. Severity rationale
7. ATT&CK mapping
8. Test data
9. Validation result
10. Tuning notes

Detection lifecycle:
idea -> rule -> test -> false-positive review -> tune -> document -> deploy -> monitor
EOF

  if command_exists python3; then
    python3 - "$out/test-logs/linux-auth-sample.log" "$out/detection-test-results.txt" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
lines = open(src, encoding="utf-8").read().splitlines()
fails = [x for x in lines if "Failed password" in x]
accepted = [x for x in lines if "Accepted " in x]
with open(dst, "w", encoding="utf-8") as f:
    f.write(f"failed_password_events={len(fails)}\n")
    f.write(f"accepted_events={len(accepted)}\n")
    f.write("rule_triggered=" + str(len(fails) >= 3) + "\n")
PY
    pass "Detection rule test executed"
  else
    warn "Python unavailable; detection test not executed"
  fi

  pass "Phase 4 detection engineering evidence completed"
}

# ---------------------------------------------------------------------------
# Phase 5 — Incident Response / DFIR
# ---------------------------------------------------------------------------
phase5() {
  section "PHASE 5 — INCIDENT RESPONSE / DFIR"

  local out="$LAB_DIR/phase5-incident-response"
  mkdir -p "$out"

  write_file "$out/incident-response-plan.md" <<'EOF'
# Incident Response Plan

## 1. Preparation
- Confirm logging and time synchronization.
- Maintain evidence handling procedures.
- Keep contact and escalation information current.

## 2. Identification
- Validate alert.
- Establish scope, affected assets and timeframe.
- Record hypotheses separately from facts.

## 3. Containment
- Use the least disruptive containment appropriate to the incident.
- Preserve evidence before destructive changes where feasible.

## 4. Eradication
- Remove persistence and malicious artifacts.
- Patch or remediate the root cause.

## 5. Recovery
- Restore services.
- Increase monitoring.
- Verify expected behavior.

## 6. Lessons Learned
- Timeline
- Root cause
- Detection gaps
- Control improvements
- Action owners and due dates
EOF

  # Create a harmless synthetic incident dataset rather than touching live
  # sensitive files.
  write_file "$out/synthetic-incident.log" <<'EOF'
2026-09-24T11:00:00Z INFO  web01 normal request volume
2026-09-24T11:05:00Z WARN  web01 repeated authentication failures
2026-09-24T11:07:00Z WARN  web01 account lockout threshold reached
2026-09-24T11:12:00Z INFO  analyst alert triage started
2026-09-24T11:20:00Z INFO  analyst source isolated in synthetic scenario
2026-09-24T11:35:00Z INFO  analyst remediation completed in synthetic scenario
EOF

  write_file "$out/evidence-handling.md" <<'EOF'
# Evidence Handling

For real investigations:
- Record acquisition time in UTC.
- Record source and collection method.
- Hash collected artifacts.
- Preserve originals read-only where possible.
- Work on copies for analysis.
- Keep a chain-of-custody record.
- Sanitize personal/customer data before portfolio publication.

This repository contains synthetic evidence only unless a separate artifact is explicitly approved for publication.
EOF

  if command_exists sha256sum || command_exists shasum; then
    sha256_file "$out/synthetic-incident.log" >"$out/synthetic-incident.log.sha256"
    pass "Synthetic DFIR artifact hashed"
  fi

  write_file "$out/incident-report-template.md" <<'EOF'
# Incident Report

Incident ID:
Severity:
Detection source:
Start time:
End time:
Affected assets:
Summary:

## Timeline
- UTC timestamp — event

## Evidence
- Artifact:
- SHA-256:
- Source:

## Analysis
Facts:
Hypotheses:
Unknowns:

## Containment
## Eradication
## Recovery
## Root Cause
## Detection Improvements
## Lessons Learned
EOF

  pass "Phase 5 IR/DFIR evidence framework completed"
}

# ---------------------------------------------------------------------------
# Phase 6 — Cloud Security
# ---------------------------------------------------------------------------
phase6() {
  section "PHASE 6 — CLOUD SECURITY"

  local out="$LAB_DIR/phase6-cloud-security"
  mkdir -p "$out/terraform"

  write_file "$out/terraform/main.tf" <<'EOF'
terraform {
  required_version = ">= 1.5.0"
}

# Portfolio training fixture only. It does not create cloud resources.
# The intent is to practice IaC review and secure defaults without deployment.

variable "environment" {
  type    = string
  default = "lab"
}

locals {
  security_requirements = {
    encryption_at_rest = true
    public_storage     = false
    least_privilege    = true
    logging_enabled    = true
    network_segmentation = true
  }
}

output "security_requirements" {
  value = local.security_requirements
}
EOF

  write_file "$out/cloud-security-checklist.md" <<'EOF'
# Cloud Security Checklist

## Identity
- Least privilege
- MFA
- Role separation
- Short-lived credentials
- No long-lived secrets in code

## Network
- Private-by-default
- Segmentation
- Restricted ingress/egress
- Administrative access controlled

## Data
- Encryption at rest
- Encryption in transit
- Key management
- Backup and recovery

## Logging
- Centralized logs
- Audit trails
- Alerting
- Retention

## Infrastructure as Code
- Code review
- Secret scanning
- Static analysis
- Drift detection
- Plan review before apply
EOF

  if command_exists terraform; then
    if terraform -chdir="$out/terraform" fmt -check >/dev/null 2>&1; then
      pass "Terraform formatting validation passed"
    else
      terraform -chdir="$out/terraform" fmt -recursive >/dev/null 2>&1 || true
      pass "Terraform formatting normalized"
    fi
    if terraform -chdir="$out/terraform" validate >/dev/null 2>&1; then
      pass "Terraform configuration validated"
    else
      warn "Terraform validation did not pass"
    fi
  else
    skip "Terraform unavailable; static fixture created for later validation"
  fi

  write_file "$out/external-cloud-lab-record.md" <<'EOF'
# Cloud Lab Record

Platform:
Service:
Lab:
Date:
Identity controls:
Network controls:
Data protection:
Logging:
Detection:
Finding:
Remediation:
Evidence:
EOF

  pass "Phase 6 cloud-security evidence framework completed"
}

# ---------------------------------------------------------------------------
# Phase 7 — Security Automation
# ---------------------------------------------------------------------------
phase7() {
  section "PHASE 7 — SECURITY AUTOMATION"

  local out="$LAB_DIR/phase7-security-automation"
  mkdir -p "$out"

  write_file "$out/normalize_events.py" <<'PY'
#!/usr/bin/env python3
"""Normalize simple security events into a stable JSONL schema.

Safe training utility: reads a user-supplied local file and writes normalized
records. It does not contact external systems.
"""
import json
import sys
from datetime import datetime, timezone

def normalize(line: str) -> dict:
    text = line.rstrip("\n")
    return {
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "event_type": "raw_log",
        "message": text,
        "source": "local_training_input",
    }

def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} INPUT OUTPUT", file=sys.stderr)
        return 2
    with open(sys.argv[1], encoding="utf-8", errors="replace") as src, \
         open(sys.argv[2], "w", encoding="utf-8") as dst:
        for line in src:
            dst.write(json.dumps(normalize(line), ensure_ascii=False) + "\n")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
PY
  chmod +x "$out/normalize_events.py"

  write_file "$out/security_automation.md" <<'EOF'
# Security Automation

Automation principles:
- Input validation
- Least privilege
- Idempotency
- Safe failure
- Structured logs
- Hashable artifacts
- No hard-coded credentials
- Human approval for consequential actions

Suggested pipeline:
collect -> normalize -> validate -> enrich -> detect -> report -> review
EOF

  if command_exists python3; then
    python3 "$out/normalize_events.py" \
      "$LAB_DIR/phase5-incident-response/synthetic-incident.log" \
      "$out/normalized-events.jsonl"
    python3 -m py_compile "$out/normalize_events.py"
    pass "Security automation utility executed and syntax-validated"
  else
    warn "Python unavailable; automation utility created but not executed"
  fi

  pass "Phase 7 security automation evidence completed"
}

# ---------------------------------------------------------------------------
# Phase 8 — Portfolio Hardening / Recruiter Readiness
# ---------------------------------------------------------------------------
phase8() {
  section "PHASE 8 — PORTFOLIO HARDENING / RECRUITER READINESS"

  local out="$LAB_DIR/phase8-portfolio-hardening"
  mkdir -p "$out"

  write_file "$out/recruiter-readiness-checklist.md" <<'EOF'
# Recruiter Readiness Checklist

## Technical proof
- [ ] SOC / SIEM evidence
- [ ] Network investigation evidence
- [ ] Web security evidence
- [ ] Detection engineering evidence
- [ ] IR / DFIR evidence
- [ ] Cloud security evidence
- [ ] Security automation evidence

## Repository quality
- [ ] Clear README
- [ ] No secrets
- [ ] No challenge answers/flags
- [ ] Consistent naming
- [ ] Reproducible commands
- [ ] Evidence indexed
- [ ] Tests passing
- [ ] Security policy present
- [ ] CODEOWNERS / branch protections reviewed
- [ ] Dependabot / dependency monitoring reviewed

## Career presentation
- [ ] ATS-friendly resume
- [ ] LinkedIn aligned with verified skills
- [ ] Portfolio URL works
- [ ] Projects explain problem, method, evidence and outcome
- [ ] Claims are supported by evidence
EOF

  write_file "$out/portfolio-security-checks.sh" <<'EOF'
#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
echo "Portfolio root: $ROOT"

echo "== Potential secret filenames =="
find "$ROOT" -type f \
  \( -name '*.pem' -o -name '*.key' -o -name '.env' -o -name '*.p12' -o -name '*.pfx' \) \
  -not -path '*/.git/*' -print || true

echo "== Common secret markers in tracked files =="
if command -v git >/dev/null 2>&1 && git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$ROOT" grep -nE \
    'AKIA[0-9A-Z]{16}|BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}' \
    -- ':!evidence/master-remaining-phases/*' || true
fi

echo "== Placeholder markers =="
grep -RniE 'TODO|FIXME|CHANGE_ME|REPLACE_ME' "$ROOT" \
  --exclude-dir=.git --exclude-dir=.venv \
  --exclude='*.pyc' 2>/dev/null | head -200 || true
EOF
  chmod +x "$out/portfolio-security-checks.sh"

  if bash "$out/portfolio-security-checks.sh" >"$out/security-check-output.txt" 2>&1; then
    pass "Portfolio security checks executed"
  else
    warn "Portfolio security checks returned non-zero; inspect output"
  fi

  if [[ -d "$ROOT/.github" ]]; then
    pass ".github directory present"
  else
    warn ".github directory not detected"
  fi

  if [[ -f "$ROOT/SECURITY.md" ]]; then
    pass "SECURITY.md present"
  else
    warn "SECURITY.md not found at repository root"
  fi

  if [[ -f "$ROOT/README.md" ]]; then
    pass "README.md present"
  else
    warn "README.md not found at repository root"
  fi

  pass "Phase 8 hardening/recruiter-readiness evidence completed"
}

# ---------------------------------------------------------------------------
# Evidence manifest + validation
# ---------------------------------------------------------------------------
build_manifest() {
  section "EVIDENCE MANIFEST"

  local manifest="$MANIFEST_DIR/manifest-$RUN_ID.txt"
  : > "$manifest"

  find "$LAB_DIR" -type f -not -path '*/.git/*' -print0 |
    sort -z |
    while IFS= read -r -d '' f; do
      if hash=$(sha256_file "$f"); then
        printf '%s  %s\n' "$hash" "${f#"$ROOT"/}" >> "$manifest"
      fi
    done

  cp "$manifest" "$MANIFEST_DIR/latest.txt"
  pass "Evidence manifest generated: ${manifest#"$ROOT"/}"
}

validate_outputs() {
  section "MASTER VALIDATION"

  local required=(
    "$LAB_DIR/phase2-network-investigation/README.md"
    "$LAB_DIR/phase3-web-security/README.md"
    "$LAB_DIR/phase4-detection-engineering/detection-engineering.md"
    "$LAB_DIR/phase5-incident-response/incident-response-plan.md"
    "$LAB_DIR/phase6-cloud-security/cloud-security-checklist.md"
    "$LAB_DIR/phase7-security-automation/security_automation.md"
    "$LAB_DIR/phase8-portfolio-hardening/recruiter-readiness-checklist.md"
    "$REPORT_DIR/external-training-status.md"
  )

  for f in "${required[@]}"; do
    if [[ -s "$f" ]]; then
      pass "Required artifact present: ${f#"$ROOT"/}"
    else
      fail "Required artifact missing/empty: ${f#"$ROOT"/}"
    fi
  done

  if [[ -s "$MANIFEST_DIR/latest.txt" ]]; then
    pass "Latest SHA-256 manifest present"
  else
    fail "Latest SHA-256 manifest missing"
  fi

  if command_exists git && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git diff --check >/dev/null 2>&1; then
      pass "Git whitespace check passed"
    else
      warn "Git whitespace check reported issues"
    fi
  fi
}

write_master_report() {
  section "MASTER REPORT"

  local report="$REPORT_DIR/master-report-$RUN_ID.md"
  cat > "$report" <<EOF
# Cybersecurity Portfolio — Master Remaining Phases Report

Run ID: $RUN_ID
Root: $ROOT
UTC time: $(date -u '+%Y-%m-%d %H:%M:%S')

## Roadmap executed

- Phase 2 — Network Investigation
- Phase 3 — Web Security
- Phase 4 — Detection Engineering
- Phase 5 — Incident Response / DFIR
- Phase 6 — Cloud Security
- Phase 7 — Security Automation
- Phase 8 — Portfolio Hardening / Recruiter Readiness

Phase 1 was already completed before this master run.

## Result

PASS: $PASS
WARN: $WARN
FAIL: $FAIL
SKIP: $SKIP

## Evidence

All generated evidence is under:
\`evidence/master-remaining-phases/\`

Latest manifest:
\`evidence/master-remaining-phases/manifests/latest.txt\`

External provider training is intentionally not marked complete by this script.
Those activities require the user's authenticated sessions and should be
documented after actual completion.

## Safety

Network activity generated by this script is restricted to localhost.
No third-party system is scanned or attacked.
EOF

  pass "Master report written: ${report#"$ROOT"/}"
}

# ---------------------------------------------------------------------------
# Execute selected phases
# ---------------------------------------------------------------------------
for p in "${PHASES[@]}"; do
  case "$p" in
    2) phase2 ;;
    3) phase3 ;;
    4) phase4 ;;
    5) phase5 ;;
    6) phase6 ;;
    7) phase7 ;;
    8) phase8 ;;
  esac
done

build_manifest
validate_outputs
write_master_report

section "FINAL STATUS"
printf 'PASS=%d WARN=%d FAIL=%d SKIP=%d\n' "$PASS" "$WARN" "$FAIL" "$SKIP"
printf 'Evidence: %s\n' "$EVIDENCE_DIR"
printf 'Log:      %s\n' "$LOG_FILE"

if (( FAIL > 0 )); then
  printf '\nMaster run completed with FAILURES. Review the report and logs.\n'
  exit 2
fi

printf '\nMaster run completed without recorded failures.\n'
exit 0
