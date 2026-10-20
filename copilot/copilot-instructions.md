# Global Copilot Instructions

Applies to all repositories. Governance rules (git, conductor, PRs) live in `~/.copilot/instructions/global-governance.md`; a repo's root `CLAUDE.md` is authoritative for its architecture and commands.

## Pulumi tenant monorepos (e.g. dp.infra.tenant-services)

- Run unit tests only in `templates/pulumi`: `npx jest <file>` for one file, `npx jest -t "<name>"` for one test.
- Each project has its own `package.json`; install per project with `npm run check:npm && npm ci` (`.npmrc` sets `ignore-scripts=true`, npm >= 11.10).
- Tenant `azure-pipelines.yaml` triggers list specific `templates/pulumi/*.ts` files. When a tenant starts using a new shared template, add it to that pipeline's `paths.include`.
- Don't pin transitive dependencies with `package.json` `overrides`; use `npm audit fix`.
