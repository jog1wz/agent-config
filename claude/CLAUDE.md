---
description: "Global governance for all repositories: CLAUDE.md precedence, local-only Conductor artifacts, git safeguards, track archival, PR review remediation."
applyTo: "**"
---

# Global agent governance (shared by Copilot, Claude, Gemini)

## Follow repo-local CLAUDE.md

When working in a repository whose root contains a `CLAUDE.md` file, read it in full and treat it
as the authoritative source for that repository's architecture, conventions, build/test/preview
commands, and code style. Apply its guidance for the duration of the session.

## Skills

- Skills are centralized in `~/.agents/skills/<skill-name>/`; `~/.copilot/skills` and `~/.claude/skills` are symlinks to it.
- Always create/update skills directly in `~/.agents/skills/`. Never create `~/.gemini/skills` (duplicate-skill conflicts).

## Conductor workflow & local governance

- Conductor global templates live in `~/.agents/conductor/templates/` (workflow.md, product-guidelines.md, code_styleguides/). New projects inherit them when running Conductor setup.
- If a project has a `conductor/` directory and a file read is blocked by ignore patterns, fall back to `cat` via the shell.
- **Local-only artifacts:** everything under `conductor/` is local. NEVER `git add`, commit, or push it. Ensure `conductor/` is in `.git/info/exclude` (`echo "conductor/" >> .git/info/exclude`) when setting up a repo.
- **Track archival** ("archive conductor track(s)" / "archive track <name>"):
  1. Do NOT start `newTrack` or ask spec questions.
  2. `mkdir -p conductor/archive`.
  3. Move `conductor/tracks/<track_id>` to `conductor/archive/<track_id>`, keeping all files.
  4. Remove the archived entries from `conductor/tracks.md`, keep active tracks.
  5. Stay local-only; report the new paths.

## Git operations

- NEVER run `git commit` or `git push` unless the user explicitly asks in that prompt. Finishing work, fixing bugs, addressing review feedback, or passing tests does not imply permission. Do not prompt to commit either.
- Never develop directly on `main`/`master`: create a topic branch (`DP-xxxx/<short-description>` or `feature/<description>`) first.
- Prefer a single commit per unit of work; when explicitly told to commit follow-up changes, use `git commit --amend` where applicable.
- Read-only git inspection (`diff`, `status`, `log`, `show`, `branch`, `rev-parse`, `merge-base`) is always fine.

## Pull requests (Azure DevOps)

- PR title includes the ticket: `DP-xxxx: <title>`.
- Description sections: Overview, Key Changes, Breaking Changes & Tenant Impact, CI Verification Checklist.
- Offer to create the PR (`az repos pr create`) only after track changes are finalized.

### PR review comment remediation

1. Fetch active threads:
   `az devops invoke --area git --resource pullRequestThreads --organization https://dev.azure.com/pt-iot --route-parameters project=DeliveryPlatform repositoryId=<repo> pullRequestId=<PR_ID> --api-version 7.0`
2. Categorize by thread ID, file, line into the track `spec.md`/`plan.md`.
3. Address each comment separately; show the proposed diff and get approval before editing.
4. Leave changes uncommitted until the user says to commit.

## Style

- Prose: technical and direct, active voice, no jargon.
- Corporate branding for public-facing docs.
