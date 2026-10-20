---
name: track-revert
description: Safely revert a track, phase or task by identifying the associated git commits and undoing them after explicit confirmation. Use when the user asks to undo/revert conductor work or runs /track-revert.
---

# Track Revert

## Rules
- Use `ask_user` for selection and confirmation. Validate every tool call; stop on failure.
- Destructive: never run `git revert`/`reset`/`checkout`/`restore` without the final explicit confirmation described below.
- `conductor/` is LOCAL ONLY (untracked); plan/status files are restored by editing them, not by git.
- Never commit or push unless the user explicitly asks.

## Steps
1. **Setup check:** `conductor/tracks.md` must exist, else direct to `/track-setup`.
2. **Select target:** argument if given; otherwise list in-progress (`[~]`) items first, else the most recently completed tracks/phases/tasks, and ask which to revert (track, phase, or task). Confirm the choice.
3. **Find commits:** because conductor files are untracked, identify the code commits for the target from `plan.md` notes, `git log` (branch, ticket ID, messages, dates), and file paths named in the plan. Show the commits and affected files; ask the user to confirm the list (they may add/remove commits). If the work was never committed (still in the working tree), list the modified files and offer to restore only those files.
4. **Execution plan:** present exactly what will happen (commits to revert in reverse chronological order, files affected, plan markers to reset to `[ ]`, `tracks.md`/`metadata.json` status changes). Ask for explicit "Approve" before acting.
5. **Execute:** `git revert --no-commit <sha>` newest-first (or restore working tree files if uncommitted), resolve conflicts with the user, then reset the plan markers and statuses. Leave the result uncommitted for review.
6. **Verify:** confirm plan/registry consistency with the repo state and summarize.
