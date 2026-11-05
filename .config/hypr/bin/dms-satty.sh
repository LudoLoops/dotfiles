#!/bin/sh
# DMS -> verified temporary PNG -> Satty. No saved screenshots.
set -eu

mode="${1:-}"
case "$mode" in
  window|full) ;;
  *) printf 'Unsupported DMS screenshot mode: %s\n' "$mode" >&2; exit 2 ;;
esac

capture=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/dms-satty-XXXXXXXX.png") || exit 1
trap 'rm -f -- "$capture"' EXIT HUP INT TERM

# A real file makes capture failures visible instead of piping empty data into Satty.
if ! dms screenshot "$mode" --stdout --no-file --no-clipboard --no-notify > "$capture"; then
  notify-send "Screenshot DMS" "Capture impossible : consulte les erreurs DMS" 2>/dev/null || true
  exit 1
fi
if [ ! -s "$capture" ]; then
  notify-send "Screenshot DMS" "Aucune image produite par DMS" 2>/dev/null || true
  exit 1
fi

satty --filename "$capture" --resize smart --floating-hack \
  --copy-command wl-copy --actions-on-enter save-to-clipboard --early-exit all
