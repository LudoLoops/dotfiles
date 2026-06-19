#!/bin/bash
# Capture active monitor only, then open satty for annotation
SOCK=$(ls /run/user/1000/mango-*.sock 2>/dev/null | head -1)
focused=$(MANGO_INSTANCE_SIGNATURE="$SOCK" mmsg get all-monitors 2>/dev/null | jq -r '.monitors[] | select(.active==true) | .name')
grim -o "$focused" - | satty -f - --resize smart --floating-hack
