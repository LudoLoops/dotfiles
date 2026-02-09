# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    #    # smth smth
end

source ~/.config/fish/functions/index.fish

systemctl --user import-environment EDITOR VISUAL

if status is-interactive
    starship init fish | source
end

zoxide init fish | source

### EXPORT & PATH ###
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERM xterm-kitty

# Consolidated PATH setup
set -gx BUN_INSTALL "$HOME/.bun"
set -gx VOLTA_HOME "$HOME/.volta"

# Set PATH with all additions in one place
set -gx PATH \
    ~/.npm-global/bin \
    ~/.local/bin \
    ~/Applications \
    ~/Applications/depot_tools \
    "$BUN_INSTALL/bin" \
    "$VOLTA_HOME/bin" \
    /home/loops/.lmstudio/bin \
    $PATH

### fzf options
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --ignore node_modules --max-depth 5

### "bat" as manpager
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -plman'"

# This prevents me from installing packages with pip without being
# in a virtualenv first.
set -g -x PIP_REQUIRE_VIRTUALENV true

### FUNCTIONS ###

## Useful aliases
# update

#
# bat
alias cat='bat --style=plain'
alias icat='kitten icat'

# Replace ls with eza
alias ls='eza --icons --color=always --group-directories-first' # my preferred listing
alias ld='eza -Dl --icons=auto --git --no-user --no-filesize --no-time -G --no-permissions' # short list dirs
alias ll='eza -a  --icons --color=always  --git --no-user --no-filesize --no-time -G --no-permissions  --group-directories-first' # all files and dirs
alias la='eza -lga --icons --color=always --group-directories-first' # long format
alias lt='eza -T --icons --color=always --group-directories-first --ignore-glob="node_modules|cache|logs|"' # tree listing
alias l.='eza -a --icons --color=always | grep -E "^\."'
alias lla='eza -lag --icons --color=always --no-filesize --group-directories-first --git' # long format

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

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# exegol
alias exegol='sudo -E $(which exegol)'

alias claude="/home/loops/.claude/local/claude"

alias ssh="kitty +kitten ssh"
