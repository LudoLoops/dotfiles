function theme --description 'Switch theme — Kitty + Zellij'
    set -l themes mocha frappe latte tokyo-night rose-pine gruvbox nord
    set -l conf ~/.config/kitty/kitty.conf
    set -l zconf ~/.config/zellij/config.kdl

    # Thème actuel
    set -l current (grep -oE '(mocha|frappe|latte|tokyo-night|rose-pine|gruvbox|nord)' $conf | head -1)
    if test -z "$current"
        set current "?"
    end

    # Mode direct: theme frappe
    if test (count $argv) -gt 0
        if contains $argv[1] $themes
            _theme_switch $argv[1]
            return
        end
    end

    # Menu simple
    echo ""
    echo "  Current: $current"
    echo ""
    set i 1
    for t in $themes
        if test "$t" = "$current"
            echo "  $i) $t  *"
        else
            echo "  $i) $t"
        end
        set i (math $i + 1)
    end
    echo ""
    read -P "Choice (1-7, Enter to cancel): " choice

    if test -z "$choice"
        return
    end

    if string match -qr '^\d+$' -- $choice
        if test $choice -ge 1 -a $choice -le (count $themes)
            set -l picked $themes[$choice]
            _theme_switch $picked
            return
        end
    end

    echo "Invalid choice"
end

function _theme_switch
    set -l theme $argv[1]
    set -l conf ~/.config/kitty/kitty.conf
    set -l zconf ~/.config/zellij/config.kdl

    sed -i "s/include \(mocha\|frappe\|latte\|tokyo-night\|rose-pine\|gruvbox\|nord\)\.conf/include $theme.conf/" $conf

    set -l zname $theme
    switch $theme
        case gruvbox
            set zname "gruvbox-dark"
    end
    sed -i "s/theme \".*\"/theme \"$zname\"/" $zconf

    echo "✓ $theme — restart Zellij to apply"
end
