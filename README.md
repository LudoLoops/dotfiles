# My Dotfiles

This repository contains my system configuration files (dotfiles) and Claude Code global configurations,
organized to be used with [Chezmoi](https://www.chezmoi.io/).

## 🛠 Requirements

Make sure you have the following installed:

### Git

```bash
sudo pacman -S git
```

Chezmoi

```bash
sudo pacman -S chezmoi
```

🚀 Installation

Clone the repository into your $HOME:

```bash
git clone https://github.com/LudoLoops/dotfiles.git
cd dotfiles
```

## 🔗 Symlink your configuration

To apply all configurations using Chezmoi:

```bash
chezmoi apply
```

This will create symlinks like:
- `~/.config/fish → ~/dotfiles/.config/fish`
- `~/.config/nvim → ~/dotfiles/.config/nvim`
- `~/.config/kitty → ~/dotfiles/.config/kitty`

Chezmoi also handles OS-specific templates for multi-machine configs (Arch/CachyOS vs Debian).

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

```
dotfiles/
├── .config/
│   ├── fish/
│   │   ├── functions/
│   │   │   ├── chezmoi_tmpl/       # Chezmoi templates (OS-specific)
│   │   │   ├── system.fish
│   │   │   ├── keybindings.fish
│   │   │   └── ...
│   ├── nvim/
│   ├── kitty/
│   ├── hypr/
│   └── ...
├── .claude/
│   ├── commands/          # Claude Code commands
│   ├── docs/              # Documentation and guides
│   ├── claude/            # Context files
│   └── CLAUDE.md          # Global Claude Code instructions
├── .chezmoiignore         # Exclude templates from home
├── CLAUDE.md              # Project-specific instructions
├── install.sh             # Installation script
├── README.md              # This file
└── .gitignore             # Git ignore (excludes sensitive Claude files)
```

---

## ✅ Restore config safely

If files already exist, remove them first:

```bash
rm ~/.config/kwinrc ~/.config/kglobalshortcutsrc ~/.config/plasmarc
chezmoi apply
```

Or use the provided install script:

```bash
./install.sh
```

This will:
- Install Chezmoi if needed
- Create symlinks for `.config/` directory
- Generate OS-specific configs (Arch vs Debian)
- Reload Fish shell configuration

---

📌 Keep it modular, minimal, and portable.
