# Review Checklist

> **Strict Scope Rule:** Only evaluate and suggest changes for files/lines modified in the diff. Untouched files serve only as read-only references for style and consistency.
> **Testing Policy:** Review test coverage statically from diffs. Do NOT execute test suites or runners during review; defer execution to CI.

## Correctness
- Logic matches stated intent; handles empty/null/boundary values
- Error handling covers realistic failure modes without silent swallows
- No off-by-one errors, race conditions, or unclosed resource handles

## Security (OWASP-aligned)
- No injection risk (SQL/command/template) or unvalidated input at trust boundaries
- Zero committed or logged secrets, credentials, or sensitive tokens
- Proper AuthN/AuthZ checks on new endpoints or actions
- Added dependencies are from trusted sources with pinned versions

## Maintainability & Style
- Clean, self-documenting naming; no dead code, debug logs, or leftover commented blocks
- Follows repo instructions (`CLAUDE.md`, style guides) and Prettier/linter rules
- Comments explain *why*, not *what*

## Performance
- No N+1 queries, unbounded loops, or redundant expensive operations
- Appropriate data structures for expected scale

## Tests (Static Diff Inspection)
- New behavior and bug fixes include corresponding unit tests in diff
- Assertions verify behavior and edge cases, not internal implementation trivia
- Tests are deferred to CI checklist for execution

## Architecture & Tenant Safety
- **Staged Migration for Breaking Tenant Changes:** If tenant-facing APIs or services change, enforce: (1) create new service, (2) verify tenant integration, (3) decommission old service.
- **Structural Consistency:** Component and file layout matches sibling modules without reinventing patterns or duplicating shared utilities.
