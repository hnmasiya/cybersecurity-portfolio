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
