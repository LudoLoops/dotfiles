# My Dotfiles

This repository contains my system configuration files (dotfiles) and Claude Code global configurations.

**Setup:** GNU Stow for symlinks only.

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

---

## 📁 Structure

```
dotfiles/
├── .config/                    # Stowed by GNU Stow
│   ├── fish/
│   │   ├── functions/
│   │   │   ├── system.fish     # System utilities (auto-detects OS)
│   │   │   ├── keybindings.fish
│   │   │   ├── update.fish     # Multi-OS system update
│   │   │   └── ...
│   ├── nvim/
│   ├── yazi/
│   ├── rofi/
│   ├── dunst/
│   ├── wlogout/
│   ├── waypaper/
│   └── ...
├── .claude/
│   ├── commands/              # Claude Code commands
│   ├── docs/                  # Documentation
│   └── CLAUDE.md              # Global Claude Code instructions
├── CLAUDE.md                  # Project-specific instructions
├── install.sh                 # Installation script (runs stow)
└── README.md                  # This file
```

## ✅ Restore config safely

If files already exist, remove them first:

```bash
rm ~/.config/<conflicting_file>
./install.sh
```

The `install.sh` script:
- Runs `stow .config` to create symlinks
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
./install.sh  # Runs stow to create symlinks
```

---

📌 Keep it modular, minimal, and portable.
