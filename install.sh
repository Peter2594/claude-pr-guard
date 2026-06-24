#!/usr/bin/env bash
set -euo pipefail

REPO="Peter2594/claude-pr-guard"
BRANCH="main"
SKILL="pr-guard"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}/skills/${SKILL}/SKILL.md"

# Default: install for the current user (available in every project).
# Pass --project to install into ./.claude/skills instead.
if [[ "${1:-}" == "--project" ]]; then
  DEST="$(pwd)/.claude/skills/${SKILL}"
else
  DEST="${HOME}/.claude/skills/${SKILL}"
fi

echo "📦 Installing PR Guard skill -> ${DEST}"
mkdir -p "${DEST}"

if curl -fsSL "${RAW}" -o "${DEST}/SKILL.md"; then
  echo "✅ Installed."
  echo "🚀 Restart Claude Code, then ask: \"review my local changes\" — PR Guard auto-triggers."
else
  echo "❌ Download failed. Check the repo/branch: ${REPO}@${BRANCH}" >&2
  exit 1
fi
