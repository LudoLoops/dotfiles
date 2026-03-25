#!/bin/env bash
STATE_FILE="$XDG_RUNTIME_DIR/waybar-world-clock-state"
mkdir -p "$(dirname "$STATE_FILE")"

# Lire et basculer l'état
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

if [ "$STATE" = "0" ]; then
    echo "1" > "$STATE_FILE"
else
    echo "0" > "$STATE_FILE"
fi

# Signaler à waybar de rafraîchir
pkill -RTMIN+8 waybar
