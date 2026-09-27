# AGENTS.md

Guide for AI agents working on these dotfiles.

## Repository

GNU Stow-based dotfiles for **tuftux** (Arch Linux / CachyOS + Hyprland).

- **Git root:** `~/dotfiles/`
- **Stow target:** `$HOME`
- **Single Stow package:** the repository root
- **Install:** `cd ~/dotfiles && stow .`
- **After a pull:** `cd ~/dotfiles && stow --restow .`

Stow creates relative symlinks into `$HOME`. `AGENTS.md` itself is intentionally
stowed to `~/AGENTS.md`, so the repository copy is the source of truth.

### Files intentionally not stowed

See `.stow-local-ignore`. Notable entries:

- `.config/mango/` — legacy compositor config kept only as a backup
- `.pi/agent/settings.json` — machine-specific Pi settings
- Herdr runtime/session/plugin state
- Git metadata and local tool runtime directories

## Current desktop

- **OS:** Arch Linux / CachyOS
- **WM:** Hyprland
- **Desktop shell:** DMS (DankMaterialShell)
- **Shell:** Fish 4.x + Starship
- **Editor:** Neovim / LazyVim
- **Terminals:** Kitty and WezTerm configs are tracked
- **Package manager:** paru
- **File manager:** Yazi

DMS owns desktop-shell concerns such as the bar, notifications, wallpaper, lock/idle,
and related desktop UI. Waybar, HyDE, Dunst, Niri, and Zellij are no longer part of
the active setup.

## Structure

```
~/dotfiles/
├── .config/
│   ├── fish/          # shell config + functions
│   ├── hypr/          # Hyprland + DMS integration
│   ├── kitty/         # Kitty
│   ├── wezterm/       # WezTerm
│   ├── nvim/          # LazyVim
│   ├── starship/      # prompt
│   ├── btop/          # system monitor
│   ├── yazi/          # file manager
│   ├── zed/           # editor config
│   └── mango/         # legacy backup, ignored by Stow
├── .local/bin/
├── .bashrc
├── AGENTS.md
└── .stow-local-ignore
```

Component-specific guidance may exist in nested `AGENTS.md` files, notably
`.config/hypr/AGENTS.md` and `.config/zed/AGENTS.md`.

## Fish

- Entry point: `.config/fish/config.fish`
- Functions: `.config/fish/functions/`
- `functions/index.fish` sources the function tree, including subdirectories.
- Do not remove `index.fish`.
- Add new functions as individual `.fish` files.
- `update.fish` orchestrates machine updates using `.config/fish/servers.json`.
- `update` updates every enabled host; `update --host <name>` targets one host.
- `update --refresh` refreshes the inventory from Tailscale while preserving existing
  `ignore` choices and manually retained hosts. Newly discovered peers are ignored by default.
- OS detection happens at update time, not in the inventory. Arch/CachyOS/Manjaro,
  Debian/Ubuntu, and NixOS are supported.

## Hyprland / DMS

- Main config: `.config/hypr/hyprland.lua`
- DMS fragments: `.config/hypr/dms/*.lua`
- User overrides: `.config/hypr/dms/binds-user.lua`
- Generated DMS files such as colors are intentionally ignored by Git.
- Legacy Mango behavior is documented where it explains current Hyprland binds,
  but `.config/mango/` itself is not active.

After Hyprland changes:

```bash
Hyprland --verify-config
hyprctl reload
```

## Conventions

**Fish**
- Prefer `command` for external commands.
- Validate arguments.
- Handle command failures explicitly.

**Neovim**
- Lua + Lazy.nvim; follow LazyVim conventions.

**Git**
- Work from `~/dotfiles/`.
- Use conventional commits: `type: description`.
- Keep changes focused.
- Do not leave intended repository changes uncommitted.

## Secrets and machine-specific state

Do not commit runtime state, credentials, caches, histories, sessions, generated
machine-specific files, or secrets.

Important ignored paths include:

- `.config/fish/fish_variables`
- `.config/fish/conf.d/`
- `.config/kwinrc`, `.config/kxkbrc`, `.config/plasmarc`
- Herdr runtime/session/plugin files
- DMS-generated color files
- local backup files
- `.pi/agent/settings.json`

## Common commands

| Task | Command |
|---|---|
| Restow dotfiles | `cd ~/dotfiles && stow --restow .` |
| Reload Fish | `source ~/.config/fish/config.fish` |
| Verify Hyprland | `Hyprland --verify-config` |
| Reload Hyprland | `hyprctl reload` |
| Update all enabled machines | `update` |
| Update only tuftux | `update --local` |
| Update one machine | `update --host <name>` |
| Refresh machine inventory | `update --refresh` |
| List machine inventory | `update --list` |
| Neovim plugins | `:Lazy` |
| Smart cd | `z <dir>` |
| Check Fish syntax | `fish -n ~/.config/fish/functions/<fn>.fish` |
