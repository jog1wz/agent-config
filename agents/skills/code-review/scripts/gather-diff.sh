#!/usr/bin/env bash
# Single-shot context gatherer for code review: diff stat, filtered diff,
# changed-file list, available repo convention docs, and sibling structure.
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository" >&2
  exit 1
fi

repo_root=$(git rev-parse --show-toplevel)
MAX_DIFF_LINES=400

# High-churn and auto-generated files excluded from full diff to minimize context latency
DIFF_EXCLUDES=(
  ':(exclude)*package-lock.json'
  ':(exclude)*yarn.lock'
  ':(exclude)*pnpm-lock.yaml'
  ':(exclude)*Cargo.lock'
  ':(exclude)*poetry.lock'
  ':(exclude)*.min.js'
  ':(exclude)*.min.css'
  ':(exclude)*.map'
  ':(exclude)*.svg'
  ':(exclude)*.png'
  ':(exclude)*.jpg'
  ':(exclude)*.jpeg'
)

current_branch=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
echo "## Current branch"
echo "${current_branch}"
echo

if [[ -n $(git status --porcelain) ]]; then
  echo "## Diff summary (stat)"
  git diff --stat HEAD
  echo
  echo "## Uncommitted changes (working tree vs HEAD)"
  diff_range=""
  raw_diff=$(git diff HEAD -- "${DIFF_EXCLUDES[@]}")
else
  base="${1:-main}"
  echo "## Diff summary (stat) vs ${base}"
  git diff --stat "${base}...HEAD"
  echo
  echo "## Changes on current branch vs ${base}"
  diff_range="${base}...HEAD"
  raw_diff=$(git diff "${diff_range}" -- "${DIFF_EXCLUDES[@]}")
fi

# Print diff with cap to protect LLM context window and response speed
diff_lines=$(printf "%s\n" "${raw_diff}" | wc -l | tr -d " ")
if [[ "${diff_lines}" -gt "${MAX_DIFF_LINES}" ]]; then
  printf "%s\n" "${raw_diff}" | head -n "${MAX_DIFF_LINES}"
  echo
  echo "[... Diff truncated after ${MAX_DIFF_LINES} lines (${diff_lines} total). Run targeted git diff <file> if needed ...]"
else
  printf "%s\n" "${raw_diff}"
fi

echo
echo "## Changed files"
if [[ -n "${diff_range}" ]]; then
  changed_files=$(git diff --name-only "${diff_range}")
else
  changed_files=$(git diff --name-only HEAD; git status --porcelain | awk '$1=="??"{print $2}')
fi
echo "${changed_files}"

echo
echo "## Repo convention docs"
find "${repo_root}" -maxdepth 3 \
  \( -name ".git" -o -name "node_modules" -o -name ".venv" -o -name "dist" -o -name "build" -o -name ".terraform" \) -prune -o \
  \( -iname "CLAUDE.md" -o -iname "AGENTS.md" -o -iname "copilot-instructions.md" -o -iname "*.instructions.md" \) -print 2>/dev/null |
  while IFS= read -r f; do
    echo "- ${f#"$repo_root"/}"
  done
echo "(Conventions listed above; inspect on-demand if relevant to modified files)"

echo
echo "## Sibling directories (for structural consistency checks)"
printf "%s\n" "${changed_files}" | while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  dirname "$f"
done | sort -u | while IFS= read -r reldir; do
  [[ -z "$reldir" || "$reldir" == "." ]] && continue
  parent_rel=$(dirname "$reldir")
  echo "--- siblings in ${parent_rel}/ ---"
  find "${repo_root}/${parent_rel}" -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec basename {} \; 2>/dev/null | sort -u
done
