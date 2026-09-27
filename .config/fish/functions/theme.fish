function theme --description 'Switch Kitty theme'
    set -l themes mocha frappe latte tokyo-night rose-pine gruvbox nord
    set -l conf ~/.config/kitty/kitty.conf

    set -l current (grep -oE '(mocha|frappe|latte|tokyo-night|rose-pine|gruvbox|nord)' $conf | head -1)
    if test -z "$current"
        set current "?"
    end

    if test (count $argv) -gt 0
        if contains $argv[1] $themes
            _theme_switch $argv[1]
            return
        end
    end

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
            _theme_switch $themes[$choice]
            return
        end
    end

    echo "Invalid choice"
end

function _theme_switch
    set -l theme $argv[1]
    set -l conf ~/.config/kitty/kitty.conf

    sed -i "s/include \(mocha\|frappe\|latte\|tokyo-night\|rose-pine\|gruvbox\|nord\)\.conf/include $theme.conf/" $conf

    echo "✓ $theme — restart Kitty to apply"
end
