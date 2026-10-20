#!/usr/bin/env bash
# Installs shared agent config into $HOME. Existing files are backed up to *.bak.<timestamp>.
# Usage: ./install.sh [--with-instructions] [--with-settings] [--with-hooks]
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d%H%M%S)"
WITH_INSTR=0 WITH_SETTINGS=0 WITH_HOOKS=0
for a in "$@"; do
  case "$a" in
    --with-instructions) WITH_INSTR=1 ;;
    --with-settings) WITH_SETTINGS=1 ;;
    --with-hooks) WITH_HOOKS=1 ;;
    *) echo "unknown flag: $a" >&2; exit 1 ;;
  esac
done

backup() { [ -e "$1" ] || [ -L "$1" ] && mv "$1" "$1.bak.$TS" || true; }

# Skills: one real copy in ~/.agents/skills, symlinked for Copilot and Claude.
mkdir -p "$HOME/.agents" "$HOME/.copilot" "$HOME/.claude"
mkdir -p "$HOME/.agents/skills"
cp -R "$SRC/agents/skills/." "$HOME/.agents/skills/"
cp "$SRC/agents/.skill-lock.json" "$HOME/.agents/.skill-lock.json.shared"
cp -R "$SRC/agents/conductor" "$HOME/.agents/"
for link in "$HOME/.copilot/skills" "$HOME/.claude/skills"; do
  if [ ! -L "$link" ]; then backup "$link"; ln -s "$HOME/.agents/skills" "$link"; fi
done

if [ "$WITH_INSTR" = 1 ]; then
  mkdir -p "$HOME/.agents/instructions" "$HOME/.copilot/instructions"
  cp "$SRC/agents/instructions/global-governance.md" "$HOME/.agents/instructions/"
  [ -L "$HOME/.copilot/instructions/global-governance.md" ] || ln -s "$HOME/.agents/instructions/global-governance.md" "$HOME/.copilot/instructions/global-governance.md"
  cp "$SRC/copilot/instructions/claude-md-guidance.md" "$HOME/.copilot/instructions/"
  backup "$HOME/.copilot/copilot-instructions.md"; cp "$SRC/copilot/copilot-instructions.md" "$HOME/.copilot/"
  backup "$HOME/.claude/CLAUDE.md"; cp "$SRC/claude/CLAUDE.md" "$HOME/.claude/"
fi

if [ "$WITH_SETTINGS" = 1 ]; then
  backup "$HOME/.copilot/settings.json"; cp "$SRC/copilot/settings.json" "$HOME/.copilot/"
fi

if [ "$WITH_HOOKS" = 1 ]; then
  rm -rf "$HOME/.copilot/caveman"; cp -R "$SRC/copilot/caveman" "$HOME/.copilot/caveman"
  mkdir -p "$HOME/.copilot/hooks"
  backup "$HOME/.copilot/hooks/caveman.json"
  sed "s#__HOME__#$HOME#g" "$SRC/copilot/hooks/caveman.json" > "$HOME/.copilot/hooks/caveman.json"
fi

echo "Done. Restart Copilot CLI, then run /skills and /env to verify."
