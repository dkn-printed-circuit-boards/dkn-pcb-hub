# REPOS — registry (hub-authored)

GitHub org: `dkn-printed-circuit-boards`. All repos are public.

| Repo | Owns | Provides (seam) | Consumes | State |
|---|---|---|---|---|
| `dkn-pcb-hub` | Conventions, registry, portable helpers | `tools/` scripts, CONVENTIONS.md | — | on GitHub (public) 2026-11-14 |
| `dkn-pcb-parts-db` | Part knowledge only (David, 2026-11-17): parts and families, the document list (PDFs in cold storage by sha256), facts with citations and trust, conflicts, gaps, lessons, and a cache of every part question other sessions ask it. Not: prices or stock, lifecycle status, CAD symbols or footprints, simulation runs, board decisions | `parts-db` CLI (uv). YAML in `data/` per its SCHEMA.md (schema_version 0, draft). Other sessions ask; only parts-db writes `data/` | Vendor documents (datasheets, user guides, app notes, forum posts). Distributor part numbers only | on GitHub (public), CI green on 3 OSes 2026-11-17. 1 part checked in. Answer cache: ordered (O-261117-1) |

Add a row the same turn a repo is born. When a seam changes, update the Consumes column of every affected row.
