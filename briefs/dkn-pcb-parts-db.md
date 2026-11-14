# Brief: dkn-pcb-parts-db (hub advice; design PARKED 2026-11-14)

This is advice, not a spec. The parts-DB session owns its design and records its decisions in its
own repo. Parts-db is the most important repo: the source of truth about each part, the check on
the CAD files, and the basis for analysis and design.

## Decided (David, 2026-11-14)
- Distributor clients are separate repos: `dkn-pcb-digikey`, `dkn-pcb-mouser`, later `dkn-pcb-octopart`.
  Each one is a CLI that outputs one shared offer format, and the hub owns that format.
- A separate lifecycle (obsolescence) repo reads the parts-db part list plus the distributor CLIs
  and notices fed in by hand. It owns lifecycle status; parts-db displays it but never writes it.
- Datasheets and other docs go to cold storage `dkn-pcb-parts-db/…`, never git. Git holds the manifest.
- Don't build a database engine: use a free existing one.

## Leaning (hub pick, not ruled yet)
- **Engine:** SQLite as the source of truth (stdlib, one file, JSON columns, full-text search) plus a
  sorted text dump committed so changes show as git diffs. CI rebuilds the DB from the dump.
  Upgrade path: Dolt (git-style diff and branch per row). Load the 3 test parts into both before
  locking. Postgres and MongoDB are out: they need a server, and documents are weak at the joins we need.
- **Part = dossier:** a docs manifest, facts, and knowledge (simulations, reviews, selection reasons,
  lessons), so board 2 reuses board 1's work.
- **Facts are only ever added.** Each one has its subject, key, value, unit, conditions, source doc
  and page, method, trust level, and status (active, superseded or disputed).
  Trust, weakest to strongest: extracted < cross-checked < simulated < human-reviewed < proven-on-hardware.
  A query can demand a minimum trust (`--min-trust`) and fails loudly if it isn't met.
- **Tables, about 8:** document (keyed by hash, with type, rev, supersedes, credibility), doc_set,
  family, part (params JSON), document_link (role), fact, lesson (severity, credibility), conflict
  (competing facts, winner, reported upstream), ref_design and ref_bom (eval boards). Plus a pin
  table, CAD checks, and a read-only lifecycle table.
- **Families:** one datasheet serves thousands of MPNs. Family facts are inherited and can be
  overridden per MPN. Passives are never agent-extracted per part.
- **Extraction depth:** a required core per part category (for example, a resistor needs value,
  tolerance, power, voltage, TCR, package and AEC grade). Everything beyond that is extracted when
  someone asks. A cheap sweep stores cited notes, not facts.
  Extraction runs twice independently (two Sonnet agents), and a script compares the results.
  A datasheet is extracted once per file hash.
- **Intake:** a fast path (CLI query, instant: the facts plus their trust, or "queued, job #").
  Parametric searches go to the distributor CLIs, not agents. Writes go through an inbox (one file
  per request, cold storage for now) with **one curator**: only the parts-db session writes,
  duplicate requests merge, and work blocking a design goes first. A claim without proof becomes
  `disputed`; a claim with proof updates the fact and notifies every board that uses the part.
- **Downtime:** a nightly headless `claude -p` run started by launchd, with a budget cap. In order:
  cross-check fresh extractions, clear the inbox, check datasheet revisions by hash, spot-check a
  sample, write a morning report. It can never mark anything human-reviewed. Test first whether a
  launchd job can reach the Drive folder; that same test settles automatic backups.

## Open
- The three test parts: a resistor family, a regulator, and an MCU with an eval board David knows well.
- Who generates symbols and footprints: parts-db, using the kicad repo's writer pinned to a tag
  (lean), or the kicad repo alone.
- Re-check frequency and the token budget.
- Whether the existing Digi-Key and Mouser clients move into the org (PARKED in hub STATUS).

## Standing
- Schema documented in-repo with a `schema_version` field. List consumers in hub REPOS.md.
- KiCad: boards pin a tagged library release through `${DKN_PCB_LIB}` or `${KIPRJMOD}`.
- Distributor data is a refreshable cache, not truth. The keyless path must still build.
- Before the first push: MIT LICENSE, `../tools/check_portable.sh .`, then `../tools/sync.sh .`.
