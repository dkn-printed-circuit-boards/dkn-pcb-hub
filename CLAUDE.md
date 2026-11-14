# dkn_pcb_hub — hub for the dkn-printed-circuit-boards repos

This folder is the **hub repo** (`dkn_pcb_hub`). The child repos (`dkn_pcb_*`) are cloned
inside it and gitignored by it. Every Claude session started inside a child repo also
loads this file. If you are a child session, the rules here apply to you on top of your
own CLAUDE.md, and your own CLAUDE.md wins on conflicts inside your repo.

A session rooted at this folder is the **hub**. It handles logistics: repo registry, conventions,
cross-repo seams, out-of-repo locations, and design advice. Its default is to route work and give advice,
not to edit child repos. It edits a child repo only when David asks.

## Orient
- [`REPOS.md`](REPOS.md): what repos exist, what each owns, how they connect.
- [`CONVENTIONS.md`](CONVENTIONS.md): **read before building anything**. Covers portability,
  layout, secrets, KiCad rules, and data seams.
- [`STATUS.md`](STATUS.md): where the hub stands, and the open `NEEDS DAVID` asks.
- [`BULLETIN.md`](BULLETIN.md): cross-repo findings and mistakes. Any session may append.
- `local/` (gitignored, **this machine only**): `LOCATIONS.md` says where things live
  that are not in a repo (tools, cold storage, creds). `env` holds secrets and overrides.
  Never copy anything from `local/` into a tracked file.

## Working with David
- Verdict first, then data. Be terse. Offer at most 3 options and state your pick.
- When he decides, execute. Don't re-raise a settled point.
- Ask when blocked. Add `NEEDS DAVID (INSTALL | TIME | RULING): <what> — <what it buys>`
  to STATUS. Asking is cheap. A silent workaround is not.
- Token budget is real: one session per task, cheap models for mechanical work, 1–2 agents.

## Hard rules (every session)
1. **Public repos.** Every repo in the org is public, and strangers clone them. Commit no
   secrets, PII, personal paths, usernames, or emails. Read a file before committing it.
2. **Portable or it isn't done.** A clean clone on another machine and OS must work by
   following its README. CONVENTIONS.md §1 lists what that means. Run
   `tools/check_portable.sh <repo>` before you commit.
3. **No cross-repo imports.** Repos talk through CLIs and files with a documented schema
   (CONVENTIONS.md §5). Pin a dependency on another repo to a tag or commit, never a sibling path.
4. **Pushes are David's call.** Commit locally whenever you like. Push, create repos, or
   change visibility only when he says so.
5. **Failures are the lesson.** Fix it, write the lesson in your own CLAUDE.md, and post a
   `MISTAKE` line to BULLETIN.md. Show evidence (the command and its output) instead of claiming success.
6. **Continuity lives on disk.** Each repo keeps `STATUS.md` (≤40 lines, rewritten at each
   checkpoint) and `LOG.md` (finished work). CLAUDE.md holds standing rules only.

## Compact instructions
Keep: the current task and its next step, decisions with their reasons, files changed, open
`NEEDS DAVID` asks, and anything not yet written to STATUS. Drop tool output that has already been acted on.

@STATUS.md
