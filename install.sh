#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing stow (if needed)..."
if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow..."
    paru -S stow --noconfirm
fi

echo "🔗 Creating symlinks with stow..."
cd "$DOTFILES_DIR"

# Stow .config directory
echo "  • Linking .config..."
stow .config

# Stow .claude directory (global Claude Code configs)
echo "  • Linking .claude..."
stow .claude

echo "🐠 Reloading Fish shell configuration..."
fish -c "source ~/.config/fish/functions/index.fish" 2>/dev/null || true

echo "✅ Dotfiles installed successfully!"
echo ""
echo "💡 To update from this repo in the future:"
echo "   cd $DOTFILES_DIR && git pull && stow .config .claude"
