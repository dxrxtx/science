#!/usr/bin/env bash
# Trim the installed skills to a pharma R&D core profile (~376 skills), reducing
# always-loaded context from ~530K to ~80K tokens.
#
# KEEP : K-Dense + NVIDIA BioNeMo (no prefix), Google DeepMind (gdm-),
#        Anthropic file skills (anthropic-), and the drug-discovery-relevant
#        GPTomics bioSkills categories (bio-<category>-).
# DROP : OpenClaw, AIPOCH, ToolUniverse, ClawBio, BioMate, and non-core bioSkills.
#
# Reversible: run ./setup.sh to restore the full 2,419-skill install.
set -euo pipefail
DEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.claude/skills"

# bioSkills categories to KEEP
KEEP_BIO_CATS="chemoinformatics structural-biology clinical-biostatistics \
clinical-databases differential-expression pathway-analysis single-cell \
proteomics variant-calling immunoinformatics workflows"

echo "before: $(ls "$DEST" | wc -l) skills"

# 1) drop whole sources
for p in openclaw- aipoch- tuniv- clawbio- biomate-; do
  rm -rf "$DEST/$p"*
done

# 2) drop non-core bioSkills categories
keep_re="^bio-($(echo "$KEEP_BIO_CATS" | tr ' ' '|' | sed 's/|*$//' | sed 's/\([a-z-]*\)/\1-/g'))"
for d in "$DEST"/bio-*; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  keep=0
  for c in $KEEP_BIO_CATS; do case "$name" in bio-$c-*) keep=1;; esac; done
  [ "$keep" = 0 ] && rm -rf "$d"
done

echo "after:  $(ls "$DEST" | wc -l) skills (pharma R&D core profile)"
echo "restore full install with: ./setup.sh"
