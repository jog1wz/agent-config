---
name: track-implement
description: Implement a planned track task by task from conductor/tracks/<id>/plan.md, following conductor/workflow.md, updating status markers. Use when the user asks to implement/continue a track or runs /track-implement.
---

# Track Implement

Executes a track's `plan.md`. Argument (optional) = track name/ID.

## Rules
- Use `ask_user` for decisions. Validate every tool call; on failure stop and report.
- `conductor/` is LOCAL ONLY: never stage, commit or push it.
- **Never run `git commit`/`git push` unless the user explicitly asks.** Do not offer or prompt to commit; leave changes in the working tree. If the user does ask to commit, prefer amending the previous commit where applicable (see `workflow.md`).
- Never develop on `main`/`master`: create/switch to `DP-xxxx/<short-description>` or `feature/<description>` first (ask for the ticket number if unknown).
- Follow the repo's `CLAUDE.md` and `conductor/workflow.md` (and `code_styleguides/`).

## Steps
1. **Setup check:** product.md, tech-stack.md, workflow.md must exist, else direct the user to `/track-setup`.
2. **Select track:** use the argument (match against `conductor/tracks.md` / `conductor/tracks/`), else the first incomplete (`[ ]` or `[~]`) track in `tracks.md`. Confirm the selection with the user. If none, suggest `/track-new`.
3. **Mark in progress:** set the track to `[~]` in `tracks.md`, `status: "in_progress"` in `metadata.json`.
4. **Load context:** the track's `spec.md`, `plan.md`, and `workflow.md`.
5. **Task loop:** for each task in order:
   - mark `[~]` in `plan.md`;
   - follow the workflow's methodology (e.g. write tests first, implement minimally, run tests/lint; for Pulumi changes run `npm test` in `templates/pulumi` and `pulumi preview` as the workflow dictates; check coverage targets);
   - mark `[x]` and note completion in `plan.md` (no commit hash unless the user committed).
6. **Phase checkpoints:** at the end of a phase, if `workflow.md` defines a verification protocol, run its automated checks, present manual verification steps to the user, and wait for explicit confirmation before continuing.
7. **Finish:** when all tasks are `[x]`, update `tracks.md` to `[x]` and `metadata.json` to `completed`. Check whether product.md, tech-stack.md or README need updates based on the spec, and propose them (ask before editing). Offer to archive the track (move to `conductor/archive/`, remove from `tracks.md`), delete it, or keep it. If the workflow calls for a PR, offer to create it only after the user's go-ahead.
