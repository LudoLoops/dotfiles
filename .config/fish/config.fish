# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    if not set -q ZELLIJ
        # Attach to existing session or create new one
        zellij -l default attach -c default
    end
end

source ~/.config/fish/functions/index.fish

# systemctl --user import-envionment EDITOR VISUAL

if status is-interactive
    export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
    starship init fish | source

end

zoxide init fish | source

### EXPORT & PATH ###
set -gx EDITOR nvim
set -gx VISUAL nvim
# TERM is set by Kitty automatically (xterm-kitty)

# Consolidated PATH setup
set -gx BUN_INSTALL "$HOME/.bun"
test -d "$HOME/.volta"; and set -gx VOLTA_HOME "$HOME/.volta"

# Set PATH — only add dirs that exist
set -l _path_extra
for dir in ~/.npm-global/bin ~/.local/bin ~/Applications ~/Applications/depot_tools "$BUN_INSTALL/bin" "$VOLTA_HOME/bin" ~/.lmstudio/bin
    test -d "$dir"; and set -a _path_extra "$dir"
end
set -gx PATH $_path_extra $PATH

### fzf options
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --ignore node_modules --max-depth 5

### "bat" as manpager
set -x MANROFFOPT -c
if type -q bat
    set -x MANPAGER "sh -c 'col -bx | bat -plman'"
else if type -q batcat
    set -x MANPAGER "sh -c 'col -bx | batcat -plman'"
end

# This prevents me from installing packages with pip without being
# in a virtualenv first.
set -g -x PIP_REQUIRE_VIRTUALENV true

### FUNCTIONS ###

## Useful aliases
# update

#
# bat — Debian uses batcat, Arch uses bat
if type -q bat
    alias cat='bat --style=plain'
else if type -q batcat
    alias cat='batcat --style=plain'
end
# Kitty icat — only if kitten is available
if type -q kitten
    alias icat='kitten icat'
end

# Replace ls with eza
alias ls='eza --icons --color=always --group-directories-first' # my preferred listing
alias ld='eza -Dl --icons=auto --git --no-user --no-filesize --no-time -G --no-permissions' # short list dirs
alias ll='eza -a  --icons --color=always  --git --no-user --no-filesize --no-time -G --no-permissions  --group-directories-first' # all files and dirs
alias la='eza -lga --icons --color=always --group-directories-first' # long format
alias lt='eza -T --icons --color=always --group-directories-first --ignore-glob="node_modules|cache|logs|"' # tree listing
alias l.='eza -a --icons --color=always | grep -E "^\."'
alias lla='eza -lag --icons --color=always --no-filesize --group-directories-first --git' # long format
alias llg='gallery' # image gallery

alias copy='rsync -ah --progress --info=progress2'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '

alias clear="tput reset"

# confirm before overwriting something
# alias cp="cp -i"
alias mv='mv -i'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# adding flags
alias btrfs-size='btrfs filesystem df /' # show btfrs partition usage
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB

alias monIp='curl ifconfig.me'
alias myIp='curl ifconfig.me'

# Cleanup orphaned packages — Arch only
if type -q pacman
    alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
end

# exegol
alias exegol='sudo -E $(which exegol)'

# Zed editor — only if installed
if type -q zeditor
    alias zed='zeditor .'
end
# Note: Kitty SSH integration disabled - use `kitty +kitten ssh host` explicitly if needed
