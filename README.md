# My Dotfiles

This repository contains my system configuration files (dotfiles) and Claude Code global configurations.

**Setup:** GNU Stow for symlinks + Chezmoi for OS-specific templates.

## 🛠 Requirements

**Git:**
```bash
sudo pacman -S git  # Arch/Debian
```

**GNU Stow** (for symlinks):
```bash
sudo pacman -S stow  # Arch
sudo apt install stow  # Debian
```

**Chezmoi** (for OS-specific templates only):
```bash
sudo pacman -S chezmoi  # Arch
sudo apt install chezmoi  # Debian
```

## 🚀 Installation

Clone the repository into your $HOME:

```bash
git clone https://github.com/LudoLoops/dotfiles.git
cd dotfiles
./install.sh
```

## 🔗 How it works

**1. GNU Stow** creates symlinks:
```bash
cd ~/dotfiles
stow .config  # Creates all .config symlinks
```

Result:
```bash
~/.config/fish → ~/dotfiles/.config/fish
~/.config/nvim → ~/dotfiles/.config/nvim
~/.config/yazi → ~/dotfiles/.config/yazi
~/.config/rofi → ~/dotfiles/.config/rofi
~/.config/dunst → ~/dotfiles/.config/dunst
~/.config/wlogout → ~/dotfiles/.config/wlogout
~/.config/waypaper → ~/dotfiles/.config/waypaper
```

**2. Chezmoi templates** (OS-specific configs):
```bash
chezmoi apply  # Generates OS-specific files (e.g., update.fish for Arch vs Debian)
```

---

## 💡 KDE Plasma Notes

This repo includes a minimal KDE configuration to restore shortcuts and
window behaviors without copying the full desktop layout.

KDE Files Included

File Purpose

`kglobalshortcutsrc` Global shortcuts (e.g. Meta+T for terminal)
`kwinrc` Window manager behavior and tiling
`plasmarc` General Plasma preferences (animations, etc.)

These are safe to reuse across machines, even between distros.

> ❗️Note: Files like plasma-org.kde.plasma.desktop-appletsrc (taskbar, widgets, etc.)
> are intentionally excluded to avoid screen-specific issues.

---

## 📁 Structure

```
dotfiles/
├── .config/                    # Stowed by GNU Stow
│   ├── fish/
│   │   ├── functions/
│   │   │   ├── chezmoi_tmpl/   # Chezmoi templates (OS-specific)
│   │   │   ├── system.fish
│   │   │   ├── keybindings.fish
│   │   │   └── ...
│   ├── nvim/
│   ├── yazi/
│   ├── rofi/
│   ├── dunst/
│   ├── wlogout/
│   ├── waypaper/
│   └── ...
├── .chezmoi/
│   └── chezmoi.toml           # Chezmoi config (sourceDir = ~/dotfiles)
├── .claude/
│   ├── commands/              # Claude Code commands
│   ├── docs/                  # Documentation
│   └── CLAUDE.md              # Global Claude Code instructions
├── CLAUDE.md                  # Project-specific instructions
├── install.sh                 # Installation script (runs stow + chezmoi)
└── README.md                  # This file
```

## ✅ Restore config safely

If files already exist, remove them first:

```bash
rm ~/.config/kwinrc ~/.config/kglobalshortcutsrc ~/.config/plasmarc
./install.sh
```

The `install.sh` script:
- Runs `stow .config` to create symlinks
- Runs chezmoi to generate OS-specific configs
- Reloads Fish shell configuration

## 🔄 Update workflow

Edit configs directly (they're symlinks managed by stow):
```bash
nvim ~/.config/fish/config.fish  # Edits ~/dotfiles/.config/fish/config.fish
```

Commit and push when ready:
```bash
cd ~/dotfiles
git add -A
git commit -m "update"
git push
```

On another machine:
```bash
cd ~/dotfiles
git pull
./install.sh  # Runs stow + chezmoi apply
```

---

📌 Keep it modular, minimal, and portable.
