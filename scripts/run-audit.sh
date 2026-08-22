#!/usr/bin/env bash
echo "=========================================================================="
echo "          1. REPOSITORY STRUCTURE & GIT HYGIENE AUDIT                     "
echo "=========================================================================="
git status
echo ""
echo "[*] Checking for untracked, stray, or temporary build files..."
find . -maxdepth 2 -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*resume.html" -o -name ".DS_Store" \)
echo ""

echo "=========================================================================="
echo "          2. SECURITY & SECRETS SCAN                                      "
echo "=========================================================================="
echo "[*] Checking git pre-commit hook status..."
if [ -x ".git/hooks/pre-commit" ]; then
    echo "[+] Pre-commit hook is active and executable."
else
    echo "[-] WARNING: Pre-commit hook missing or not executable!"
fi

echo ""
echo "[*] Auditing repository for unredacted hardcoded credentials or API keys..."
grep -riE '(api_key|aws_secret|private_key|bearer [a-z0-9_-]+)' . \
    --exclude-dir={.git,.venv} || echo "[+] No hardcoded secrets or sensitive keys detected."

echo ""
echo "=========================================================================="
echo "          3. WORKFLOW & CI/CD PIPELINE INTEGRITY                          "
echo "=========================================================================="
echo "[*] Verifying active GitHub Workflows in .github/workflows/:"
ls -la .github/workflows/

echo ""
echo "=========================================================================="
echo "          4. RESUME & PORTFOLIO ASSET ALIGNMENT                           "
echo "=========================================================================="
[ -f "Resume_Hazvinei_Masiya.md" ] && echo "[+] Resume_Hazvinei_Masiya.md present." || echo "[-] Missing MD resume!"
[ -f "Resume_Hazvinei_Masiya.pdf" ] && echo "[+] Resume_Hazvinei_Masiya.pdf present." || echo "[-] Missing PDF resume!"

echo ""
echo "=========================================================================="
echo "          5. SYNC STATE WITH REMOTE (ORIGIN/MAIN)                         "
echo "=========================================================================="
git fetch origin main
LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main)

if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
    echo "[+] Local repository is perfectly in sync with origin/main ($LOCAL_HASH)."
else
    echo "[!] Branch divergence detected between local and origin/main."
    echo "    Local : $LOCAL_HASH"
    echo "    Remote: $REMOTE_HASH"
fi
