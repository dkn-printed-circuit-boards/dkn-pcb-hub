#!/usr/bin/env bash
# Sync a repo with GitHub: fetch, report new branches, rebase-pull, check, push.
# Usage: tools/sync.sh [repo_dir]   (default: current dir). Never force-pushes.
set -euo pipefail
hub="$(cd "$(dirname "$0")/.." && pwd)"
dir="$(cd "${1:-.}" && pwd)"; cd "$dir"
br="$(git symbolic-ref --short HEAD)"
git fetch --prune origin
# remote branches with no local branch of the same name
# (grep -v exits 1 on empty input, e.g. a brand-new remote; `|| true` keeps pipefail + set -e from killing the script)
new=$(git for-each-ref --format='%(refname:short)' refs/remotes/origin | sed 's|^origin/||' | { grep -v -E '^(HEAD|origin)$' || true; } \
      | while read -r b; do git show-ref --verify --quiet "refs/heads/$b" || echo "$b"; done)
[ -n "$new" ] && { echo "== remote branches not checked out here (review them):"; echo "$new"; }
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "uncommitted changes: commit or stash first" >&2; exit 1
fi
if git show-ref --verify --quiet "refs/remotes/origin/$br"; then
  git pull --rebase --quiet origin "$br" || { echo "rebase conflict: resolve, or 'git rebase --abort'; then ask" >&2; exit 1; }
fi
"$hub/tools/check_portable.sh" . || { echo "portable check failed: not pushing" >&2; exit 1; }
ahead=$(git rev-list --count "origin/$br..HEAD" 2>/dev/null || git rev-list --count HEAD)
[ "$ahead" = "0" ] && { echo "up to date ($br)"; exit 0; }
git push -u origin "$br"
echo "pushed $ahead commit(s) on $br"
