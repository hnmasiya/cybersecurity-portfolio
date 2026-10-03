#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

REPO_ROOT="${1:-$HOME/cybersecurity-portfolio}"
LAB_GLOB="$REPO_ROOT/evidence/phase2-network-investigation-"*
REPORT_GLOB="$REPO_ROOT/reports/phase2-network-investigation-"*.txt

PASS=0
WARN=0
FAIL=0

pass(){ PASS=$((PASS+1)); printf '[PASS] %s\n' "$*"; }
warn(){ WARN=$((WARN+1)); printf '[WARN] %s\n' "$*"; }
fail(){ FAIL=$((FAIL+1)); printf '[FAIL] %s\n' "$*" >&2; }

echo
echo "============================================================"
echo " PHASE 2 — LAB 6 EVIDENCE / REPOSITORY AUDIT"
echo "============================================================"
echo "Repo: $REPO_ROOT"
echo

[[ -d "$REPO_ROOT/.git" ]] && pass "Git repository found" || { fail "Git repository not found"; exit 1; }

LAB_DIR="$(find "$REPO_ROOT/evidence" -maxdepth 1 -type d -name 'phase2-network-investigation-*' 2>/dev/null | sort | tail -1 || true)"
REPORT_FILE="$(find "$REPO_ROOT/reports" -maxdepth 1 -type f -name 'phase2-network-investigation-*.txt' 2>/dev/null | sort | tail -1 || true)"

if [[ -n "$LAB_DIR" ]]; then
    pass "Latest Lab 6 evidence directory found: ${LAB_DIR##*/}"
else
    fail "No Lab 6 evidence directory found"
fi

if [[ -n "$REPORT_FILE" ]]; then
    pass "Latest Lab 6 report found: ${REPORT_FILE##*/}"
else
    fail "No Lab 6 report found"
fi

echo
echo "===== REPORT RESULT ====="
if [[ -n "$REPORT_FILE" ]]; then
    grep -E '^(PASS|WARN|FAIL):|LAB 6 COMPLETED' "$REPORT_FILE" || warn "Expected report summary lines not found"
    if grep -q '^FAIL: 0$' "$REPORT_FILE" && grep -q '^WARN: 0$' "$REPORT_FILE"; then
        pass "Report records 0 warnings and 0 failures"
    else
        warn "Report is not a clean 0-WARN/0-FAIL result"
    fi
fi

echo
echo "===== EVIDENCE INVENTORY ====="
if [[ -n "$LAB_DIR" ]]; then
    find "$LAB_DIR" -maxdepth 1 -type f -printf '%f\t%k KB\n' | sort
    FILE_COUNT="$(find "$LAB_DIR" -maxdepth 1 -type f | wc -l)"
    pass "Evidence file count: $FILE_COUNT"

    PCAP="$(find "$LAB_DIR" -maxdepth 1 -type f -name '*.pcapng' | head -1 || true)"
    if [[ -n "$PCAP" ]]; then
        PCAP_BYTES="$(stat -c '%s' "$PCAP")"
        printf 'PCAP size: %s bytes\n' "$PCAP_BYTES"
        if (( PCAP_BYTES <= 5242880 )); then
            pass "PCAP is <= 5 MiB"
        else
            warn "PCAP exceeds 5 MiB; consider whether it belongs in the public repository"
        fi
    else
        fail "No PCAP evidence found"
    fi
fi

