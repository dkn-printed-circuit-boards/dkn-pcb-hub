# REPOS — registry (hub-authored)

GitHub org: `dkn-printed-circuit-boards`. All repos are public.

| Repo | Owns | Provides (seam) | Consumes | State |
|---|---|---|---|---|
| `dkn-pcb-hub` | Conventions, registry, portable helpers | `tools/` scripts, CONVENTIONS.md | — | on GitHub (public) 2026-11-14 |
| `dkn-pcb-parts-db` | Canonical parts records: MPN, mfr, footprint and symbol, distributor data, datasheet URLs | TBD: KiCad library and/or DB export, plus a CLI. Schema doc is required | Distributor APIs (Digi-Key, Mouser) | empty git init; remote exists |

Add a row the same turn a repo is born. When a seam changes, update the Consumes column of every affected row.
