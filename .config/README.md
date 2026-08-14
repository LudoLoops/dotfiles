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

## 🔤 Spell check FR (Zed / cspell)

Le spell-check FR de Zed (extension cspell) nécessite le dictionnaire français,
installé **par machine** via bun (il n'est pas dans le repo) :

```bash
bun add -g @cspell/dict-fr-fr
```

La config `.config/cspell/cspell.json` (stowée) pointe vers ce dico et désactive
le `caseSensitive` (sinon "Tous", "Aucune"... ne sont pas reconnus).

⚠️ **Zed en SSH remote** : les LSP (dont cspell) tournent **sur le serveur distant**,
pas en local. Le dico et la config doivent donc être installés sur la machine distante
(aether inclus).

Après installation ou changement de config : redémarrer Zed (le LSP charge la config
au démarrage uniquement).

---

📌 Keep it modular, minimal, and portable.

## 🎨 Raccourcis WezTerm (thèmes)

| Raccourci | Action |
|---|---|
| `Ctrl+Shift+J/K` | Thème WezTerm suivant/précédent (aperçu live) |
| `Ctrl+Shift+U` | Fuzzy-search de tous les thèmes |
| `Ctrl+Shift+L` | Skin Hermes **light** (`warm-lightmode`) |
| `Ctrl+Shift+D` | Skin Hermes **dark** (`slate`) |

`palette-preview` (fish) affiche le thème courant + les 16 couleurs ANSI.
