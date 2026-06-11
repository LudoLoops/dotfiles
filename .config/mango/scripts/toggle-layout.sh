#!/bin/sh
# Toggle layout between tile and scroller on active tag
# Mango 0.14+ mmsg syntax

SOCK="${MANGO_INSTANCE_SIGNATURE:-$(ls /run/user/1000/mango-*.sock 2>/dev/null)}"
if [ -z "$SOCK" ]; then
    exit 1
fi

export MANGO_INSTANCE_SIGNATURE="$SOCK"

# Get active tag layout
current=$(mmsg get all-tags 2>/dev/null | jq -r '[.[] | .tags[] | select(.is_active == true)][0].layout // empty' 2>/dev/null)

case "$current" in
    S) mmsg dispatch setlayout,tile ;;
    *) mmsg dispatch setlayout,scroller ;;
esac
