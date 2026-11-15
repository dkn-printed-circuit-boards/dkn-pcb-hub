# STATUS — hub (2026-11-14)

The hub is on GitHub: `dkn-printed-circuit-boards/dkn-pcb-hub` (public). It holds CLAUDE.md,
CONVENTIONS.md, REPOS.md, BULLETIN.md, and tools/. local/ is gitignored, machine-only.

Cold storage reachable (verified 2026-11-14). Daily git-bundle backups: `tools/backup_cold.sh`, run at hub session start; first run OK.
GitHub: fine-grained org-only token in `local/env`. CLAUDE.md now carries David's 7 session rules and session-start steps.
Hub folder moved on this machine (2026-11-14). Status line, `local/LOCATIONS.md`, and Claude memory now point at the new spot. Checked: status line, check_portable, gh.

Push policy: commit often and push via `tools/sync.sh` (no ask). Rewrites, branch deletes, repo creation, and visibility stay David's.

**Hub role (David, 2026-11-14):** keep the GitHub org healthy, help child sessions along, be the place to find things. Go slow; build from reps.

**Next:** PARKED for the night (David, 2026-11-14). Resume with the parts-db design:
`briefs/dkn-pcb-parts-db.md` records what's decided, what's leaning, and what's open. First ask: David picks
3 test parts (a resistor family, a regulator, and an MCU with an eval board). Then do the SQLite-vs-Dolt bake-off.
Also open: write the repo plan into REPOS.md (hub, parts-db, kicad (parse plus write), analysis,
spice, lifecycle, digikey, mouser, octopart later, one repo per board from a template). Pick the first-slice board.

PARKED (David, 2026-11-14: wait): whether the Digi-Key and Mouser clients move into this org or stay in claude_stuff.
