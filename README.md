# agent-config

Shared Copilot CLI / Claude / agent skills and instructions.

## Contents
- `agents/skills/` – skills (real files; Copilot and Claude link to them)
- `agents/.skill-lock.json` – skill sources (installed as `~/.agents/.skill-lock.json.shared`, never overwrites yours)
- `agents/instructions/`, `copilot/`, `claude/` – global instructions (opt-in)
- `copilot/settings.json` – UI settings (opt-in)
- `copilot/caveman`, `copilot/hooks` – caveman session hook (opt-in, needs Node)

No credentials, history, sessions or logins are included.

## Install
```bash
git clone <repo-url> ~/agent-config && cd ~/agent-config
./install.sh                      # skills only (safe)
./install.sh --with-instructions  # + global instructions (backs up your files)
./install.sh --with-settings      # + Copilot settings.json
./install.sh --with-hooks         # + caveman hook
```
Existing files are moved to `*.bak.<timestamp>`. Restart the CLI; verify with `/skills` and `/env`.

## Merge with existing setup
- Skills: the script adds missing skills and overwrites same-named ones. Your other skills stay.
- Instructions: if you have your own `~/.copilot/copilot-instructions.md`, skip `--with-instructions` and merge by hand from the backup.
- `global-governance.md` is the author's personal git/PR rules. Review before adopting.
