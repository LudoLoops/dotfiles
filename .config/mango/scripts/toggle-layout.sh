#!/bin/sh
# Cycle layouts: scroller → tile → vertical_tile → monocle → scroller
# Mango 0.14+ mmsg syntax

SOCK="${MANGO_INSTANCE_SIGNATURE:-$(ls /run/user/1000/mango-*.sock 2>/dev/null)}"
if [ -z "$SOCK" ]; then
    exit 1
fi

export MANGO_INSTANCE_SIGNATURE="$SOCK"

# Get layout of active tag - extract the letter after "layout":
current=$(mmsg get all-tags 2>/dev/null | grep -o '"is_active":true[^}]*"layout":"[A-Z]"' | grep -o '"layout":"[A-Z]"' | tail -1 | grep -o '[A-Z]')

case "$current" in
    S) next="tile" ;;
    T) next="vertical_tile" ;;
    V) next="monocle" ;;
    *) next="scroller" ;;
esac

mmsg dispatch setlayout,"$next"
