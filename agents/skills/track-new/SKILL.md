---
name: track-new
description: Plan a new track (feature, bug fix, chore) Gemini-Conductor style. Asks clarifying questions, drafts and gets approval for spec.md and plan.md, creates conductor/tracks/<id>/ and updates tracks.md. Use when the user wants to plan or start a new change/feature/fix, or runs /track-new.
---

# Track New

Spec-driven planning for one change. Arguments (if any) are the track description.

## Rules
- Use `ask_user` for ALL questions; batch up to 4 per call; give 2-3 plausible options with brief explanations. Wait for answers.
- Validate every tool call; on failure stop and report.
- `conductor/` is LOCAL ONLY: never stage, commit or push it (ensure it is in `.git/info/exclude`). Never commit anything unless explicitly asked.
- Follow the repo's `CLAUDE.md`.

## Steps
1. **Setup check:** `conductor/product.md`, `tech-stack.md`, `workflow.md` must exist (resolve via `conductor/index.md`). If not, stop and tell the user to run `/track-setup`.
2. **Description:** if no argument, ask for a brief description. Infer type (feature vs bug/chore/refactor) without asking. Read product, tech-stack and workflow context, plus relevant code.
3. **Spec questions:** feature => 3-4 questions (behavior, inputs/outputs, interactions, scope); other => 2-3 (repro steps, scope, success criteria). Make them specific to this repo (e.g. which tenants, environments, feature flags, templates affected). Summarize understanding.
4. **Draft `spec.md`:** Overview, Functional Requirements, Non-Functional Requirements, Acceptance Criteria, Out of Scope. Show it in an `ask_user` (Approve / Revise) and iterate.
5. **Draft `plan.md`:** hierarchical Phases > Tasks > Sub-tasks following the methodology in `workflow.md` (e.g. test tasks before implementation, validation via `pulumi preview`/`npm test`). Every task has a marker: `- [ ] Task: ...`, sub-tasks `    - [ ] ...`. If `workflow.md` defines a Phase Completion / checkpoint protocol, append to each phase: `- [ ] Task: Conductor - User Manual Verification '<Phase Name>' (Protocol in workflow.md)`. Show for approval and iterate.
6. **Create artifacts:**
   - Short name must not match an existing track in `conductor/tracks/` or `conductor/archive/` (strip `_YYYYMMDD`); if it does, stop and suggest another name.
   - Track ID `<shortname>_<YYYYMMDD>`; create `conductor/tracks/<id>/` with `metadata.json` (`track_id`, `type`, `status: "new"`, `created_at`, `updated_at`, `description`), `spec.md`, `plan.md`, and `index.md` linking the three.
   - Append to `conductor/tracks.md`:
     ```
     
     ---
     
     - [ ] **Track: <description>**
     *Link: [./tracks/<id>/](./tracks/<id>/)*
     ```
7. **Announce:** track created; start with `/track-implement`. Do NOT commit.
