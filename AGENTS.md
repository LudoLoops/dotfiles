# AGENTS.md

Guide for AI agents working on these dotfiles.

## Repository

**GNU Stow-based dotfiles** for Arch Linux / CachyOS + Hyprland (Wayland).
Also deployed on Debian servers (see Multi-OS below).

- **Git root:** `~/dotfiles/`
- **Stow target:** `$HOME` (single package = the whole repo)
- **Install on a new machine:**
  ```bash
  git clone <repo> ~/dotfiles
  cd ~/dotfiles && stow .
  ```
- **After a pull:** `cd ~/dotfiles && stow .` (idempotent — recreates missing links)
- **Re-stow after changing `.stow-local-ignore`:** `stow --restow .`

Stow creates relative symlinks, e.g. `~/.config/fish → ~/dotfiles/.config/fish`,
`~/.bashrc → ~/dotfiles/.bashrc`.

### `.stow-local-ignore`

Excluded from stow: `AGENTS.md`, `CLAUDE.md`, `.git`, `.gitignore`, `.claude`.

> Note: because `AGENTS.md` is ignored by stow, the copy at `~/AGENTS.md`
> (loaded by agents) is **not** auto-synced from the repo. Keep both in sync manually.

## Structure

```
~/dotfiles/                  # git root
├── .config/                 # → ~/.config/
│   ├── fish/                #   shell — config.fish + functions/
│   ├── nvim/                #   editor (LazyVim)
│   ├── hypr/                #   window manager (HyDE)
│   ├── kitty/               #   terminal
│   ├── waybar/              #   status bar
│   ├── yazi/                #   file manager
│   ├── zed/ zellij/ tmux/
│   ├── starship/ btop/ rofi/ dunst/ …
│   └── CLAUDE.md            #   component-level guide
├── .local/bin/              # → ~/.local/bin/
├── .bashrc                  # → ~/.bashrc
└── .stow-local-ignore
```

Each major component may have its own `CLAUDE.md` (e.g. `.config/fish/CLAUDE.md`,
`.config/hypr/CLAUDE.md`) — consult those when working on a specific area.

## System

- **OS:** Arch Linux / CachyOS (desktop), Debian (servers)
- **WM:** Hyprland (Wayland), HyDE integration
- **Shell:** Fish 4.x with Starship prompt
- **Editor:** Neovim (LazyVim)
- **Terminal:** Kitty
- **Package manager:** paru (AUR + pacman) on Arch, apt on Debian

## Fish

- **Entry:** `.config/fish/config.fish`
- **Functions:** `.config/fish/functions/` — auto-loaded by `index.fish`,
  which sources every `.fish` file including subdirs (`git/`, `fzf/`).
- **Do not delete `index.fish`** — it is the loader for the whole function system.
- **Add a function:** drop a `.fish` file in `functions/`; it loads on next shell start.
- **Multi-OS update:** the `update` function auto-detects the OS via `/etc/os-release`
  and runs the right command (paru + paccache on Arch, apt on Debian).
  No templates, no per-OS files — detection is inline.

## Conventions

**Fish functions:**
- `command` prefix for external tools
- Validate args: `test -z "$arg"`
- Error handling: `|| begin ... end`
- Emoji for feedback: ✅ ❌ 📦

**Neovim:** Lua, Lazy.nvim, follow LazyVim conventions.

**Git:** work from `~/dotfiles/`, conventional commits `type: description`.
Never leave uncommitted changes.

## Files excluded from git (secrets / machine-specific)

From `.gitignore`:

| Pattern | Reason |
|---------|--------|
| `fish/fish_variables` | API keys (universal fish vars) |
| `fish/conf.d/` | Env vars with secrets |
| `.config/kwinrc`, `.config/kxkbrc`, `.config/plasmarc` | Machine-specific |

Do not read or commit these.

## Common commands

| Task | Command |
|------|---------|
| Reload Fish | `source ~/.config/fish/config.fish` |
| Reload Hyprland | `hyprctl reload` |
| System update | `update` (auto-detects OS) |
| Neovim plugins | `:Lazy` inside Neovim |
| Smart cd | `z <dir>` (zoxide) |
| Syntax-check a fish function | `fish -n ~/.config/fish/functions/<fn>.fish` |

## Architecture notes

- **Modular sourcing:** Hyprland `hyprland.conf` sources `keybindings.conf`,
  `windowrules.conf`, `monitors.conf`, `config/*.conf`. Waybar includes
  `modules/` and `includes/`. Fish `config.fish` sources `functions/index.fish`.
  This keeps configs split by concern rather than monolithic.
- **HyDE:** the marker `$HYDE_HYPRLAND=set` in `hyprland.conf` prevents HyDE
  from overwriting user configs. Preserve it.
