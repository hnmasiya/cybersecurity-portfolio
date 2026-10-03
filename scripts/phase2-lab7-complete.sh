#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

ROOT="$(git rev-parse --show-toplevel)"
SCRIPT_PATH="$ROOT/scripts/phase2-lab7-complete.sh"
STAMP="$(date -u +%Y%m%d-%H%M%S)"
LAB_ID="LAB7-$STAMP"
BRANCH="feat/phase2-linux-process-investigation-$STAMP"
COMMIT_MSG="feat: add Phase 2 Linux endpoint process investigation lab"

PORT=18765
NEGATIVE_PORT=18766
MARKER="LAB7-PROCESS-INVESTIGATION"

EVIDENCE_DIR="$ROOT/evidence/phase2-linux-process-investigation-$STAMP"
REPORT="$ROOT/reports/phase2-linux-process-investigation-$STAMP.txt"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
PY_PID=""
HTTP_PID=""

die() {
    echo "[FAIL] $*" >&2
    exit 1
}

pass() {
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "[PASS] $*"
}

warn() {
    WARN_COUNT=$((WARN_COUNT + 1))
    echo "[WARN] $*"
}

fail() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "[FAIL] $*" >&2
}

cleanup() {
    if [[ -n "${PY_PID:-}" ]]; then
        kill "$PY_PID" 2>/dev/null || true
        wait "$PY_PID" 2>/dev/null || true
    fi

    if [[ -n "${HTTP_PID:-}" ]]; then
        kill "$HTTP_PID" 2>/dev/null || true
        wait "$HTTP_PID" 2>/dev/null || true
    fi

    rm -rf "${TEST_ROOT:-}" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

require_cmd() {
    command -v "$1" >/dev/null 2>&1 ||
        die "Required command unavailable: $1"
}

echo "============================================================"
echo "PHASE 2 — LAB 7 COMPLETE SINGLE-SCRIPT PIPELINE"
echo "============================================================"
echo "Repository : $ROOT"
echo "Lab ID     : $LAB_ID"
echo "Branch     : $BRANCH"
echo "Target     : 127.0.0.1:$PORT"
echo

echo "===== PRE-FLIGHT ====="

for cmd in git bash python3 grep sed awk find sha256sum gh ss; do
    require_cmd "$cmd"
done

[[ -d "$ROOT/.git" ]] || die "Not a Git repository"

if [[ "$(git branch --show-current)" != "main" ]]; then
    die "Run this pipeline from main"
fi

git fetch origin >/dev/null 2>&1 || die "Unable to fetch origin"

git diff --quiet ||
    die "Uncommitted tracked changes exist"

git diff --cached --quiet ||
    die "Staged changes exist"

STATUS="$(git status --short)"

if [[ -n "$STATUS" ]]; then
    echo "$STATUS"

    if [[ "$STATUS" != "?? scripts/phase2-lab7-complete.sh" ]]; then
        die "Working tree contains unexpected changes"
    else
        pass "Only the Lab 7 pipeline script is pending"
    fi
else
    pass "Working tree is clean"
fi

git reset --hard origin/main >/dev/null

pass "Repository is synchronized with origin/main"
pass "Required tools are available"
pass "Working tree is clean"

mkdir -p "$EVIDENCE_DIR" "$ROOT/reports"

TEST_ROOT="$(mktemp -d /tmp/lab7-process.XXXXXX)"
printf '%s\n' "$MARKER" > "$TEST_ROOT/index.html"

echo
echo "===== CONTROLLED PROCESS ====="

cat > "$TEST_ROOT/server.py" <<'PY'
import http.server
import socketserver

PORT = 18765

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        body = b"LAB7-PROCESS-INVESTIGATION\n"
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        pass

with socketserver.TCPServer(("127.0.0.1", PORT), Handler) as server:
    server.serve_forever()
PY

python3 "$TEST_ROOT/server.py" &
PY_PID=$!

sleep 1

if kill -0 "$PY_PID" 2>/dev/null; then
    pass "Controlled benign Python process started"
else
    fail "Controlled process failed to start"
fi

echo "$PY_PID" > "$EVIDENCE_DIR/process.pid"

echo
echo "===== PROCESS IDENTITY ====="

if [[ -r "/proc/$PY_PID/status" ]]; then
    tr '\0' ' ' < "/proc/$PY_PID/cmdline" > "$EVIDENCE_DIR/proc-cmdline.txt" || true
    readlink "/proc/$PY_PID/cwd" > "$EVIDENCE_DIR/proc-cwd.txt" 2>&1 || true
    readlink "/proc/$PY_PID/exe" > "$EVIDENCE_DIR/proc-exe.txt" 2>&1 || true
    readlink "/proc/$PY_PID/root" > "$EVIDENCE_DIR/proc-root.txt" 2>&1 || true
    cat "/proc/$PY_PID/status" > "$EVIDENCE_DIR/proc-status.txt"

    pass "Process /proc identity is available"
else
    fail "Process /proc identity unavailable"
fi

echo
echo "===== PROCESS LINEAGE ====="

{
    echo "PID=$PY_PID"
    echo "PPID=$(awk '/^PPid:/ {print $2}' "/proc/$PY_PID/status" 2>/dev/null || true)"
    echo "CMDLINE=$(tr '\0' ' ' < "/proc/$PY_PID/cmdline" 2>/dev/null || true)"
    echo "EXE=$(readlink "/proc/$PY_PID/exe" 2>/dev/null || true)"
} > "$EVIDENCE_DIR/process-summary.txt"

PPID_VALUE="$(awk '/^PPid:/ {print $2}' "/proc/$PY_PID/status" 2>/dev/null || true)"

{
    echo "PID=$PY_PID"
    echo "PPID=$PPID_VALUE"
    if [[ -n "$PPID_VALUE" && -r "/proc/$PPID_VALUE/cmdline" ]]; then
        echo "PARENT_CMDLINE=$(tr '\0' ' ' < "/proc/$PPID_VALUE/cmdline")"
    fi
} > "$EVIDENCE_DIR/process-lineage.txt"

if [[ "$PPID_VALUE" =~ ^[0-9]+$ ]]; then
    pass "Parent process relationship captured"
else
    warn "Parent process relationship unavailable"
fi

echo
echo "===== EXECUTABLE ====="

readlink "/proc/$PY_PID/exe" > "$EVIDENCE_DIR/proc-exe.txt" 2>&1 || true

if grep -Fq "python" "$EVIDENCE_DIR/proc-exe.txt"; then
    pass "Controlled process executable identified as Python"
else
    warn "Python executable identity could not be confirmed"
fi

EXE_PATH="$(readlink "/proc/$PY_PID/exe" 2>/dev/null || true)"

if [[ -n "$EXE_PATH" && -f "$EXE_PATH" ]]; then
    sha256sum "$EXE_PATH" > "$EVIDENCE_DIR/executable-sha256.txt"
    pass "Executable SHA256 captured"
else
    warn "Executable SHA256 unavailable"
fi

echo
echo "===== FILE / SOCKET CORRELATION ====="

if command -v lsof >/dev/null 2>&1; then
    lsof -n -p "$PY_PID" > "$EVIDENCE_DIR/lsof.txt" 2>&1 || true
    pass "lsof process correlation captured"
else
    echo "lsof unavailable" > "$EVIDENCE_DIR/lsof.txt"
    warn "lsof unavailable"
fi

ss -ltnp > "$EVIDENCE_DIR/listening-sockets.raw.txt" 2>&1 || true

awk -v port="$PORT" '
    $1 == "State" { print; next }
    $0 ~ (":" port "([[:space:]]|$)") {
        gsub(/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+/, "<LOCAL-LISTENER>")
        print
        next
    }
    $0 ~ /^[[:space:]]*LISTEN/ {
        gsub(/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+/, "<LOCAL-LISTENER>")
        print
        next
    }
    { print }
' "$EVIDENCE_DIR/listening-sockets.raw.txt" \
    > "$EVIDENCE_DIR/listening-sockets.txt"

rm -f "$EVIDENCE_DIR/listening-sockets.raw.txt"

if grep -Fq ":$PORT" "$EVIDENCE_DIR/listening-sockets.txt"; then
    pass "Controlled localhost listener correlated"
else
    warn "Controlled listener was not visible in ss output"
fi

echo
echo "===== POSITIVE NETWORK TEST ====="

if curl -fsS --max-time 3 \
    "http://127.0.0.1:$PORT/" \
    > "$EVIDENCE_DIR/http-response.txt"; then

    if grep -Fq "$MARKER" "$EVIDENCE_DIR/http-response.txt"; then
        pass "Positive localhost HTTP marker confirmed"
    else
        fail "Expected HTTP marker missing"
    fi
else
    fail "Positive localhost HTTP request failed"
fi

echo
echo "===== NEGATIVE NETWORK TEST ====="

if curl -fsS --max-time 2 \
    "http://127.0.0.1:$NEGATIVE_PORT/" \
    > "$EVIDENCE_DIR/http-negative.txt" 2>&1; then

    fail "Unexpected response from negative test port"
else
    pass "Negative test port correctly produced no service response"
fi

echo
echo "===== PROCESS INVESTIGATION FINDINGS ====="

cat > "$EVIDENCE_DIR/findings.txt" <<FINDINGS
LAB ID: $LAB_ID
Controlled process PID: $PY_PID
Controlled listener: 127.0.0.1:$PORT
Negative test: 127.0.0.1:$NEGATIVE_PORT
Marker: $MARKER

FINDINGS

if [[ -n "$PPID_VALUE" ]]; then
    cat >> "$EVIDENCE_DIR/findings.txt" <<FINDINGS
Process lineage:
PID $PY_PID -> PPID $PPID_VALUE

FINDINGS
fi

cat >> "$EVIDENCE_DIR/findings.txt" <<'FINDINGS'
Assessment:
The observed process, executable, parent relationship, localhost listener,
and HTTP transaction were generated intentionally as a controlled lab activity.
The evidence establishes process-to-socket correlation for the test process.

No malicious activity or compromise is inferred from this controlled test.
FINDINGS

pass "Controlled investigation findings documented"

echo
echo "===== EVIDENCE SANITIZATION ====="

sanitize_file() {
    local file="$1"

    [[ -f "$file" ]] || return 0

    sed -i \
        -e "s#${ROOT//\//\\/}#<REPO>#g" \
        -e "s#${HOME//\//\\/}#<HOME>#g" \
        -e "s#${USER}#<USER>#g" \
        -e "s#$(hostname)#<LAB-HOST>#g" \
        "$file"

    # Remove RFC1918/private and wildcard IPv4 addresses.
    sed -Ei \
        -e 's/\b10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b/<PRIVATE-IP>/g' \
        -e 's/\b192\.168\.[0-9]{1,3}\.[0-9]{1,3}\b/<PRIVATE-IP>/g' \
        -e 's/\b172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}\b/<PRIVATE-IP>/g' \
        -e 's/\b0\.0\.0\.0\b/<ANY-ADDRESS>/g' \
        "$file"

    # Restore the intentional localhost references.
    sed -i \
        -e 's/<PRIVATE-IP>:18765/127.0.0.1:18765/g' \
        -e 's/<PRIVATE-IP>:18766/127.0.0.1:18766/g' \
        "$file"
}

while IFS= read -r -d '' file; do
    sanitize_file "$file"
done < <(find "$EVIDENCE_DIR" -type f ! -name "SHA256SUMS.txt" -print0)

pass "Evidence sanitization completed"

echo
echo "===== PRIVACY / SECURITY AUDIT ====="

if grep -REnI \
    -E '(^|[^0-9])(10\.[0-9]{1,3}\.)|(^|[^0-9])(192\.168\.)|(^|[^0-9])(172\.(1[6-9]|2[0-9]|3[0-1])\.)' \
    "$EVIDENCE_DIR" \
    --exclude=SHA256SUMS.txt >/tmp/lab7-private-ip-hits 2>/dev/null; then

    cat /tmp/lab7-private-ip-hits
    fail "Private IPv4 data remains in evidence"
else
    pass "No private IPv4 addresses remain in evidence"
fi

if grep -REnI \
    -E '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' \
    "$EVIDENCE_DIR" \
    --exclude=SHA256SUMS.txt >/tmp/lab7-mac-hits 2>/dev/null; then

    cat /tmp/lab7-mac-hits
    fail "MAC address detected in evidence"
else
    pass "No MAC addresses remain in evidence"
fi

if grep -REnI \
    -E 'BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|aws_access_key_id|aws_secret_access_key|password[[:space:]]*=' \
    "$EVIDENCE_DIR" \
    --exclude=SHA256SUMS.txt >/tmp/lab7-secret-hits 2>/dev/null; then

    cat /tmp/lab7-secret-hits
    fail "Potential secret detected in evidence"
else
    pass "No obvious secrets detected"
fi

if grep -REnI \
    -E '/home/[A-Za-z0-9_.-]+|/root/' \
    "$EVIDENCE_DIR" \
    --exclude=SHA256SUMS.txt >/tmp/lab7-identity-hits 2>/dev/null; then

    cat /tmp/lab7-identity-hits
    fail "Unsanitized user/home path detected"
else
    pass "No unsanitized user/home paths detected"
fi

rm -f /tmp/lab7-private-ip-hits \
      /tmp/lab7-mac-hits \
      /tmp/lab7-secret-hits \
      /tmp/lab7-identity-hits

echo
echo "===== SHA256 MANIFEST ====="

(
    cd "$EVIDENCE_DIR"

    find . -type f ! -name "SHA256SUMS.txt" -print0 |
        sort -z |
        xargs -0 sha256sum > SHA256SUMS.txt
)

pass "SHA256 manifest generated"

while read -r hash file; do
    [[ -n "$hash" && -n "$file" ]] || continue

    if (cd "$EVIDENCE_DIR" && sha256sum -c <(printf '%s  %s\n' "$hash" "$file")) \
        >/dev/null 2>&1; then
        :
    else
        fail "SHA256 verification failed: $file"
    fi
done < "$EVIDENCE_DIR/SHA256SUMS.txt"

if [[ "$FAIL_COUNT" -eq 0 ]]; then
    pass "All SHA256 manifest entries verified"
fi

echo
echo "===== FINAL REPORT ====="

cat > "$REPORT" <<REPORT
PHASE 2 — LAB 7
Linux Endpoint Process Investigation

LAB ID: $LAB_ID
UTC START: $STAMP
TARGET: 127.0.0.1:$PORT
NEGATIVE TEST: 127.0.0.1:$NEGATIVE_PORT

SCOPE
-----
Controlled local process investigation only.
No external hosts were scanned.
No production systems were modified.

INVESTIGATION
-------------
The lab created a benign Python HTTP service bound to localhost.
Evidence was collected for:
- process identity
- process lineage
- executable identity
- executable SHA256
- open files/process correlation
- listening socket
- positive HTTP transaction
- negative service test

PRIVACY CONTROLS
----------------
- Private IPv4 addresses removed
- MAC addresses checked
- Obvious secrets checked
- User/home paths checked
- Repository paths sanitized
- Loopback target retained where required for reproducibility

INTEGRITY
---------
SHA256 manifest generated and verified.

RESULT
------
PASS: $PASS_COUNT
WARN: $WARN_COUNT
FAIL: $FAIL_COUNT

FINAL DISPOSITION
-----------------
REPORT GENERATED BY SINGLE-SCRIPT LAB 7 PIPELINE.

The investigation demonstrates controlled endpoint process-to-network
correlation. It does not establish malicious activity or compromise.
REPORT

if [[ "$FAIL_COUNT" -gt 0 ]]; then
    echo
    echo "===== AUDIT FAILED ====="
    cat "$REPORT"
    exit 1
fi

if [[ "$WARN_COUNT" -gt 0 ]]; then
    echo "[WARN] Lab completed with warnings."
else
    pass "Lab completed with zero warnings and zero failures"
fi

echo
echo "===== EVIDENCE INVENTORY ====="

find "$EVIDENCE_DIR" -type f -printf '%P\n' | sort

echo
echo "===== GIT VALIDATION ====="

# The generated report/evidence are intentionally untracked until this point.
git diff --check
pass "Git whitespace validation passed"

echo
echo "===== CREATE FEATURE BRANCH ====="

git switch -c "$BRANCH"

git add "$SCRIPT_PATH" "$EVIDENCE_DIR" "$REPORT"

git diff --cached --check
pass "Staged content passes Git whitespace validation"

echo
echo "===== STAGED SECURITY CHECK ====="

if git diff --cached --name-only |
    grep -E '^evidence/phase2-linux-process-investigation-|^reports/phase2-linux-process-investigation-|^scripts/phase2-lab7-complete\.sh$' \
    >/dev/null; then
    pass "Expected Lab 7 files are staged"
else
    die "Expected Lab 7 files are not staged"
fi

if git diff --cached --binary |
    grep -E '(^|\+)[[:space:]]*(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)' \
    >/dev/null 2>&1; then
    die "Private IPv4 address detected in staged additions"
fi

if git diff --cached --binary |
    grep -Ei 'BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|aws_secret_access_key|password[[:space:]]*=' \
    >/dev/null 2>&1; then
    die "Potential secret detected in staged additions"
fi

pass "Staged security scan passed"

echo
echo "===== SIGNED COMMIT ====="

git config commit.gpgsign true

git commit -m "$COMMIT_MSG"

COMMIT_SHA="$(git rev-parse HEAD)"

echo "Commit: $COMMIT_SHA"

if git verify-commit "$COMMIT_SHA" >/tmp/lab7-signature.txt 2>&1; then
    cat /tmp/lab7-signature.txt
    pass "Git commit signature verified"
else
    cat /tmp/lab7-signature.txt >&2 || true
    die "Signed commit verification failed"
fi

rm -f /tmp/lab7-signature.txt

echo
echo "===== PUSH FEATURE BRANCH ====="

git push -u origin "$BRANCH"

pass "Feature branch pushed"

echo
echo "===== CREATE PULL REQUEST ====="

PR_URL="$(
    gh pr create \
        --base main \
        --head "$BRANCH" \
        --title "$COMMIT_MSG" \
        --body "$(cat <<PRBODY
## Phase 2 — Lab 7

Automated Linux endpoint process investigation lab.

### Included
- Controlled localhost process investigation
- Process identity and lineage
- Executable verification
- Process/socket correlation
- Positive and negative network tests
- Evidence sanitization
- SHA256 evidence integrity
- Privacy/security checks

### Safety
All network activity is restricted to localhost.
No production systems or external hosts were targeted.

### Validation
The complete evidence package was generated and audited by the
single-script Lab 7 pipeline before this PR was created.
PRBODY
)"
)"

