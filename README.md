# My Dotfiles

This repository contains my system configuration files (dotfiles),
organized to be used with [GNU Stow](https://www.gnu.org/software/stow/).

## 🛠 Requirements

Make sure you have the following installed:

### Git

```bash
sudo pacman -S git
```

GNU Stow

```bash
sudo pacman -S stow
```

🚀 Installation

Clone the repository into your $HOME:

```bash
git clone https://github.com/LudoLoops/dotfiles.git
cd dotfiles
```

## 🔗 Symlink your configuration

To apply all configurations using Stow:

```bash
stow .config
```

> This will create symlinks like `~/.config/fish → ~/dotfiles/.config/fish`

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

Typical directory structure:

dotfiles/
├── .config/
│ ├── fish/
│ ├── nvim/
│ ├── kitty/
│ ├── kwinrc
│ ├── kglobalshortcutsrc
│ └── plasmarc
└── README.md

---

## ✅ Restore config safely

If files already exist in ~/.config, remove them first:

```bash
rm ~/.config/kwinrc ~/.config/kglobalshortcutsrc ~/.config/plasmarc
stow .config
```

Or use --adopt (experimental):

```bash
stow --adopt .config
```

---

📌 Keep it modular, minimal, and portable.
