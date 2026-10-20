# Pull Request Description Template

Use this format when generating the Markdown summary of changes for a PR description:

```markdown
### PR Title
DP-xxxx: <title>
<!-- Format: DP-xxxx: <title>, where xxxx is the number taken from the branch name (e.g. branch DP-2985/my-feature -> DP-2985: <title>). If no ticket number is present, omit prefix. -->

## Overview
<!-- Concise summary of what this PR accomplishes, motivation, and ticket references -->

## Key Changes
<!-- Bullet points organized by component, service, or tenant -->
- **<Component/Area/Tenant>**:
  - Description of specific change

## Breaking Changes & Tenant Impact
<!-- Note any breaking changes or required staged migration (1. create new service, 2. verify tenant integration, 3. delete old service). If none, state "None". -->
- None

## Verification & Testing (CI Checklist)
<!-- Checklist of verifications deferred to CI or required for reviewers -->
- [ ] Unit tests pass in CI
- [ ] Infrastructure preview verified (`pulumi preview`)
- [ ] Lint and static type checks pass
```
