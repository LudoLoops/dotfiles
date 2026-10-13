#!/bin/bash
# Screenshot avec annotation : capture le moniteur actif (image figée), ouvre satty pour
# annoter/recadrer, et Entrée = copie uniquement dans le presse-papier.
#
# Flux repris du script Mango (~/.config/mango/scripts/screenshot.sh), porté sur Hyprland
# (hyprctl au lieu de mmsg), sans enregistrement automatique.
set -u

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
    --actions-on-enter save-to-clipboard \
    --early-exit all
