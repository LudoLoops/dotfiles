#!/bin/bash
# Screenshot avec annotation : capture le moniteur actif (image figée), ouvre satty pour
# annoter/recadrer, et Entrée = copie dans le presse-papier + sauvegarde du fichier.
#
# Flux repris du script Mango (~/.config/mango/scripts/screenshot.sh), porté sur Hyprland
# (hyprctl au lieu de mmsg) avec la copie presse-papier et la sauvegarde.
set -u

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

MON=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

if [ -z "$MON" ] || [ "$MON" = "null" ]; then
    echo "screenshot: moniteur actif introuvable" >&2
    notify-send "Screenshot" "Moniteur actif introuvable" 2>/dev/null || true
    exit 1
fi

grim -o "$MON" - | satty \
    --filename - \
    --resize smart \
    --floating-hack \
    --copy-command wl-copy \
    --output-filename "$DIR/Screenshot_%Y-%m-%d_%H-%M-%S.png" \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --early-exit all
