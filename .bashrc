# ~/.bashrc - Minimal config for non-interactive shells
# Main shell: Fish (~/.config/fish/config.fish)

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# Basic environment
export EDITOR=nvim
export PAGER=less

# Add user bin if exists
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Preserve Fish PATH when bash is launched from Fish
if [[ $- != *i* ]] && command -v fish >/dev/null 2>&1; then
    export PATH=$(fish -c 'echo $PATH')
fi
