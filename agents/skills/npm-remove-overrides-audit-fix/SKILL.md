---
name: npm-remove-overrides-audit-fix
description: 'Remediate npm dependency vulnerabilities across one or more Node.js/npm projects without using package.json "overrides" to pin transitive dependencies. Use when: removing npm overrides, reversing a transitive-dependency pin, running `npm audit fix` across multiple project folders in a monorepo, deciding whether a CVE is critical enough to justify keeping an override, regenerating package-lock.json after removing overrides, or writing a PR/commit description summarizing an npm vulnerability remediation pass. Triggers: "remove npm overrides", "run npm audit fix for each folder", "only update direct dependencies unless critical", "npm vulnerability remediation PR description".'
---

# Remove npm `overrides`, remediate with `npm audit fix` only

Policy: never use `overrides` to pin transitive deps for non-critical CVEs. Only bump **direct**
dependencies; let `npm audit fix` (no `--force`) apply safe transitive bumps. Keep/add an override
only for a finding with `"severity": "critical"` that has no non-breaking fix — call it out
explicitly. Anything else left over (moderate/high needing a semver-major bump) stays unfixed and
gets documented as a follow-up; never run `npm audit fix --force` in this pass.

## Steps
1. Find affected files: `./scripts/find-overrides.sh [root-dir]` (lists every `package.json`,
   excluding `node_modules`, with a top-level `overrides` key).
2. Per folder, run `npm audit --json`, check `metadata.vulnerabilities.critical`. If a critical
   finding maps to a currently-overridden package, keep that entry; plan to remove the rest.
3. Strip the rest: `node ./scripts/strip-overrides.cjs path/to/package.json` (deletes the
   `overrides` key in place). Re-add only the critical exception(s) by hand if needed.
4. Per folder: `npm install && npm audit fix && npm audit` — or sweep every affected folder at
   once with `./scripts/remove-overrides-and-audit-fix.sh [root-dir]`.
5. Run each project's test/build command to confirm nothing broke.
6. Write the PR description from [pr-description-template.md](./assets/pr-description-template.md):
   before/after vulnerability counts per folder, advisories resolved, remaining findings + reason,
   follow-ups.

## Notes
- Keep a legitimate direct-dependency bump even if it was originally paired with an override
  (e.g. `"js-yaml": "^4.1.0"` → `"^4.3.1"`) — only the `overrides` block is non-compliant.
- No shared root lockfile in a multi-project repo: repeat steps 3-5 per folder independently.
