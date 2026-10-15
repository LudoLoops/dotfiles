# Server-oriented aliases adapted from .config/fish/config.fish and
# .config/fish/functions/git/aliases.fish.
#
# Optional: source this file from an interactive ~/.zshrc:
#   [[ -r "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"
#
# No Fish files are changed, and no Zsh plugins/frameworks are required.

# Keep these aliases limited to interactive sessions.
[[ -o interactive ]] || return 0

# Directory shortcuts (Fish used abbreviations).
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# File listing: prefer eza if installed; otherwise use standard ls.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto --color=auto --group-directories-first'
  alias ld='eza -Dl --icons=auto --git --no-user --no-filesize --no-time -G --no-permissions'
  alias ll='eza -a --icons=auto --color=auto --git --no-user --no-filesize --no-time -G --no-permissions --group-directories-first'
  alias la='eza -lga --icons=auto --color=auto --group-directories-first'
  alias lt='eza -T --icons=auto --color=auto --group-directories-first --ignore-glob="node_modules|cache|logs"'
  alias lla='eza -lag --icons=auto --color=auto --no-filesize --group-directories-first --git'
else
  alias ll='ls -lah'
  alias la='ls -la'
  alias lt='ls -R'
  alias lla='ls -lah'
fi

# General shell utilities.
alias mkdir='mkdir -p'
alias mv='mv -i'
alias df='df -h'
if command -v free >/dev/null 2>&1; then
  alias free='free -m'
fi
if command -v rsync >/dev/null 2>&1; then
  alias copy='rsync -ah --progress --info=progress2'
fi
if command -v wget >/dev/null 2>&1; then
  alias wget='wget -c'
fi
alias tarnow='tar -acf'
alias untar='tar -zxvf'
if command -v curl >/dev/null 2>&1; then
  alias monIp='curl ifconfig.me'
  alias myIp='curl ifconfig.me'
fi

# Existing Fish Git aliases, kept with the same names and behavior.
if command -v git >/dev/null 2>&1; then
  alias g='git'
  alias addup='git add -u'
  alias addall='git add -A'
  alias branch='git branch'
  alias clone='git clone'
  alias fetch='git fetch'
  alias pull='git pull origin'
  alias push='git push origin'
fi

# Intentionally NOT copied: update (multi-server updater), git-deploy,
# Exegol/sudo, host-specific rag-ferrite, Herdr, virtualenv hooks,
# Fish keybindings, fzf functions, and Fish-specific completions.
