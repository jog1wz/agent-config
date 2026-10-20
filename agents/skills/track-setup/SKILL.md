---
name: track-setup
description: Interactive project setup for spec-driven development (Gemini-Conductor style). Interviews the user and creates the local conductor/ directory (product.md, product-guidelines.md, tech-stack.md, workflow.md, code_styleguides/, tracks.md, index.md). Use when the user asks to set up conductor/tracks for a repo or runs /track-setup.
---

# Track Setup

Interview-driven setup of the local `conductor/` context directory. Distinct from the `conductor` skill (YAML workflow runner).

## Rules
- Use the `ask_user` tool for ALL questions; batch up to 4 related questions per call. Offer 2-3 concrete options where possible and wait for answers.
- Validate every tool call; on failure stop and report.
- `conductor/` is LOCAL ONLY: ensure `conductor/` is in `.git/info/exclude` (append if missing). Never `git add`/commit/push these files.
- Never commit anything unless the user explicitly asks.
- Honor the repo's `CLAUDE.md` as authoritative project context.

## Steps
1. **Resume check:** if `conductor/` already has product.md, tech-stack.md and workflow.md, report setup is complete and stop (offer to edit individual files). If partially present, resume at the first missing file.
2. **Audit (brownfield vs greenfield):** inspect the repo (README, CLAUDE.md, manifests, source layout, git history). Existing code => brownfield: summarize findings and confirm with the user. Otherwise greenfield: ask for the project idea.
3. **Interactive generation**, one file at a time. For each: ask 2-4 context-aware questions (use findings to pre-fill options), draft the file, show the draft via `ask_user` (Approve / Revise), revise until approved, then write it:
   - `conductor/product.md` (vision, users, goals, features)
   - `conductor/product-guidelines.md` (prose style, branding, UX/DX principles). Default from `~/.agents/conductor/templates/product-guidelines.md`.
   - `conductor/tech-stack.md` (languages, frameworks, DBs, infra). Pre-fill from the repo.
   - `conductor/code_styleguides/`: copy the relevant guides from `~/.agents/conductor/templates/code_styleguides/` (always `general.md`, plus languages detected).
   - `conductor/workflow.md`: start from `~/.agents/conductor/templates/workflow.md` (the user's customized template); ask only about deviations (test coverage target, commit policy, branching).
4. **Index and registry:** write `conductor/index.md` linking product, guidelines, tech stack, workflow, code style guides, tracks registry and tracks directory; create `conductor/tracks.md` (empty registry) and `conductor/tracks/`, `conductor/archive/`.
5. **Greenfield only:** ask a few questions to build initial requirements, propose ONE initial track, confirm, and create it as `track-new` does.
6. Announce completion and suggest `/track-new`.

## Universal file resolution
Resolve context files via `conductor/index.md` links first, falling back to the default paths above.
