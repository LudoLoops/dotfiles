function theme --description 'Switch Kitty + Zellij theme'
    set -l themes mocha frappe latte tokyo-night rose-pine gruvbox nord

    if test (count $argv) -eq 0
        echo "Usage: theme <name>"
        echo ""
        echo "Available themes:"
        printf "  • %s\n" $themes
        echo ""
        set current (grep 'include.*\.conf' ~/.config/kitty/kitty.conf | grep -oE "(mocha|frappe|latte|tokyo-night|rose-pine|gruvbox|nord)")
        echo "Current: $current"
        return
    end

    set -l theme $argv[1]

    if not contains $theme $themes
        echo "Unknown theme: $theme"
        echo "Available: "(string join ", " -- $themes)
        return 1
    end

    # Kitty
    sed -i "s/include \(mocha\|frappe\|latte\|tokyo-night\|rose-pine\|gruvbox\|nord\)\.conf/include $theme.conf/" ~/.config/kitty/kitty.conf

    # Zellij — same name except gruvbox (gruvbox-dark in zellij)
    set -l zname $theme
    switch $theme
        case gruvbox
            set zname "gruvbox-dark"
    end
    sed -i "s/theme \".*\"/theme \"$zname\"/" ~/.config/zellij/config.kdl

    echo "✓ $theme — Kitty + Zellij"
    echo "Restart Kitty (close & reopen) and Zellij (kill-all-sessions) to see changes"
end
