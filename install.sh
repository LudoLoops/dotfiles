#!/bin/bash

set -e

echo "📦 Installing base packages..."
# sudo pacman -S --noconfirm exa zoxide bat fish git chezmoi

paru -S zoxide exa yazi fish kitty bat starship nvim --noconfirm

echo "🔗 Initializing dotfiles with chezmoi..."
chezmoi init --apply youruser/your-dotfiles-repo

echo "✅ Done."
