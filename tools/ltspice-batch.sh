#!/usr/bin/env bash
# Run an LTspice netlist headless. Usage: tools/ltspice-batch.sh <file.net|file.cir>
# Writes <file>.log (UTF-8 text) and <file>.raw next to the netlist. Exit 1 if no .raw appears.
# Order: $LTSPICE (path to LTspice.exe or the macOS app) -> known install locations.
# macOS note: the app's own launcher ignores -b. LTspice 26 runs its Windows engine under a
# bundled Wine, so we call that Wine directly with a Z:\ path. Open the app once by hand first.
set -euo pipefail
net="${1:?usage: ltspice-batch.sh <netlist>}"
net="$(cd "$(dirname "$net")" && pwd)/$(basename "$net")"
base="${net%.*}"; rm -f "$base.raw" "$base.log"
case "$(uname -s)" in
  Darwin)
    app="${LTSPICE:-/Applications/LTspice.app}"
    wine="$app/Contents/SharedSupport/ltspice/LTspice/wine"
    export WINEPREFIX="${LTSPICE_WINEPREFIX:-$HOME/Library/Application Support/LTspice/Bottles/ltspice}"
    exe='C:\Program Files\ADI\LTspice\LTspice.exe'
    [ -x "$wine" ] && [ -d "$WINEPREFIX" ] || {
      echo "LTspice not found or never launched. Install it from analog.com, open it once, or set LTSPICE." >&2; exit 127; }
    WINEDEBUG=-all "$wine" "$exe" -b "Z:${net//\//\\}" >/dev/null 2>&1 || true ;;
  MINGW*|MSYS*|CYGWIN*)
    exe="${LTSPICE:-/c/Program Files/ADI/LTspice/LTspice.exe}"
    [ -x "$exe" ] || { echo "LTspice not found. Install it from analog.com or set LTSPICE." >&2; exit 127; }
    "$exe" -b "$(cygpath -w "$net")" ;;
  *) echo "LTspice batch is wired for macOS and Windows only. Use ngspice." >&2; exit 127 ;;
esac
[ -f "$base.raw" ] || { echo "no $base.raw produced (see $base.log if present)" >&2; exit 1; }
echo "$base.raw"
