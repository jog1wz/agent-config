---
name: track-status
description: Show the status of conductor tracks and plans (current phase/task, completed vs pending, blockers). Use when the user asks for track/plan progress or runs /track-status.
---

# Track Status

Read-only. Never modify files.

1. Require `conductor/tracks.md` (and `conductor/tracks/`). If missing, tell the user to run `/track-setup`. (If a file read is blocked by ignore patterns, read it via the shell.)
2. Read `tracks.md` and each active track's `plan.md` and `metadata.json`.
3. Report:
   - Current date/time and overall status
   - Active track, current phase, and current/next task (`[~]` / first `[ ]`)
   - Counts: tasks completed (`[x]`), in progress (`[~]`), pending (`[ ]`), per track and total
   - Completed phases, remaining phases, any blockers or notes
   - Archived tracks count (`conductor/archive/`)
4. Keep it concise and formatted as a short table plus a bullet list.
