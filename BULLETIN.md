# BULLETIN — cross-repo findings (any session may append)

Format: `B-YYMMDD-n | <repo> | FINDING|MISTAKE|ASK | one line`. Append only. The hub curates
anything durable into CONVENTIONS.md and marks the entry `→ curated`.

B-261114-1 | hub | FINDING | KiCad 10 `kicad-cli` is not on PATH on macOS installs. Resolve it with `tools/kicad-cli.sh` (or `$KICAD_CLI`), never a hard-coded app path.
B-261114-2 | hub | FINDING | On KiCad 10.0.7 macOS, `kicad-cli version` is killed (rc 137). Use `kicad-cli --version`.
B-261114-3 | hub | FINDING | HTTPS push fails on this machine (no credential helper). Use SSH remotes: git@github.com:dkn-printed-circuit-boards/<repo>.git
B-261114-4 | hub | FINDING | Repos renamed to hyphens (dkn-pcb-hub, dkn-pcb-parts-db). Python packages stay dkn_pcb_<thing>. GitHub redirects old URLs, but update your remotes.
B-261114-5 | hub | FINDING | LTspice 26 on macOS: `LTspice.app/Contents/MacOS/LTspice -b` exits 0 and writes nothing. Run it headless with `tools/ltspice-batch.sh <netlist>`, which calls the bundled Wine. The `.log` is UTF-8. The `.raw` header is UTF-16LE. In the binary data the first variable is float64 and the rest are float32.
B-261114-6 | hub | FINDING | ngspice 47 (brew) works headless with `ngspice -b file.cir`. It's the portable baseline. LTspice is optional and local (closed, Mac/Windows only), for its solver and its encrypted vendor models.
B-261114-7 | hub | FINDING | The status line input includes context_window.used_percentage and context_window_size (1M on Opus here). tools/statusline-context.py shows it and nudges /clear at 20%.
B-261114-8 | hub | FINDING | Moving a repo folder breaks two things outside it: any absolute path in `~/.claude/settings.json` (e.g. the status line), and Claude memory, which lives under `~/.claude/projects/<path-with-dashes>/memory/`. Copy the old memory dir to the new key after a move.
