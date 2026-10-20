---
name: track-review
description: Review completed track work against its spec, plan, workflow and style guides; produce findings (Blocker/Should-fix/Nit) and a PR description. Use when the user asks to review track changes or runs /track-review.
---

# Track Review

## Rules
- Review is read-only on code unless the user approves fixes. Validate every tool call; stop on failure.
- `conductor/` is LOCAL ONLY. Never commit or push unless the user explicitly asks.
- Follow the repo's `CLAUDE.md`.

## Steps
1. **Setup check:** product.md, tech-stack.md, workflow.md must exist, else `/track-setup`.
2. **Scope:** argument = track name/ID or "current" (the active track or the current branch diff). Determine the diff to review: `git diff <merge-base with main>...HEAD` plus uncommitted changes.
3. **Context:** read the track's `spec.md` and `plan.md`, `workflow.md`, `product-guidelines.md`, `tech-stack.md`, and `code_styleguides/`.
4. **Analyze:** verify against the spec's acceptance criteria and every `[x]` plan task; check correctness, security (secrets, public access, RBAC, network rules), Pulumi/IaC specifics (tenant isolation, feature flags, per-env config, drift), tests and coverage per workflow, style (Prettier 120 cols, TS strict), and docs. Run tests/lint where the workflow defines them.
5. **Output findings:**
   ```
   ## Summary
   ## Findings
   ### Blocker
   ### Should-fix
   ### Nit
   ## PR Description
   ### PR Title      (DP-xxxx: <title>)
   ## Overview
   ## Key Changes
   ## Breaking Changes & Tenant Impact
   ## Verification & Testing (CI Checklist)
   ```
   Cite file:line for each finding. Omit empty severities.
6. **Decision:** ask the user to (a) approve as-is, (b) fix findings now (then implement approved fixes, left uncommitted), or (c) stop. Offer to archive the track once approved. Do not commit unless explicitly told.
