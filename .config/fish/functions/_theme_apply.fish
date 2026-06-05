#!/bin/fish
# _theme_apply — appelé par fzf focus binding
set -l theme $argv[1]
set -l conf ~/.config/kitty/kitty.conf
set -l zconf ~/.config/zellij/config.kdl

# Kitty
sed -i "s/include \(mocha\|frappe\|latte\|tokyo-night\|rose-pine\|gruvbox\|nord\)\.conf/include $theme.conf/" $conf

# Zellij
set -l zname $theme
switch $theme
    case gruvbox
        set zname "gruvbox-dark"
end
sed -i "s/theme \".*\"/theme \"$zname\"/" $zconf
