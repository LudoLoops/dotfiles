#!/bin/sh
set -eu
capture=$(/home/loops/.local/bin/hyprcrop-faster-freeze --config /home/loops/.config/hyprcrop/clipboard.toml freeze) || exit $?
[ -n "$capture" ] || exit 1
case "$capture" in
    /dev/shm/hyprcrop/*.png) rm -- "$capture" ;;
    *) printf "Unexpected output path: %s
" "$capture" >&2; exit 1 ;;
esac
