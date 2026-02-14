# AGENTS.md

## Project Overview

Personal dotfiles repository using GNU Stow for symlink-based configuration. All configs in `~/dotfiles/.config/` are symlinked to home directory.

**Core technologies:** Fish shell 3.6+, Hyprland (Wayland WM), Neovim, Kitty, Arch Linux (paru/pacman/Flatpak)

## Build, Lint, Test Commands

### Fish Function Testing
```fish
# Syntax check (no shell restart)
fish -n ~/.config/fish/functions/new-function.fish

# Reload all functions without restart
source ~/.config/fish/functions/index.fish

# Test specific function
function-name --help
```

### Run Single Test
```bash
# pnpm (primary for Node.js)
pnpm test <file-or-folder>
pnpm test --filter <package-name>
pnpm test <path> --run

# bun (alternative)
bun test <path> --filter <name>

# npm (fallback)
npm test -- <path>
```

### Install & Updates
```bash
cd ~/dotfiles
./install.sh                    # Initial install
git pull && stow .config .claude # Update
stow --adopt .config .claude     # Force re-symlink (cautious)
```

### Package Management
```bash
paru -Syu              # Update all
paru -S <package>      # Install
flatpak update -y      # Flatpaks
```

## Code Style Guidelines

### Fish Functions

**Naming:** kebab-case, descriptive (e.g., `sv-create`, `gh-finish`)

**Structure:**
```fish
# =============================================================================
# Section header with description
# =============================================================================

function function-name --description 'Brief description'
    # Validate arguments
    if test (count $argv) -eq 0
        echo "Usage: function-name arg1 arg2"
        return 1
    end

    # Error handling with or pattern
    command tool arg || begin
        echo "❌ Error description"
        return 1
    end

    # Success message with emoji
    echo "✅ Operation completed"
end
```

**Error handling:**
- Validate inputs explicitly before processing
- Use `or begin ... return 1 ... end` for command chaining
- Use `command` prefix for external tools (avoid shadowing)
- Check `$status` after commands: `if test $status -ne 0`
- Return 1 on failure (never silent failure)
- Provide clear error messages with emoji indicators

**Documentation:**
- Section headers with `# ===` separators
- Multi-line description comments
- Usage examples inline: `# Usage: function-name arg`
- 2-space indentation throughout

### Bash Scripts

```bash
#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Error: description" >&2
exit 1
```

### Configuration Files

**Stow symlinks:**
- All configs (fish, nvim, kitty, hypr, waybar, etc.) in `~/dotfiles/.config/` → `~/.config/`
- Critical files: `functions/index.fish`, `config.fish`, `conf.d/nvm.fish`, `fish_plugins`, `hypr/hyprland.conf`
- Hyprland: reload avec `Hyprctl reload` ou `super+r`

**Environment variables:**
- Global exports: `set -gx VAR_NAME value` in `conf.d/env.fish`
- User-universal: `set -Ux VAR_NAME value`

### Naming Conventions

**Functions:** kebab-case (`feature-name.fish`, `git.fish`)
**Branches:** `<type>/<issue-#>-<slug>` (e.g., `feat/42-add-alias`)
**Types:** feat, fix, refactor, docs, test, chore, perf, style

**Aliases:** Single-letter shortcuts (`g`, `p`, `z`) or descriptive (`zc`, `ghfinish`)

## Common Function Patterns

**Validation:**
```fish
if test -z "$arg"
    echo "❌ Error: argument required"
    return 1
end

if not test -d "$path"
    echo "❌ Directory not found: $path"
    return 1
end
```

**Command chaining:**
```fish
command tool arg || begin
    echo "❌ Failed to run tool"
    return 1
end
```

**Interactive prompts:**
```fish
read -l -P "Prompt: " answer
if test -z "$answer"
    echo "❌ Input required"
    return 1
end
```

**Loops & Switches:**
```fish
for item in $argv
    # Process item
end

for line in (cat file.txt)
    # Process each line
end

switch $arg
    case pattern1
        # Action 1
    case pattern2
        # Action 2
    case '*'
        echo "❌ Invalid option"
        return 1
end
```

## Testing & Verification

```bash
# Syntax check
fish -n ~/.config/fish/functions/new-function.fish

# Test function
source ~/.config/fish/functions/index.fish
my-function --help

# Install validation
ls -la ~/.config/fish
exec fish
```

## Critical Files (Never Delete)

| File | Reason |
|------|--------|
| `functions/index.fish` | Critical auto-loader - system breaks without it |
| `config.fish` | Main Fish configuration entry point |
| `conf.d/nvm.fish` | NVM initialization for Node.js |
| `fish_plugins` | Plugin declarations for Fish shell |
| `AGENTS.md` | AI agent instructions |

## Function Organization

Files in `functions/` organized by domain:
- **git/** - Git workflows (start, branch, finish, ship, commit)
- **dev.fish** - Web dev (SvelteKit, Go, deployment)
- **system.fish** - System admin (Docker, updates, SSH)
- **media.fish** - Image/video processing (ImageMagick, FFmpeg)
- **ai.fish** - AI tools (n8n, Ollama)
- **editor.fish** - Editor launchers (Neovide, Cursor, Zeditor)
- **python.fish** - Python venv management
- **pnpm.fish** - pnpm aliases
- **utils.fish** - Generic utilities
- **general_shortcut.fish** - Navigation shortcuts

## Package Managers

- **Primary:** pnpm (use `p` alias: `p install`, `p run`, `p test`)
- **Alternative:** bun (for quick installs)
- **System:** paru (Arch, uses pacman under the hood)

## Error Handling Standards

1. Always validate inputs before processing
2. Use explicit error messages with emoji (✅, ❌, ⚠️)
3. Return 1 on failure (never silent failure)
4. Provide actionable feedback
5. Check `$status` after every command
6. Use `or begin ... end` for command chaining
7. Check critical paths exist before processing
