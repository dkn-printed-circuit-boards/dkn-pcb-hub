#!/usr/bin/env bash
# Daily git-bundle backup of the hub and every child repo into cold storage.
# Usage: tools/backup_cold.sh [--force]   Needs $PCB_COLD_STORAGE (see local/env.example).
# Writes $PCB_COLD_STORAGE/_backups/<YYYY-MM-DD>/<repo>.bundle and keeps the last 14 days.
# Bundles hold committed history only: commit before you rely on it. No secrets: local/ is not copied.
set -euo pipefail
hub="$(cd "$(dirname "$0")/.." && pwd)"
[ -n "${PCB_COLD_STORAGE:-}" ] || { echo "PCB_COLD_STORAGE not set (source local/env)" >&2; exit 2; }
[ -d "$PCB_COLD_STORAGE" ] || { echo "cold storage not reachable: $PCB_COLD_STORAGE" >&2; exit 2; }
root="$PCB_COLD_STORAGE/_backups"
day="$(date +%Y-%m-%d)"
dest="$root/$day"
if [ -d "$dest" ] && [ "${1:-}" != "--force" ]; then echo "backup already done today: $dest"; exit 0; fi
mkdir -p "$dest"
for repo in "$hub" "$hub"/dkn_pcb_*/; do
  repo="${repo%/}"
  git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || continue
  name="$(basename "$repo")"; [ "$repo" = "$hub" ] && name="dkn_pcb_hub"
  if git -C "$repo" rev-parse HEAD >/dev/null 2>&1; then
    git -C "$repo" bundle create "$dest/$name.bundle" --all 2>/dev/null
    git -C "$repo" bundle verify "$dest/$name.bundle" >/dev/null 2>&1 && echo "ok   $name" || echo "FAIL $name"
  else
    echo "skip $name (no commits)"
  fi
done
# prune: only dated dirs directly under _backups, older than 14 days
find "$root" -mindepth 1 -maxdepth 1 -type d -name '20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]' -mtime +14 -exec rm -rf {} +
echo "done: $dest"
