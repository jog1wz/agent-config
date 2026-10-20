#!/usr/bin/env bash
# Strips non-critical npm "overrides" and re-runs `npm audit fix` for every affected
# package.json under ROOT_DIR. See ../SKILL.md for the full policy and procedure.
#
# Usage: ./remove-overrides-and-audit-fix.sh [root-dir]
#
# IMPORTANT: this does not decide critical-vs-not for you. Review each folder's
# `npm audit` output for "severity": "critical" findings BEFORE running this, and
# manually keep/re-add the corresponding override entry if needed (see SKILL.md step 2).
set -uo pipefail

ROOT_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mapfile -t FILES < <(grep -rl '"overrides"' --include=package.json "$ROOT_DIR" 2>/dev/null | grep -v node_modules)

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No package.json files with an 'overrides' block found under $ROOT_DIR"
  exit 0
fi

for f in "${FILES[@]}"; do
  dir=$(dirname "$f")
  echo ""
  echo "=== $dir ==="
  node "$SCRIPT_DIR/strip-overrides.cjs" "$f"
  (
    cd "$dir" || exit 1
    npm install
    npm audit fix
    echo "--- remaining npm audit for $dir ---"
    npm audit
  )
done
