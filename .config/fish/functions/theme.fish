function theme --description 'Interactive theme switcher with live preview'
    set -l themes mocha frappe latte tokyo-night rose-pine gruvbox nord
    set -l conf ~/.config/kitty/kitty.conf
    set -l script ~/.config/fish/functions/_theme_apply.fish

    # Sauvegarde le thème actuel
    set -l original (grep -oE '(mocha|frappe|latte|tokyo-night|rose-pine|gruvbox|nord)' $conf | head -1)
    if test -z "$original"
        set original "frappe"
    end

    # Mode direct: theme frappe
    if test (count $argv) -gt 0
        if contains $argv[1] $themes
            fish $script $argv[1]
            echo "✓ $argv[1]"
            return
        else
            echo "Available: "(string join ", " -- $themes)
            return 1
        end
    end

    # Mode interactif
    if not type -q fzf
        echo "Install fzf: paru -S fzf"
        return 1
    end

    set -l choice (printf "%s\n" $themes | fzf \
        --prompt="Theme> " \
        --header="↑↓ navigate  Enter confirm  Esc cancel (restore $original)" \
        --preview-window="right:50%" \
        --preview="grep -E 'background|foreground|color[0-9]' ~/.config/kitty/{}.conf 2>/dev/null | sed 's/^/  /'" \
        --bind "focus:execute-silent(fish $script {})")

    if test $status -ne 0
        fish $script $original
        echo "Cancelled — restored $original"
        return
    end

    if test -n "$choice"
        echo "✓ "(echo $choice | tr -d '[:space:]')" — restart Zellij to apply"
    end
end
