#!/bin/sh
SOCK="${MANGO_INSTANCE_SIGNATURE:-$(ls /run/user/1000/mango-*.sock 2>/dev/null)}"
if [ -z "$SOCK" ]; then
    exit 1
fi
export MANGO_INSTANCE_SIGNATURE="$SOCK"
mmsg dispatch setlayout,scroller
