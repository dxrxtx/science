#!/usr/bin/env python3
"""Vendor agent skills from a source repo into .claude/skills/ with a provenance
prefix, rewriting frontmatter to a YAML-safe name+description so every skill loads
cleanly in Claude Code. Skips dirs without a valid name+description."""
import os, re, sys, shutil, yaml

DEST = "/home/user/science/.claude/skills"

def extract_field(lines, key):
    pat = re.compile(r'^' + re.escape(key) + r'\s*:\s*(.*)$')
    for ln in lines:
        m = pat.match(ln)
        if m:
            val = m.group(1).strip()
            # strip surrounding quotes if present
            if len(val) >= 2 and val[0] == val[-1] and val[0] in "\"'":
                val = val[1:-1]
            return val
    return None

def sanitize(name):
    n = name.strip().lower()
    n = re.sub(r'[^a-z0-9]+', '-', n).strip('-')
    return n or "skill"

def split_frontmatter(text):
    if not text.startswith('---'):
        return None, text
    m = re.match(r'^---\s*\n(.*?)\n---\s*\n?(.*)$', text, re.DOTALL)
    if not m:
        return None, text
    return m.group(1), m.group(2)

def main():
    src_root, prefix = sys.argv[1], sys.argv[2]
    installed, skipped, dup = 0, 0, 0
    seen = set()
    for dirpath, _, files in os.walk(src_root):
        if 'SKILL.md' not in files:
            continue
        if '/.git' in dirpath:
            continue
        skill_path = os.path.join(dirpath, 'SKILL.md')
        try:
            text = open(skill_path, encoding='utf-8', errors='replace').read()
        except Exception:
            skipped += 1; continue
        fm, body = split_frontmatter(text)
        if fm is None:
            skipped += 1; continue
        lines = fm.splitlines()
        name = extract_field(lines, 'name')
        desc = extract_field(lines, 'description')
        if not name or not desc:
            skipped += 1; continue
        new_name = prefix + sanitize(name)
        if new_name in seen:
            dup += 1; continue
        seen.add(new_name)
        dest_dir = os.path.join(DEST, new_name)
        if os.path.exists(dest_dir):
            dup += 1; continue
        shutil.copytree(dirpath, dest_dir)
        # rewrite frontmatter safely (name + description only)
        new_fm = yaml.safe_dump({'name': new_name, 'description': desc},
                                default_flow_style=False, allow_unicode=True, width=100000, sort_keys=False)
        open(os.path.join(dest_dir, 'SKILL.md'), 'w', encoding='utf-8').write(
            '---\n' + new_fm + '---\n' + body)
        installed += 1
    print(f"{prefix:12s} installed={installed} skipped={skipped} dup={dup}")

if __name__ == '__main__':
    main()
