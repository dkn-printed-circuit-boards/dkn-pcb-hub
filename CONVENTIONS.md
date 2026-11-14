# CONVENTIONS — how dkn-printed-circuit-boards repos are built

Hub-authored. Child repos read this file. Propose changes through BULLETIN.md or the hub session.

## 1. Portability (the main rule)
A stranger clones one repo onto Linux, macOS, or Windows, follows its README, and it works.

**Paths**
- Never commit an absolute path: `/Users/…`, `/home/…`, `C:\…`, `~/Desktop/…`, or `/opt/homebrew/…`. <!-- portable-ok -->
- Code resolves paths relative to the repo root (`Path(__file__).resolve().parents[n]`, or
  `git rev-parse --show-toplevel`), or from an env var with a documented default.
- Per-user data goes in platform dirs via `platformdirs`, never in a fixed path:
  cache under `user_cache_dir("<tool>")`, config under `user_config_dir`.
- KiCad: library tables use `${KIPRJMOD}`, or a documented path variable such as
  `${DKN_PCB_LIB}`. Never an absolute path. See §4.

**Tools**
- Find external tools at runtime. Check the env var override first (`KICAD_CLI`), then
  `PATH`, then known install locations. If none is found, fail with an install hint.
  `tools/kicad-cli.sh` is the reference pattern.
- Python: `pyproject.toml` with uv. The README uses `uv sync` and `uv run …`. No shared
  venvs, no bare `pip`, and no `#!/usr/bin/python3` shebangs. Pin `requires-python`. Commit `uv.lock`.
- Shell scripts: POSIX `sh` or bash with `#!/usr/bin/env bash`. No macOS-only flags
  (`sed -i ''`, BSD `date`). Use Python when the logic is non-trivial.
- Pin tool versions in README and CI. KiCad's major version matters because file formats
  change. Current baseline: **KiCad 10.x**.

**Config and secrets**
- Secrets come only from env vars. A gitignored `.env` is fine. Commit `.env.example`
  with empty values. Optional keys degrade gracefully with a clear error, never a crash.
- Keyless-first: a distributor API key should never be the only path to a working build.

**Checks**
- `tools/check_portable.sh <repo>` greps for absolute paths, emails, and key-shaped strings.
  CI runs the same check on a clean Ubuntu runner, and that run is the real test.

## 2. Repo layout (default; deviate only with a reason)
```
README.md   CLAUDE.md   STATUS.md   LOG.md   LICENSE
.env.example   .gitignore   COLD_STORAGE.md   (only if anything lives there)
pyproject.toml uv.lock   src/<pkg>/   tests/          # code repos
hardware/<board>/  (KiCad project)   fab/ (gitignored) # board repos
.github/workflows/ci.yml
```
- Naming: repos `dkn_pcb_<thing>`. Python packages `dkn_pcb_<thing>`, which avoids stdlib collisions.
- License: pick one per repo before first push. Default to MIT for code and CERN-OHL-P/S for hardware.

## 3. Where files go
| Kind | Where |
|---|---|
| Source, schematics, PCB layouts, libraries, small data (<1 MB), docs | git |
| Fab outputs (gerbers, drill, pos, BOM exports), renders | **regenerated** by script or CI and attached to GitHub Releases. Not committed. |
| Datasheets (PDF) | Not in git (copyright and size). Store the URL in the parts DB. A local cache goes in the user cache dir. |
| Large or raw media (board photos, scope captures, raw API dumps) | Cold storage; the path is in `local/LOCATIONS.md`. The repo's `COLD_STORAGE.md` lists what's there and how to rebuild it. |
| Secrets, API tokens | Env or `.env`. Never git, never cold storage. |
| Machine-specific paths | `local/` in the hub, or env vars. |

## 4. KiCad
- One KiCad project per board under `hardware/<board>/`. Commit `.kicad_pro`, `.kicad_sch`,
  `.kicad_pcb`, the project `sym-lib-table` and `fp-lib-table`, and `.kicad_dru`. Ignore
  `*-backups/`, `fp-info-cache`, `*.kicad_prl`, `~*.lck`, and `#auto_saved_files#`.
- Libraries: project-local (`${KIPRJMOD}/lib/…`) for anything board-specific. Shared
  parts come from the **parts DB repo**, which it publishes as a KiCad library. Consumers vendor a
  pinned copy or a git submodule at a tag, never a sibling path.
- Every placed part carries an MPN (and ideally a parts-DB ID). That turns the BOM into a join.
- Outputs come from `kicad-cli` (`sch export`, `pcb export gerbers/drill/pos`, `jobset`)
  driven by one script, the same locally and in CI (KiCad's official container image).
- ERC and DRC must run clean in CI before a release tag.

## 5. Cross-repo seams
- Repos exchange **files with a documented schema** (CSV, JSON, SQLite, or a KiCad lib)
  or call a **CLI**. They never `import` each other's Python.
- The producer owns the schema and documents it in-repo. It versions breaking changes
  (`schema_version` field) and lists consumers in REPOS.md.
- Credentials stay with the producer. Consumers call the producer's CLI or read its
  published artifact. They don't copy the key.

## 6. Git
- Default branch `main`. Commit per meaningful change. Push on David's call.
- No `--no-verify`. If a check blocks a file the repo truly needs, fix the check or allowlist the file.
- Releases are tagged (`v0.1.0`, or `<board>-revA`). Fab packages attach to the release.
