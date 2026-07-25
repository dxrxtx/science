#!/usr/bin/env bash
# Reinstall / update the pharma R&D agent skills into this project's .claude/skills/
# Idempotent: safe to re-run. Requires: node/npx, git.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "==> [1/3] K-Dense scientific-agent-skills (npx skills, copy mode)"
npx -y skills@latest add K-Dense-AI/scientific-agent-skills \
  --agent claude-code --skill '*' --copy -y

echo "==> [2/3] NVIDIA BioNeMo agent toolkit (npx skills, copy mode)"
npx -y skills@latest add NVIDIA-BioNeMo/bionemo-agent-toolkit \
  --agent claude-code --skill '*' --copy -y

echo "==> [3/3] GPTomics bioSkills (official installer, bio- prefixed)"
TMP="$(mktemp -d)"
git clone --depth 1 https://github.com/GPTomics/bioSkills.git "$TMP/bioSkills"
# remove any partial single 'bioskills' skill from npx path if present
rm -rf "$PROJECT_DIR/.claude/skills/bioskills"
"$TMP/bioSkills/install-claude.sh" --project "$PROJECT_DIR"
rm -rf "$TMP"

echo ""
echo "Anthropic Life Sciences:"
echo "  - file skills (anthropic-*) are vendored in .claude/skills/ (committed)."
echo "  - MCP plugins are configured in .claude/settings.json; run /reload-plugins"
echo "    in Claude Code, then /plugin to add credentialed servers as needed."
echo ""
echo "Done. Installed skills: $(ls "$PROJECT_DIR/.claude/skills" | wc -l)"
echo "NOTE: full install adds ~150K+ tokens of always-loaded skill descriptions."
echo "      Trim categories you do not need — see README.md."
