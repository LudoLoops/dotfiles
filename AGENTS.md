# AGENTS.md

Guide for AI agents working on these dotfiles configuration files.

## Repository Structure

```
.config/              # Git root (all configs are here)
├── fish/             # Fish shell configuration
├── nvim/             # Neovim configuration
├── hypr/             # Hyprland window manager
├── kitty/            # Kitty terminal
├── waybar/           # Wayland status bar
├── yazi/             # Terminal file manager
├── rofi/             # App launcher
├── dunst/            # Notification daemon
└── README.md         # This file
```

**Important:** This repo uses GNU Stow. Files in `~/dotfiles/.config/` are symlinked to `~/.config/`.

## System Context

**OS:** Arch Linux / CachyOS
**WM:** Hyprland (Wayland)
**Shell:** Fish 3.6+
**Editor:** Neovim
**Terminal:** Kitty

## Key Configuration Files

### Shell (Fish)
- **Location:** `fish/`
- **Entry point:** `fish/config.fish`
- **Functions:** `fish/functions/` (auto-loaded via `fish/functions/index.fish`)
- **Notable functions:**
  - `ssh-new` - SSH key & config management with TUI
  - `update` - Multi-OS system update (auto-detects Arch/Debian)
  - `mkroute` - SvelteKit route scaffolder
  - `ship` - Deployment pipeline (beta/prod)

### Editor (Neovim)
- **Location:** `nvim/`
- **Entry:** `nvim/init.lua`
- **Plugin system:** Lazy.nvim
- **Config dir:** `nvim/lua/config/`
- **Plugins:** `nvim/lua/plugins/`

### Window Manager (Hyprland)
- **Location:** `hypr/`
- **Entry:** `hypr/hyprland.conf`
- **Modular configs:** `hypr/config/`
- **Themes:** `hypr/themes/`
- **Animations:** `hypr/animations/`

### Terminal (Kitty)
- **Location:** `kitty/`
- **Entry:** `kitty/kitty.conf`

## Git Workflow

**Repo location:** `~/dotfiles/` (git root is `~/dotfiles/.config/.git`)

```bash
cd ~/dotfiles/.config
git add .
git commit -m "description"
git push
```

**Install on new machine:**
```bash
git clone https://github.com/LudoLoops/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .config
```

## Files NOT to Modify

**Ignored by git (contain sensitive data):**
- `fish/fish_variables` - Contains API keys
- `fish/conf.d/env.fish` - Contains API keys

Do not attempt to read or modify these files.

## Code Conventions

**Fish functions:**
- Use `command` prefix for external tools
- Validate arguments with `test -z`
- Error handling: `|| begin ... end`
- Use emoji for visual feedback: `✅ ❌ 📁`

**Neovim:**
- Lua config
- Lazy.nvim for plugins
- Follow LazyVim conventions

## When Working on These Files

1. **Read existing patterns** before modifying
2. **Check file location** - repo is in `~/dotfiles/.config/`
3. **Test changes:** reload shell or restart application
4. **Commit from:** `cd ~/dotfiles/.config`

## Common Tasks

**Add new Fish function:**
```bash
nvim ~/dotfiles/.config/fish/functions/my-function.fish
# Auto-loaded on next shell start
```

**Update Hyprland config:**
```bash
nvim ~/dotfiles/.config/hypr/config/keybinds.conf
# Reload: hyprctl reload
```

**Install new Neovim plugin:**
```bash
nvim ~/dotfiles/.config/nvim/lua/plugins/
# Add plugin file, Lazy will install it
```
