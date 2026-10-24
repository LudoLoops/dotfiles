#!/bin/sh
# Freeze selection -> Satty annotations -> clipboard only.
set -eu
capture=$(/home/loops/.local/bin/hyprcrop-faster-freeze --config /home/loops/.config/hyprcrop/clipboard.toml freeze) || exit $?
case "$capture" in
    /dev/shm/hyprcrop/*.png) ;;
    *) printf "Unexpected HyprCrop output path: %s
" "$capture" >&2; exit 1 ;;
esac
trap 'rm -f -- "$capture"' EXIT
satty --filename "$capture" --resize smart --floating-hack --copy-command wl-copy --actions-on-enter save-to-clipboard --early-exit all
