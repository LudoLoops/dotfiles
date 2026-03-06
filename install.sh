#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "📦 Installing stow (if needed)..."
if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow..."
    if [ -f /etc/debian_version ]; then
        sudo apt install stow -y
    elif [ -f /etc/arch-release ]; then
        paru -S stow --noconfirm
    else
        echo "❌ Unsupported OS. Please install stow manually:"
        echo "   Arch: paru -S stow"
        echo "   Debian: sudo apt install stow"
        exit 1
    fi
fi

echo "📦 Installing chezmoi (if needed)..."
if ! command -v chezmoi &> /dev/null; then
    echo "Installing Chezmoi..."
    if [ -f /etc/debian_version ]; then
        sudo apt install chezmoi -y
    elif [ -f /etc/arch-release ]; then
        paru -S chezmoi --noconfirm
    else
        echo "❌ Unsupported OS. Please install chezmoi manually:"
        echo "   Arch: paru -S chezmoi"
        echo "   Debian: sudo apt install chezmoi"
        exit 1
    fi
fi

echo "🔗 Creating symlinks with stow..."
cd "$DOTFILES_DIR"

# Stow .config directory
echo "  • Linking .config..."
stow -d . -t ~/.config .config

# Stow .claude directory (global Claude Code configs)
echo "  • Linking .claude..."
stow .claude

# Apply chezmoi templates (OS-specific configs)
echo "  • Applying OS-specific templates..."
chezmoi apply

echo "🐠 Reloading Fish shell configuration..."
fish -c "source ~/.config/fish/functions/index.fish" 2>/dev/null || true

echo "✅ Dotfiles installed successfully!"
echo ""
echo "💡 To update from this repo in the future:"
echo "   cd $DOTFILES_DIR && git pull && stow -d . -t ~/.config .config && stow .claude && chezmoi apply"
