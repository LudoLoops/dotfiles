#!/bin/bash
# Autostart: charge le preset input-remapper après le démarrage de Mango ou Hyprland
# (Mango: exec-once dans ~/.config/mango/autostart.conf ; Hyprland: hl.on("hyprland.start") dans hyprland.lua)
# Log explicite pour debug + retry car le service peut démarrer avant le device USB

LOGFILE="/tmp/input-remapper-autostart.log"
echo "$(date): Démarrage du script autostart" > "$LOGFILE"

# Attendre que le service input-remapper soit prêt
for i in $(seq 1 10); do
    if input-remapper-control --command autoload >>"$LOGFILE" 2>&1; then
        echo "$(date): Autoload réussi ( tentative $i)" >> "$LOGFILE"
        # Vérifier que le preset est bien injecté
        sleep 1
        if journalctl -u input-remapper --no-pager --since "30 sec ago" 2>/dev/null | grep -q "Starting injecting"; then
            echo "$(date): Preset injecté avec succès" >> "$LOGFILE"
            exit 0
        fi
    fi
    echo "$(date): Tentative $i échouée, retry dans 2s" >> "$LOGFILE"
    sleep 2
done

echo "$(date): ERREUR — échec après 10 tentatives" >> "$LOGFILE"
exit 1
