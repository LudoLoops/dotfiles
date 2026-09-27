# Dotfiles

Dotfiles for **tuftux**, managed with GNU Stow.

## Setup

The Git repository lives at `~/dotfiles` and is stowed as a single package into
`$HOME`.

```bash
git clone https://github.com/LudoLoops/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

After pulling changes:

```bash
cd ~/dotfiles
stow --restow .
```

Files listed in `.stow-local-ignore` stay in the repository but are not deployed.
This is used notably for the legacy Mango configuration.

## Current desktop

- Arch Linux / CachyOS
- Hyprland
- DMS (DankMaterialShell) for the desktop shell
- Fish + Starship
- Neovim / LazyVim
- Kitty and WezTerm
- Yazi
- paru

HyDE, Waybar, Dunst, Niri, Zellij, Waypaper, Wlogout and Oh My Posh are no longer
part of the active setup.

## Main configuration

```text
.config/
├── fish/          shell config and functions
├── hypr/          Hyprland + DMS integration
├── kitty/         Kitty
├── wezterm/       WezTerm
├── nvim/          LazyVim
├── starship/      prompt
├── btop/          system monitor
├── yazi/          file manager
├── zed/           editor config
└── mango/         legacy backup, ignored by Stow
```

Repository guidance for coding agents lives in `AGENTS.md`. Component-specific
guidance may live in nested `AGENTS.md` files.

## Workflow

Edits made through the stowed paths modify the repository files directly.

```bash
nvim ~/.config/fish/config.fish
cd ~/dotfiles
git status
git diff
git add -A
git commit -m "type: description"
git push
```

## Zed / cspell French dictionary

The French cspell dictionary is installed per machine:

```bash
bun add -g @cspell/dict-fr-fr
```

The tracked `.config/cspell/cspell.json` points to that dictionary. When Zed runs
against a remote machine, cspell and its dictionary must also exist on that remote
machine.

## WezTerm theme shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+J/K` | Next / previous WezTerm theme |
| `Ctrl+Shift+U` | Fuzzy-search themes |
| `Ctrl+Shift+L` | Hermes light skin (`warm-lightmode`) |
| `Ctrl+Shift+D` | Hermes dark skin (`slate`) |

`palette-preview` in Fish shows the current palette and ANSI colors.
