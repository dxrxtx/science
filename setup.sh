#!/usr/bin/env bash
# Reinstall the pharma R&D agent skills into this project's .claude/skills/
# Installs the 9 license-permitted repos from the LinkedIn top-10 ranking.
# (OpenClaw-Medical-Skills is intentionally excluded — proprietary/All Rights
#  Reserved and not Claude Code format.)  Requires: node/npx, git, python3+pyyaml.
set -euo pipefail
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"
VENDOR="$PROJECT_DIR/scripts/vendor_skills.py"
STRIP_MB=1   # drop bundled data files larger than this (MB) after vendoring

clone() { local repo="$1" dir="$2"; rm -rf "$dir"; git clone --depth 1 "https://github.com/$repo.git" "$dir"; }

echo "==> npx-based installs (K-Dense, NVIDIA BioNeMo)"
npx -y skills@latest add K-Dense-AI/scientific-agent-skills   --agent claude-code --skill '*' --copy -y
npx -y skills@latest add NVIDIA-BioNeMo/bionemo-agent-toolkit --agent claude-code --skill '*' --copy -y

TMP="$(mktemp -d)"
echo "==> GPTomics bioSkills (official installer, bio- prefix)"
clone GPTomics/bioSkills "$TMP/bioSkills"
rm -rf "$PROJECT_DIR/.claude/skills/bioskills"
"$TMP/bioSkills/install-claude.sh" --project "$PROJECT_DIR"

echo "==> vendored installs (DeepMind, ClawBio, BioMate, AIPOCH, ToolUniverse)"
clone google-deepmind/science-skills          "$TMP/gdm"
clone ClawBio/ClawBio                          "$TMP/clawbio"
clone bioMate-AI/biomate-bioconductor-kb       "$TMP/biomate"
clone aipoch/medical-research-skills           "$TMP/aipoch"
clone mims-harvard/ToolUniverse                "$TMP/tooluniverse"
python3 "$VENDOR" "$TMP/gdm/skills"          "gdm-"
python3 "$VENDOR" "$TMP/clawbio"             "clawbio-"
python3 "$VENDOR" "$TMP/biomate/skills"      "biomate-"
python3 "$VENDOR" "$TMP/aipoch"              "aipoch-"
python3 "$VENDOR" "$TMP/tooluniverse/skills" "tuniv-"

echo "==> OpenClaw-Medical-Skills (MIT subset only — drop proprietary files)"
clone FreedomIntelligence/OpenClaw-Medical-Skills "$TMP/openclaw"
# Exclude any skill whose SKILL.md carries an 'All Rights Reserved' / proprietary
# notice (re-bundled third-party content that is NOT redistributable).
for f in $(grep -rl "All Rights Reserved\|proprietary and confidential" \
             "$TMP/openclaw/skills" --include=SKILL.md); do rm -rf "$(dirname "$f")"; done
python3 "$VENDOR" "$TMP/openclaw/skills"     "openclaw-"
rm -rf "$TMP"

echo "==> stripping bundled data files > ${STRIP_MB}MB (keeps SKILL.md + scripts)"
find "$PROJECT_DIR/.claude/skills" -type f -size +${STRIP_MB}M -delete

echo ""
echo "Anthropic Life Sciences: file skills (anthropic-*) are committed; MCP plugins"
echo "  are configured in .claude/settings.json — run /reload-plugins in Claude Code."
echo "Done. Installed skills: $(ls "$PROJECT_DIR/.claude/skills" | wc -l)"
echo "NOTE: full install adds ~400K+ tokens of always-loaded descriptions — trim per README.md."
