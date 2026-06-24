#!/usr/bin/env bash
set -euo pipefail

REPO="Peter2594/claude-pr-guard"
BRANCH="main"
BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

# Default: install for the current user (available in every project).
# Pass --project to install into ./.claude instead.
if [[ "${1:-}" == "--project" ]]; then
  ROOT="$(pwd)/.claude"
else
  ROOT="${HOME}/.claude"
fi

SKILL_DIR="${ROOT}/skills/pr-guard"
CMD_DIR="${ROOT}/commands"

echo "📦 Installing PR Guard -> ${ROOT}"
mkdir -p "${SKILL_DIR}" "${CMD_DIR}"

if curl -fsSL "${BASE}/skills/pr-guard/SKILL.md" -o "${SKILL_DIR}/SKILL.md" \
   && curl -fsSL "${BASE}/commands/pr-guard.md" -o "${CMD_DIR}/pr-guard.md"; then
  echo "✅ Installed skill + /pr-guard command."
  echo "🚀 Restart Claude Code. Auto: \"review my local changes\"  ·  Manual: /pr-guard"
else
  echo "❌ Download failed. Check the repo/branch: ${REPO}@${BRANCH}" >&2
  exit 1
fi
