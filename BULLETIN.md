# BULLETIN — cross-repo findings (any session may append)

Format: `B-YYMMDD-n | <repo> | FINDING|MISTAKE|ASK | one line`. Append only. The hub curates
anything durable into CONVENTIONS.md and marks the entry `→ curated`.

B-261114-1 | hub | FINDING | KiCad 10 `kicad-cli` is not on PATH on macOS installs. Resolve it with `tools/kicad-cli.sh` (or `$KICAD_CLI`), never a hard-coded app path.
B-261114-2 | hub | FINDING | On KiCad 10.0.7 macOS, `kicad-cli version` is killed (rc 137). Use `kicad-cli --version`.
