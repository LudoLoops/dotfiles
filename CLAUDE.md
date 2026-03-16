# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a **GNU Stow-based dotfiles repository** for Arch Linux/CachyOS + Hyprland. The key architectural detail is that **the git root is inside `.config/`**, not at the repository root.

```
~/dotfiles/                # Repository root (not a git dir)
├── .config/               # Git root (.git lives here)
│   ├── fish/              # → ~/.config/fish
│   ├── nvim/              # → ~/.config/nvim
│   ├── hypr/              # → ~/.config/hypr
│   ├── kitty/             # → ~/.config/kitty
│   ├── waybar/            # → ~/.config/waybar
│   └── ...
└── .local/                # → ~/.local
```

**GNU Stow creates symlinks**: `~/.config/X → ~/dotfiles/.config/X`

Edit files directly via symlinks (e.g., `~/.config/fish/config.fish`) - changes affect the repo.

## Key Architectural Patterns

### 1. Modular Configuration Sourcing

Most configs use a modular `source` / `include` pattern:

- **Hyprland**: `hyprland.conf` sources `keybindings.conf`, `windowrules.conf`, `monitors.conf`, `config/*.conf`
- **Waybar**: `config.jsonc` includes `modules/*json*` and `includes/includes.json`
- **Fish**: `config.fish` sources `functions/index.fish`

This keeps configs organized by concern rather than monolithic files.

### 2. Fish Function Auto-Loading

The `fish/functions/index.fish` file automatically sources all `.fish` files (including subdirectories) at shell startup.

**Critical**: Do not modify or delete `index.fish` - it's the loader for the entire function system.

To add a new function: create a `.fish` file in `fish/functions/` - it loads automatically.

### 3. HyDE Integration (Hyprland)

Hyprland configs integrate with **HyDE** (Hyprland Desktop Environment). The marker `$HYDE_HYPRLAND=set` in `hyprland.conf` prevents HyDE from overwriting user configs.

## Git Workflow

```bash
# Work from the git root
cd ~/dotfiles/.config

# Commit changes
git add .
git commit -m "description"
git push
```

**Commit format**: Conventional commits `<type>: <subject>`

**Install on new machine**:
```bash
git clone https://github.com/LudoLoops/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .config
```

## Component-Specific Documentation

Each major component has its own `CLAUDE.md` with detailed patterns:

- `fish/CLAUDE.md` - Shell functions, deployment pipelines, SSH management
- `hypr/CLAUDE.md` - Hyprland, HyDE integration, workflows

Consult these when working on specific components.

## Files Excluded from Git

From `.gitignore`:

| Pattern | Reason |
|---------|--------|
| `fish/fish_variables` | Contains API keys |
| `fish/conf.d/` | Environment variables with secrets |
| `.config/kwinrc`, `.config/kxkbrc`, `.config/plasmarc` | Machine-specific |
| `.claude/` subdirs | Claude Code runtime (not config) |

## Common Commands

| Task | Command |
|------|---------|
| Reload Fish | `source ~/.config/fish/config.fish` |
| Reload Hyprland | `hyprctl reload` or `Super+Shift+R` |
| System update | `update` (Fish function, auto-detects OS) |
| Neovim plugins | `:Lazy` inside Neovim |

## Development Tools

- **Editor**: Neovim (LazyVim distribution)
- **Shell**: Fish 3.6+ with Starship prompt
- **Navigation**: `z` (zoxide)
- **Fuzzy finding**: `fzf`
- **Package manager**: `paru` (AUR + pacman)
