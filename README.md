# dkn_pcb_hub

Conventions, registry, and portable helpers for the
[dkn-printed-circuit-boards](https://github.com/dkn-printed-circuit-boards) repos.

## Workspace setup
```bash
git clone https://github.com/dkn-printed-circuit-boards/dkn_pcb_hub.git dkn-printed-circuit-boards
cd dkn-printed-circuit-boards
# clone child repos inside (the hub gitignores them)
gh repo list dkn-printed-circuit-boards --json name -q '.[].name' \
  | grep -v '^dkn_pcb_hub$' | xargs -I{} gh repo clone dkn-printed-circuit-boards/{}
cp .env.example local/env   # fill in only what you need; everything is optional
```

## Requirements
- [KiCad 10.x](https://www.kicad.org/download/). `tools/kicad-cli.sh` finds it, or set `KICAD_CLI`.
- [uv](https://docs.astral.sh/uv/) for Python repos (`uv sync`, `uv run …`).
- git, bash.

## What's here
| File | Purpose |
|---|---|
| `CONVENTIONS.md` | Portability, layout, KiCad, and cross-repo seam rules |
| `REPOS.md` | What each repo owns and provides |
| `tools/kicad-cli.sh` | Portable `kicad-cli` resolver |
| `tools/check_portable.sh` | Flags absolute paths, emails, secrets, and files over 1 MB in a repo |
| `CLAUDE.md`, `STATUS.md`, `BULLETIN.md` | Working notes for AI-assisted sessions |
