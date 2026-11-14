# Brief: dkn_pcb_parts_db (hub advice, 2026-11-14)

This is advice, not a spec. The parts-DB session owns its design and records its decisions in its own repo.

- **Source of truth is text in git.** One TOML or CSV record per part, keyed by an internal ID
  plus the MPN, so a stranger can review a change in a PR.
- **Build artifacts:** SQLite plus a KiCad symbol and footprint library plus a BOM-join CSV,
  attached to tagged GitHub Releases. The generated DB is not committed.
- **KiCad consumption:** board repos pin a tagged release (as a submodule or vendored copy) through
  `${DKN_PCB_LIB}` or `${KIPRJMOD}`. KiCad database libraries (ODBC) stay optional, because strangers won't have them set up.
- **Distributor data (Digi-Key, Mouser) is a refreshable cache, not truth.** The keyless path
  must still build the library. Keys come only from env vars. Where the clients live is PARKED (see hub STATUS).
- **Datasheets:** store the URL in the DB; PDFs go to cold storage `dkn_pcb_parts_db/datasheets/` (CONVENTIONS §4 table), never git.
- **Schema:** documented in-repo with a `schema_version` field. Add the repo's consumers to hub REPOS.md as they appear.
- Before the first push: set the remote to SSH, add the MIT LICENSE, and run `../tools/check_portable.sh .`.
