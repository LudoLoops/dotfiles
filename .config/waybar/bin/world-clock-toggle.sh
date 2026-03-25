#!/bin/env bash
STATE_FILE="$XDG_RUNTIME_DIR/waybar-world-clock-state"
mkdir -p "$(dirname "$STATE_FILE")"

# Lire l'état actuel (0 = local, 1 = world)
STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

if [ "$STATE" = "0" ]; then
    # Afficher les 3 villes avec calendrier
    manille=$(TZ="Asia/Manila" date +"%R")
    paris=$(TZ="Europe/Paris" date +"%R")
    montreal=$(TZ="America/Montreal" date +"%R")
    date_locale=$(date +"%d·%m·%y")
    echo "🇵🇭 $manille · 🇫🇷 $paris · 🇨🇦 $montreal 📅 $date_locale"
else
    # Afficher heure locale
    date +"%R 📅 %d·%m·%y"
fi
