#!/usr/bin/env bash
# Lists every package.json (excluding node_modules) that has a top-level "overrides" key.
set -uo pipefail

ROOT_DIR="${1:-.}"

matches=$(grep -rl '"overrides"' --include=package.json "$ROOT_DIR" 2>/dev/null | grep -v node_modules)

if [ -z "$matches" ]; then
  echo "No package.json files with an 'overrides' block found under $ROOT_DIR" >&2
  exit 0
fi

echo "$matches"