PR_NUMBER="$(printf '%s\n' "$PR_URL" | sed -nE 's#.*/pull/([0-9]+).*#\1#p')"

[[ "$PR_NUMBER" =~ ^[0-9]+$ ]] ||
    die "Unable to determine PR number"

echo "PR: #$PR_NUMBER"
echo "URL: $PR_URL"

echo
echo "===== WAIT FOR REQUIRED CHECKS ====="

gh pr checks "$PR_NUMBER" --watch --fail-fast

pass "Required GitHub checks passed"

echo
echo "===== MERGE PULL REQUEST ====="

gh pr merge "$PR_NUMBER" \
    --squash \
    --delete-branch \
    --subject "$COMMIT_MSG"

pass "Pull request merged"

echo
echo "===== FINAL MAIN SYNCHRONIZATION ====="

git fetch origin
git switch main
git reset --hard origin/main

LOCAL_SHA="$(git rev-parse HEAD)"
REMOTE_SHA="$(git rev-parse origin/main)"

if [[ "$LOCAL_SHA" == "$REMOTE_SHA" ]]; then
    pass "Local main matches origin/main"
else
    die "Local main does not match origin/main"
fi

echo
echo "===== FINAL STATUS ====="

git status --short --branch

if [[ -n "$(git status --short)" ]]; then
    die "Working tree is not clean after merge"
fi

pass "Working tree is clean"

echo
echo "===== FINAL HISTORY ====="

git --no-pager log -5 \
    --pretty=format:'%h %s'

echo
echo
echo "============================================================"
echo "LAB 7 COMPLETE"
echo "============================================================"
echo "PR:       #$PR_NUMBER"
echo "Branch:   $BRANCH"
echo "Commit:   $COMMIT_SHA"
echo "Evidence: $EVIDENCE_DIR"
echo "Report:   $REPORT"
echo "============================================================"
