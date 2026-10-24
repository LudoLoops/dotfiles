#!/bin/sh
# HyprCrop -> optional Satty -> clipboard. Never retain temporary PNG.
set -eu
mode="${1:-}"
case "$mode" in
  select) command=freeze; annotate=yes ;;
  window) command=window; annotate=yes ;;
  full) command=monitor; annotate=yes ;;
  window-clipboard) command=window; annotate=no ;;
  *) printf "Unsupported screenshot mode: %s
" "$mode" >&2; exit 2 ;;
esac
capture=$(/home/loops/.local/bin/hyprcrop-faster-freeze --config /home/loops/.config/hyprcrop/clipboard.toml "$command") || exit $?
case "$capture" in
  /dev/shm/hyprcrop/*.png) ;;
  *) printf "Unexpected capture path: %s
" "$capture" >&2; exit 1 ;;
esac
trap 'rm -f -- "$capture"' EXIT
if [ "$annotate" = yes ]; then
  satty --filename "$capture" --resize smart --floating-hack --copy-command wl-copy --actions-on-enter save-to-clipboard --early-exit all
fi
