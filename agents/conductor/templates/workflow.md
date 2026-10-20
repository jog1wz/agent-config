# Project Workflow

This document outlines the development workflow for this project, combining standard Conductor practices with the conventions defined in `CLAUDE.md`.

## Guiding Principles

- **GitOps:** All infrastructure changes are declarative, version-controlled, and peer-reviewed.
- **Tenant Isolation:** Each tenant's infrastructure is managed independently within its own Pulumi project.
- **Modularity:** Reusable Pulumi components from the `templates/pulumi/` directory should be leveraged to avoid duplication.

## Development Cycle

1.  **Track Implementation:** All work is performed as part of a Conductor `track`.
2.  **Branching & Main Safeguard:** Never develop directly on `main`. If current branch is `main` (or `master`), create and switch to a dedicated topic branch (`DP-xxxx/<short-description>` or `feature/<description>`) before applying code changes.
3.  **Local Development:**
    *   Navigate to the relevant tenant directory (e.g., `cd b2b/pulumi-infra`).
    *   Ensure dependencies are installed with `npm ci`.
    *   Log in to the correct Pulumi backend and stack using the `pulumi-login.sh <env>` script.
    *   Make code changes, adhering to the project's Prettier and TypeScript style guides.
    *   Use `pulumi preview` frequently to check your changes against the Azure backend.
4.  **Unit Testing:**
    *   If changes are made to the shared `templates/pulumi/` directory, run unit tests via `npm test`.
    *   The required test code coverage is **>80%** for the template library.

## Conductor Local Governance

- Conductor artifacts (`conductor/`) are maintained for local workflow orchestration and planning.
- **Strictly Local-Only:** Conductor files are excluded in `.git/info/exclude` to prevent accidental tracking or committing.
- **Hook Safeguards:** Local `.git/hooks/pre-commit` and `.git/hooks/pre-push` guards are installed to intercept and abort any commit or push containing `conductor/` files.
- **Do not push Conductor configuration or internal track files to remote origin repositories.**

### Track Archival Protocol

When the user asks to "archive conductor track(s)" or "archive track <track_name>":
- **Direct Execution (No newTrack Ceremony):** Do not create a new track (`/conductor:newTrack`) or prompt for spec/plan generation. Archival is an internal maintenance operation.
- **Directory Verification:** Check for the existence of `conductor/archive/` and create it if missing (`mkdir -p conductor/archive`).
- **Relocate Track Folders:** Move the requested track folder(s) from `conductor/tracks/<track_id>` into `conductor/archive/<track_id>`, preserving all track files intact (`spec.md`, `plan.md`, `metadata.json`, `index.md`).
- **Update Tracks Registry:** Remove the corresponding section(s) from `conductor/tracks.md`, ensuring all remaining active or in-progress tracks remain intact and well-formatted.
- **Enforce Zero-Commit Governance:** Maintain all modifications as strictly local (untracked via `.git/info/exclude`). Never stage (`git add`), commit, or push any files in `conductor/`.
- **Confirm Completion:** Provide the user with a concise summary confirming the relocated paths and updated registry.

## Commits and Pull Requests

-   **Commits:** Where possible, changes should be squashed into a single commit for a given unit of work. Use semantic commit prefixes referencing the task or work item.
-   **Pull Requests:**
    *   **Automated PR Offer:** Once track changes are implemented and finalized, Conductor prompts the user whether to automatically create a Pull Request on Azure DevOps (`az repos pr create`).
    *   The PR title must include the ticket ID (`DP-xxxx: <title>`).
    *   The PR description must follow the project template (Overview, Key Changes, Breaking Changes & Tenant Impact, CI Verification Checklist).

## PR Review Comments Remediation Protocol

When requested to conduct or remediate PR review comments (e.g., via `/conductor:newTrack` for PR comments or `/conductor:implement` addressing reviewer feedback):

1. **Fetching PR Comments via Azure DevOps CLI:**
   - Retrieve all active PR review threads using the Azure DevOps REST API:
     ```bash
     az devops invoke \
       --area git \
       --resource pullRequestThreads \
       --organization https://dev.azure.com/pt-iot \
       --route-parameters project=DeliveryPlatform repositoryId=dp.infra.tenant-services pullRequestId=<PR_ID> \
       --api-version 7.0
     ```
   - Extract and categorize actionable reviewer feedback by thread ID, file path, and line numbers into the track `spec.md` and `plan.md`.

2. **Incremental Point-by-Point Remediation:**
   - Address each review comment/thread separately in isolated, incremental points.
   - Present the exact proposed changes/diff for each individual point to the user for explicit approval before modifying files.

3. **Deferred Git Commits (Manual Inspection Policy):**
   - **Never commit automatically:** Do not run `git commit` as individual files are modified during implementation.
   - Keep all modified files uncommitted in the working tree.
   - **Do not prompt or ask to commit:** Never initiate prompts to commit. Keep changes uncommitted in the working tree and only commit when the user explicitly instructs to do so.

4. **Clean Git Tree & Commit Amending:**
   - Keep the git tree clean with minimal commits.
   - When the user explicitly instructs to commit changes for a track or ongoing review iteration, amend the previous commit (`git commit --amend`) where applicable instead of generating multiple separate commits.

## CI/CD and Deployment

-   **Continuous Integration:** Pushing to a branch with an open PR triggers the Azure DevOps CI pipeline for the affected tenant(s). The pipeline runs `pulumi preview`.
-   **Deployment:**
    *   Merging the PR to the main branch triggers the deployment pipeline.
    *   The pipeline follows a `dev -> qa -> prod` progression.
    -   Each stage requires a manual approval gate before `pulumi up` is executed.
    *   After a successful deployment, InSpec compliance tests are run automatically.
-   **Drift Detection:** A separate pipeline runs daily to detect any manual changes or configuration drift in the deployed infrastructure.
