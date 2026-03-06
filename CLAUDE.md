# CLAUDE.md

This repository contains my personal dotfiles managed by [Chezmoi](https://www.chezmoi.io/).

## Quick Start

**Installation:**
```bash
cd ~/dotfiles
./install.sh
```

**Updates:**
```bash
git pull && chezmoi apply
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

- **Templates:** `chezmoi_tmpl/` excluded from home, used to generate OS-specific configs
- **Symlinks:** All configs symlinked (except generated files from templates)
- **Multi-OS:** Works on Arch/CachyOS and Debian with appropriate package managers
- **Hyprland:** Keybindings in `bind_M_n_history.fish` (Alt+1..9 for history)
