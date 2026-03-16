#!/usr/bin/env fish

# Gallery - Simple image grid with timg
# Usage: gallery [cols] [files...]

function gallery
    # Par défaut : 4 colonnes
    set cols 4

    # Si premier arg est un nombre, c'est le nombre de colonnes
    if test (count $argv) -gt 0 && string match -qr '^\d+$' $argv[1]
        set cols $argv[1]
        set file_args $argv[2..]
    else
        set file_args $argv
    end

    # Si aucun fichier spécifié, trouver toutes les images
    if test (count $file_args) -eq 0
        set files (find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) 2>/dev/null)
    else
        set files $file_args
    end

    # Afficher avec timg avec les noms des fichiers (basename seulement)
    timg --grid=$cols --title="%b" --frames=1 $files
end
