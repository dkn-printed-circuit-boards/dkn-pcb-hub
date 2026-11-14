#!/usr/bin/env bash
# Portable kicad-cli resolver. Usage: tools/kicad-cli.sh <kicad-cli args...>
# Order: $KICAD_CLI -> PATH -> known install locations. Fails with an install hint.
set -euo pipefail
find_cli() {
  if [ -n "${KICAD_CLI:-}" ] && [ -x "$KICAD_CLI" ]; then echo "$KICAD_CLI"; return; fi
  if command -v kicad-cli >/dev/null 2>&1; then command -v kicad-cli; return; fi
  for c in \
    "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli" \
    "$HOME/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli" \
    "/usr/bin/kicad-cli" "/usr/local/bin/kicad-cli" \
    "/c/Program Files/KiCad/10.0/bin/kicad-cli.exe" \
    "/c/Program Files/KiCad/9.0/bin/kicad-cli.exe"; do
    [ -x "$c" ] && { echo "$c"; return; }
  done
  echo "kicad-cli not found. Install KiCad 10 (https://www.kicad.org/download/) or set KICAD_CLI." >&2
  exit 127
}
CLI="$(find_cli)"
[ "${1:-}" = "--which" ] && { echo "$CLI"; exit 0; }
exec "$CLI" "$@"
