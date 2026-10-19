#!/usr/bin/env bash
# Copies the skills in .claude/skills into ~/.claude/skills so every project can use them.
# Existing skills with the same name are skipped unless you pass --force.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)/.claude/skills"
dest="$HOME/.claude/skills"
force=0
[ "${1:-}" = "--force" ] && force=1

mkdir -p "$dest"
installed=0
skipped=0
for dir in "$src"/*/; do
  name="$(basename "$dir")"
  if [ -e "$dest/$name" ] && [ "$force" -eq 0 ]; then
    echo "skip   $name (already exists, use --force to overwrite)"
    skipped=$((skipped + 1))
    continue
  fi
  rm -rf "$dest/$name"
  cp -R "$dir" "$dest/$name"
  installed=$((installed + 1))
done
echo "Installed $installed skills, skipped $skipped. Restart Claude Code to load them."
