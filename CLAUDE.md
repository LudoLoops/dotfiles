# CLAUDE.md

This repository contains my personal dotfiles.

**Setup:** GNU Stow for symlinks + Chezmoi for OS-specific templates only.

## Quick Start

**Installation:**
```bash
cd ~/dotfiles
./install.sh
```

**Updates:**
```bash
cd ~/dotfiles && git pull
```

Chezmoi templates (OS-specific):
```bash
chezmoi apply  # Regenerate templates after OS change
```

## System Overview

**Desktop:** Arch Linux / CachyOS with Hyprland (Wayland WM)
**Shell:** Fish 3.6+ (with keybindings, auto-venv, productivity tools)
**Editors:** Neovim (primary), Kitty terminal
**Package Manager:** paru (AUR helper + pacman)

## Key Commands

**System update:**
```bash
update          # Arch/CachyOS: paru + paccache, Debian: apt
```

**Development:**
```bash
bunx sv create  # SvelteKit with Tailwind, TypeScript, Skeleton
```

**Navigation:**
```bash
z <dir>         # zoxide (smart cd)
```

## Project Structure

```
.config/fish/functions/
├── chezmoi_tmpl/          # OS-specific templates
│   ├── update.fish.tmpl    # Multi-OS update function
│   ├── update_arch.fish    # Arch-specific (paru, paccache)
│   └── update_debian.fish  # Debian-specific (apt)
├── keybindings.fish        # History (!!, !$, M+N bindings)
├── shortcuts.fish          # Editor launchers
├── system.fish             # Docker, zoxide, yazi, SSH
├── dev.fish                # SvelteKit, deployment
├── ensure_installed.fish   # Dependency helper
└── bind_M_n_history.fish   # Alt+Number history (for Hyprland)
```

## Dependency Management

**Helper function:**
```fish
require <program> [package]
```

Automatically checks if installed, offers to install with correct package for current OS (Arch/Debian).

**Package managers:**
- Arch: paru (AUR + pacman)
- Debian: apt
- Flatpak: Flatpak (if installed)

## Code Patterns

**Error handling:**
```fish
command tool || begin
    echo "❌ Failed to run tool"
    return 1
end
```

**Validation:**
```fish
if test -z "$arg"
    echo "❌ Error: argument required"
    return 1
end
```

## Function Organization

**Key domains:**
- **git/** - Git workflows (commit, branch, ship, etc.)
- **dev.fish** - Web development (SvelteKit, deployment)
- **system.fish** - System administration (Docker, tools)
- **media.fish** - Media processing (ImageMagick, WebP)
- **ai.fish** - AI tools integration

## Testing

```fish
# Syntax check
fish -n ~/.config/fish/functions/new-function.fish

# Reload functions
source ~/.config/fish/functions/index.fish

# Test function
function-name --help
```

## Important Notes

- **Templates:** `chezmoi_tmpl/` contains OS-specific templates managed by chezmoi
- **Symlinks:** All configs are managed by GNU Stow (`~/.config/X → ~/dotfiles/.config/X`)
- **Chezmoi:** Only used for templates, NOT for symlinks
- **Multi-OS:** Works on Arch/CachyOS and Debian with appropriate package managers
- **Hyprland:** Keybindings in `bind_M_n_history.fish` (Alt+1..9 for history)

## Workflow

1. Edit files directly (they're symlinks managed by stow):
   ```fish
   nvim ~/.config/fish/config.fish  # Actually edits ~/dotfiles/.config/fish/config.fish
   ```

2. Commit changes when ready:
   ```fish
   cd ~/dotfiles
   git add -A && git commit -m "update"
   ```

3. On new machine:
   ```fish
   git clone https://github.com/LudoLoops/dotfiles.git ~/dotfiles
   cd ~/dotfiles && ./install.sh  # Runs stow + chezmoi apply
   ```
