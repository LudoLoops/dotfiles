function palette-preview --description "Affiche les 16 couleurs ANSI + faux code — zap les thèmes avec Ctrl+Shift+J/K"
    set -l reset \e\[0m
    echo "█████ 16 couleurs ANSI █████"
    # Fond : couleurs 0-7 puis 8-15
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
    echo "Zap avec Ctrl+Shift+J / Ctrl+Shift+K 👀"
end
