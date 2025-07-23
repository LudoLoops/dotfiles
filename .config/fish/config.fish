# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

source ~/.config/fish/functions/index.fish
set -Ux fish_user_paths ~/.npm-global/bin $fish_user_paths $HOME/.local/bin $HOME/Applications

systemctl --user import-environment EDITOR VISUAL

if status is-interactive
    starship init fish | source
end

zoxide init fish | source

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

### EXPORT ###
set -gx EDITOR neovide
set -gx VISUAL neovide

set -x TERM xterm-kitty # Sets the terminal type
### fzf option
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --ignore node_modules --max-depth 5

### "bat" as manpager
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -plman'"

# This prevents me from installing packages with pip without being
# in a virtualenv first.
set -g -x PIP_REQUIRE_VIRTUALENV true

### FUNCTIONS ###

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

## Useful aliases
# update

function update
    set os (uname -r)

    if test -f /etc/arch-release
        paru -Syu --noconfirm
        sudo paccache -r
        if type -q flatpak
            flatpak update -y
        end
        if type -q pnpm
            pnpm self-update
        end
    else if test -f /etc/fedora-release
        sudo dnf upgrade --refresh -y
        flatpak update -y
    else
        echo "⚠️  Unknown distro – no update command defined."
    end

end
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

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
#

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/loops/.lmstudio/bin
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
