function palette-preview --description "Affiche le thème actuel + les 16 couleurs ANSI — zap avec Ctrl+Shift+J/K"
    set -l reset \e\[0m
    # Thème courant : lu depuis le titre de fenêtre WezTerm (mis à jour par le zap)
    set -l title (wezterm cli list --format json 2>/dev/null | jq -r '.[] | select(.tab_id == 1) | .title' 2>/dev/null | head -1)
    echo "═══════════════════════════════════════"
    if string match -q '🎨*' -- $title
        echo "🎨 Thème actuel : "(string replace '🎨 ' '' -- $title)
    else
        echo "🎨 Thème actuel : auto (Frappé dark / Latte light) — zap pour changer"
    end
    echo "═══════════════════════════════════════"
    echo
    echo "█████ 16 couleurs ANSI █████"
    for i in (seq 0 7)
        printf '\e[4%dm         %s ' $i $reset
    end
    echo
    for i in (seq 8 15)
        printf '\e[10%dm         %s ' (math $i - 8) $reset
    end
    echo
    echo
    echo "─── Texte coloré ───"
    for i in (seq 1 7)
        printf '\e[3%dm■ texte %d%s  ' $i $i $reset
    end
    echo
    for i in (seq 1 7)
        printf '\e[9%dm■ bright %d%s  ' $i $i $reset
    end
    echo
    echo
    echo "─── Faux code ───"
    echo "✅ pass  ❌ fail  ⚠️ warn  📦 pkg  🔧 fix"
    echo "const color = '#ca9ee6'; // comment"
    echo "error: cannot find module 'xyz' (E404)"
    echo "→ build ok in 312ms  ✓ 2 tests passed"
    echo
    echo "─── Bold/italic/underline ───"
    printf '\e[1mbold%s \e[3mitalic%s \e[4munderline%s \e[1;3mboth%s\n' $reset $reset $reset $reset
    echo
    echo "Zap : Ctrl+Shift+J / Ctrl+Shift+K — puis re-lance palette-preview pour le nom"
end
