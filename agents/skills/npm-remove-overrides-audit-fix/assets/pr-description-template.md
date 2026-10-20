## <TICKET>: Fix npm vulnerabilities (direct dependency updates only)

### Summary

Per team policy, `overrides` are no longer used to pin transitive dependencies for vulnerability
remediation. This PR removes any previously-added `overrides` blocks and relies on `npm audit fix`
(non-breaking) plus direct-dependency bumps only, unless a vulnerability is **critical**.

### Changes

- Removed `overrides` from `package.json` in: `<folder-1>`, `<folder-2>`, ...
- Direct dependency bumps kept: `<package>@<old>` → `<new>` in `<folder>`
- Ran `npm install` + `npm audit fix` in each folder to regenerate `package-lock.json` and pick up
  non-breaking transitive updates.

### Vulnerability status after fix

| Folder     | Before                | After                 |
| ---------- | --------------------- | --------------------- |
| `<folder>` | `<n>` (`<breakdown>`) | `<n>` (`<breakdown>`) |

Remaining findings (none critical unless noted):

- `<package>` (`<advisory-id/link>`) — only fixable via a semver-major bump of `<dependency>`;
  left as-is.

### Testing

- `<folder>`: `<test command>` — `<result>`

### Follow-up (not in this PR)

- Track `<package>` for a future major upgrade of `<dependency>` once ready to absorb breaking
  changes.
