#!/bin/bash
set -euo pipefail

# Claude Code on the web defaults this container's global git identity to
# Claude <noreply@anthropic.com>. Override it with the repo owner's real
# identity so commits made during sessions on this repo are attributed
# correctly instead of showing up as authored by Claude.
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
  git config --global user.name "Hazvinei Nomatter Masiya"
  git config --global user.email "norman.masiya@gmail.com"
fi