echo
echo "===== SENSITIVE DATA REVIEW ====="
if [[ -n "$LAB_DIR" ]]; then
    # Loopback is expected. Report other IPv4 addresses and MAC addresses.
    OTHER_IPS="$(
        grep -RhoE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$LAB_DIR" 2>/dev/null |
        grep -vE '^127\.0\.0\.1$' |
        sort -u || true
    )"
    if [[ -n "$OTHER_IPS" ]]; then
        warn "Non-loopback IPv4 addresses found:"
        printf '%s\n' "$OTHER_IPS"
    else
        pass "No non-loopback IPv4 addresses found"
    fi

    MACS="$(grep -RhoEi '\b([0-9a-f]{2}:){5}[0-9a-f]{2}\b' "$LAB_DIR" 2>/dev/null | sort -u || true)"
    if [[ -n "$MACS" ]]; then
        warn "MAC addresses found in evidence; review before publishing"
        printf '%s\n' "$MACS"
    else
        pass "No MAC addresses found"
    fi

    SECRET_HITS="$(
        grep -RIniE 'Authorization:|Cookie:|Set-Cookie:|password[[:space:]]*=|api[_-]?key[[:space:]]*=|secret[[:space:]]*=|token[[:space:]]*=' "$LAB_DIR" 2>/dev/null |
        head -30 || true
    )"
    if [[ -n "$SECRET_HITS" ]]; then
        warn "Potential credential/secret patterns found; review:"
        printf '%s\n' "$SECRET_HITS"
    else
        pass "No obvious credential/secret patterns found"
    fi

    # User/host identity can be useful in private evidence but is usually unnecessary publicly.
    IDENTITY_HITS="$(
        grep -RIniE '(^|[[:space:]])(uid|gid|users?)=[0-9]+|/home/[A-Za-z0-9_.-]+|^[[:space:]]*user[[:space:]]*:' "$LAB_DIR" 2>/dev/null |
        head -20 || true
    )"
    if [[ -n "$IDENTITY_HITS" ]]; then
        warn "Host/user identity information is present; review for public release"
    else
        pass "No obvious home-directory/user identity paths found"
    fi
fi

echo
echo "===== GIT / SECRET / SCRIPT CHECKS ====="
cd "$REPO_ROOT"

git status --short

if git status --porcelain | grep -q .; then
    warn "Working tree contains changes (expected before staging Lab 6)"
else
    pass "Working tree is clean"
fi

SCRIPT="$REPO_ROOT/scripts/phase2-network-investigation.sh"
if [[ -f "$SCRIPT" ]]; then
    bash -n "$SCRIPT" && pass "Lab 6 script syntax check passed" || fail "Lab 6 script syntax check failed"
    grep -q 'TARGET_IP="127.0.0.1"' "$SCRIPT" && pass "Script hard-codes loopback target" || fail "Target safety control missing"
    grep -q 'LO_INTERFACE="lo"' "$SCRIPT" && pass "Script hard-codes loopback capture interface" || fail "Loopback capture control missing"
else
    fail "Lab 6 script missing"
fi

# Scan only the Lab 6 script/report/evidence for common accidental secret material.
SECRET_REPO_HITS="$(
    grep -RIniE 'gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY-----' \
      "$REPO_ROOT/scripts/phase2-network-investigation.sh" \
      ${REPORT_FILE:+"$REPORT_FILE"} \
      ${LAB_DIR:+"$LAB_DIR"} 2>/dev/null | head -20 || true
)"
if [[ -n "$SECRET_REPO_HITS" ]]; then
    fail "High-confidence secret pattern detected"
    printf '%s\n' "$SECRET_REPO_HITS"
else
    pass "High-confidence secret scan passed"
fi

echo
echo "===== GIT TRACKING CHECK ====="
if git ls-files --error-unmatch scripts/phase2-network-investigation.sh >/dev/null 2>&1; then
    pass "Lab 6 script is tracked by Git"
else
    warn "Lab 6 script is not yet tracked (stage it after review)"
fi

if [[ -n "$LAB_DIR" ]]; then
    TRACKED_LAB="$(git ls-files "${LAB_DIR#$REPO_ROOT/}" | wc -l)"
    printf 'Tracked files under latest Lab 6 evidence: %s\n' "$TRACKED_LAB"
fi

echo
echo "============================================================"
echo " AUDIT SUMMARY"
echo "============================================================"
echo " PASS : $PASS"
echo " WARN : $WARN"
echo " FAIL : $FAIL"
echo "============================================================"

if (( FAIL > 0 )); then
    exit 1
fi
exit 0
