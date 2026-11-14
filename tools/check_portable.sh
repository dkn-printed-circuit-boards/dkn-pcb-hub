#!/usr/bin/env bash
# Flag non-portable or private content in tracked/staged files.
# Usage: tools/check_portable.sh [repo_dir]   (exit 1 on findings)
set -uo pipefail
dir="${1:-.}"
cd "$dir" || exit 2
files=$(git ls-files -co --exclude-standard 2>/dev/null) || { echo "not a git repo: $dir" >&2; exit 2; }
[ -z "$files" ] && { echo "OK (no files)"; exit 0; }
pat_paths='(/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+|[A-Za-z]:\\\\Users\\\\|~/Desktop|/opt/homebrew|GoogleDrive-|CloudStorage/)'
pat_email='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
pat_keys='(AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|(api[_-]?key|secret|token|password)[[:space:]]*[:=][[:space:]]*["'\'']?[A-Za-z0-9/+_-]{16,})'
rc=0
check() { # label pattern
  out=$(echo "$files" | grep -v -E '^tools/check_portable\.sh$' | tr '\n' '\0' | xargs -0 grep -I -n -E -i "$2" -- 2>/dev/null \
        | grep -v -E 'git@github\.com|noreply@|example\.(com|org)|@users\.noreply\.github\.com' || true)
  # allowlist: lines containing "portable-ok"
  out=$(echo "$out" | grep -v 'portable-ok' || true)
  if [ -n "$out" ]; then echo "== $1"; echo "$out"; rc=1; fi
}
check "absolute/personal paths" "$pat_paths"
check "email addresses"        "$pat_email"
check "secret-shaped strings"  "$pat_keys"
big=$(echo "$files" | while read -r f; do [ -f "$f" ] && [ "$(wc -c <"$f")" -gt 1048576 ] && echo "$f"; done)
[ -n "$big" ] && { echo "== files > 1 MB (use releases / cold storage)"; echo "$big"; rc=1; }
[ $rc -eq 0 ] && echo "OK"
exit $rc
