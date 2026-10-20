---
name: track-archive
description: Archive one or more conductor tracks by moving them from conductor/tracks/ to conductor/archive/ and removing them from tracks.md. Use when the user says "archive track(s)", "archive conductor track <name>", or runs /track-archive. Direct maintenance action; never starts new-track planning.
---

# Track Archive

Argument: one or more track names/IDs (partial names allowed), or "all completed".

## Rules
- Do NOT start `track-new` or ask spec/plan questions. This is a direct maintenance operation.
- `conductor/` is LOCAL ONLY: never `git add`, commit or push it.
- Validate every tool call; stop and report on failure.

## Steps
1. Run `mkdir -p conductor/archive`.
2. Resolve each requested track to `conductor/tracks/<track_id>` (match by ID or short name). If a name is ambiguous or not found, list the existing tracks and ask which one (use `ask_user`). If the target already exists in `conductor/archive/`, stop and report instead of overwriting.
3. Move each folder to `conductor/archive/<track_id>` with `mv`, keeping all files intact (`spec.md`, `plan.md`, `metadata.json`, `index.md`, etc.).
4. Update `conductor/tracks.md`: remove the entries (the `---` separator, `- [x]/[ ]/[~] **Track: ...**` line and its `*Link: ...*` line) for the archived tracks; keep every other entry intact and well formatted.
5. Confirm `conductor/` is in `.git/info/exclude`; if missing, tell the user (do not stage anything).
6. Announce completion with links to the archived paths, e.g. `[conductor/archive/<track_id>/](conductor/archive/<track_id>/)`.
