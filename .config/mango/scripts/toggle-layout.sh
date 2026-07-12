#!/bin/sh
# Toggle layouts: tile ↔ scroller
# Mango 0.14+ mmsg syntax

SOCK="${MANGO_INSTANCE_SIGNATURE:-$(ls --color=never /run/user/1000/mango-*.sock 2>/dev/null)}"
if [ -z "$SOCK" ]; then
    exit 1
fi

export MANGO_INSTANCE_SIGNATURE="$SOCK"

# Get layout_symbol of the active monitor
current=$(mmsg get all-monitors 2>/dev/null | grep -o '"active":true[^}]*"layout_symbol":"[A-Z]"' | grep -o '"layout_symbol":"[A-Z]"' | grep -o '[A-Z]')

if [ "$current" = "S" ]; then
    next="tile"
else
    next="scroller"
fi

mmsg dispatch setlayout,"$next"
