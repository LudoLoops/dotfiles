#!/bin/sh
# Cycle layouts: tile → vertical_tile → scroller → tile
# + toggle floating with togglefloating on focused window
# Mango 0.14+ mmsg syntax

SOCK="${MANGO_INSTANCE_SIGNATURE:-$(ls /run/user/1000/mango-*.sock 2>/dev/null)}"
if [ -z "$SOCK" ]; then
    exit 1
fi

export MANGO_INSTANCE_SIGNATURE="$SOCK"

# Get layout of active tag
current=$(mmsg get all-tags 2>/dev/null | grep -o '"is_active":true[^}]*"layout":"[A-Z]"' | grep -o '"layout":"[A-Z]"' | tail -1 | grep -o '[A-Z]')

case "$current" in
    T) next="vertical_tile" ;;
    V) next="scroller" ;;
    *) next="tile" ;;
esac

mmsg dispatch setlayout,"$next"
