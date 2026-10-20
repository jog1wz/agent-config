---
name: code-review
description: Fast, high-signal review of a diff, PR, branch, or modified files. Flags only issues in changed lines; defers tests to CI. Use when asked to review code or a PR.
---

# Code Review

Perform fast, high-signal code reviews of a diff, PR, branch, or modified files.

## Strict Scoping
- **Modified files only:** Suggest changes strictly for files and lines modified in the diff/branch.
- **Never touch unchanged code:** Never flag pre-existing issues, lint warnings, or formatting in untouched files.
- **Reference only:** Use conventions (`CLAUDE.md`, etc.) and sibling modules strictly as read-only architectural context.

## Speed, Testing & Token Policy
- **Defer test execution to CI:** Do NOT run test runners (`jest`, `npm test`, `pytest`, `bats`, etc.) during review. Inspect test presence, coverage, and test code logic declaratively from the diff. Include required tests in the PR verification checklist for CI.
- **Fast static checks only:** Static linters or type-checks (e.g. `tsc --noEmit`, scoped `eslint`) may be run autonomously ONLY if non-destructive, scoped to modified files, and completing under 10s. Never run build pipelines or cloud previews (`pulumi preview`).
- **No file creation/edits without approval:** Do not modify code without explicit user confirmation.

## Review Protocol
1. **Gather context in one shot:** Run `gather-diff.sh` once. If large diffs are truncated, read only the missing modified sections in parallel.
2. **Review against checklist (`references/checklist.md`):**
   - Correctness, OWASP security, maintainability, performance, test adequacy (static review), repo architectural patterns.
   - **Tenant Breaking Changes:** Require staged migration (create new -> verify tenant integration -> delete old).
3. **Single unified response:** Output all review artifacts together in one turn:
   - **Findings:** Grouped by severity (`Blocker` / `Should-fix` / `Nit`), formatted as `path/file.ext:line — issue → fix`. Omit categories with no issues; no conversational filler.
   - **PR Description:** Formatted per `references/pr-description-template.md` (`DP-xxxx: <title>`, Overview, Key Changes, Breaking Changes & Tenant Impact, CI Verification Checklist).
   - **Action prompt:** Ask if user wants fixes applied.

## PR Review Comments Remediation Protocol
When tasked with reviewing and remediating comments on an existing Pull Request (e.g. `/conductor:newTrack` or `/conductor:implement` for PR feedback):
1. **Fetch Threads via Azure DevOps CLI:**
   ```bash
   az devops invoke \
     --area git \
     --resource pullRequestThreads \
     --organization https://dev.azure.com/pt-iot \
     --route-parameters project=DeliveryPlatform repositoryId=dp.infra.tenant-services pullRequestId=<PR_ID> \
     --api-version 7.0
   ```
2. **Incremental Point-by-Point Execution:** Propose changes separately for each review comment/thread, presenting the diff and awaiting user confirmation before applying.
3. **Deferred Commit & Amend Policy:** Never commit automatically and do not prompt or ask to commit. Keep all modified files uncommitted in the working tree for user review. When the user explicitly instructs to commit, amend the previous commit (`git commit --amend`) where applicable to keep the git tree clean and minimize commit count.
