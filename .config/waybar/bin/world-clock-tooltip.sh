#!/bin/env bash
STATE_FILE="$XDG_RUNTIME_DIR/waybar-world-clock-state"
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

if [ "$STATE" = "0" ]; then
    # Mode world - afficher calendrier
    date +"%B %Y"
    cal | sed 's/^/  /'
else
    # Mode local - date du jour
    date +"%A %d %B %Y"
fi
