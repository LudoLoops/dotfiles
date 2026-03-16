# My Dotfiles

This repository contains my system configuration files (dotfiles).

**Setup:** GNU Stow for symlinks only. Git repo is in `.config/`.

## 🛠 Requirements

**GNU Stow** (for symlinks):
```bash
sudo pacman -S stow  # Arch
sudo apt install stow  # Debian
```

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/LudoLoops/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .config
```

## 🔗 How it works

GNU Stow creates symlinks:
```bash
cd ~/dotfiles
stow .config  # Creates all .config symlinks
```

Result:
```bash
~/.config/fish → ~/dotfiles/.config/fish
~/.config/nvim → ~/dotfiles/.config/nvim
~/.config/yazi → ~/dotfiles/.config/yazi
```

## 📁 Structure

```
~/dotfiles/
└── .config/              # Git repo root (.git is here)
    ├── fish/             # Shell functions, config
    ├── nvim/             # Neovim config
    ├── yazi/             # File manager
    ├── hypr/             # Hyprland WM
    ├── waybar/           # Status bar
    └── ...
```

## 🔄 Update workflow

Edit configs directly (they're symlinks):
```bash
nvim ~/.config/fish/config.fish  # Edits ~/dotfiles/.config/fish/config.fish
```

Commit and push:
```bash
cd ~/dotfiles
git add -A
git commit -m "update"
git push
```

---

📌 Keep it modular, minimal, and portable.
