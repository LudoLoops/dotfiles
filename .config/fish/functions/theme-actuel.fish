function theme-actuel --description "Affiche le nom du thème WezTerm courant (celui en preview via le zap)"
    # Le titre de la fenêtre WezTerm contient "🎨 NomDuTheme" pendant/après le zap
    set -l title (wezterm cli list --format json 2>/dev/null | jq -r '.[] | select(.tab_id == 1) | .title' 2>/dev/null | head -1)
    if string match -q '🎨*' -- $title
        echo (string replace '🎨 ' '' -- $title)
    else
        echo "Aucun override actif — thème par défaut (auto dark/light)"
    end
end
