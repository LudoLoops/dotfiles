function theme --description 'Switch Kitty + Zellij theme (mocha/frappe/latte)'
    if test (count $argv) -eq 0
        echo "Usage: theme <mocha|frappe|latte>"
        echo "Current: "(grep 'include.*\.conf' ~/.config/kitty/kitty.conf | grep -oE '(mocha|frappe|latte)')
        return
    end

    set -l theme $argv[1]

    switch $theme
        case mocha frappe latte
        case '*'
            echo "Invalid theme: $theme"
            echo "Choose: mocha, frappe, latte"
            return 1
    end

    # Kitty
    sed -i "s/include \(mocha\|frappe\|latte\)\.conf/include $theme.conf/" ~/.config/kitty/kitty.conf

    # Zellij
    switch $theme
        case mocha
            set zellij_theme "catppuccin-mocha"
        case frappe
            set zellij_theme "catppuccin-frappe"
        case latte
            set zellij_theme "catppuccin-latte"
    end
    sed -i "s/theme \".*\"/theme \"$zellij_theme\"/" ~/.config/zellij/config.kdl

    echo "Switched to $theme (Kitty + Zellij)"
    echo "Restart Kitty and Zellij to see changes"
end
