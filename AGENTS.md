# AGENTS.md

## Project Overview

This is a personal **dotfiles repository** that manages your home directory's **.config** directory using GNU Stow for symlink-based configuration distribution.

**How it works:**
- All your dotfiles are in `~/dotfiles/.config/`
- Stow creates symlinks from your home directory to this location
- Your `.config/` folder is a symlink to `~/dotfiles/.config/`

**Core technologies:**
- Fish shell 3.6+ with custom functions and aliases (in your ~/.config/fish/)
- Neovim text editor configuration
- Kitty terminal emulator
- Arch Linux package management (paru, pacman, Flatpak)

## Build, Lint, Test Commands

### Fish Configuration Validation
```fish
# Syntax check without restarting shell
fish -n ~/.config/fish/functions/index.fish

# Reload all functions (no shell restart needed)
source ~/.config/fish/functions/index.fish

# Test specific function
function-name --help
```

### Dotfiles Installation & Updates
```bash
# Initial installation
cd ~/dotfiles && ./install.sh

# Update and apply changes
cd ~/dotfiles && git pull && stow .config .claude

# Force re-symlink (use with caution)
stow --adopt .config .claude
```

### Package Management (Arch Linux)
```bash
# Install packages
paru -Syu              # Update all packages
paru -S <package>      # Install package
flatpak update -y      # Update Flatpaks
```

## Code Style Guidelines

### Fish Functions

**Naming conventions:**
- Use kebab-case: `my-feature.fish`, `dev.fish`
- Descriptive names: `sv-create`, `gh-finish`, `dockcontrol`
- Group by purpose: `git/`, `dev.fish`, `system.fish`

**Function structure:**
```fish
# =============================================================================
# Section header with description
# =============================================================================

# Individual function description
function function-name --description 'Brief description'
    # Validate arguments
    if test (count $argv) -eq 0
        echo "Usage: function-name arg1 arg2"
        return 1
    end

    # Error handling with or pattern
    command tool arg || begin
        echo "Error: Failed to do X"
        return 1
    end

    # Success message with emoji
    echo "✅ Operation completed"
end
```

**Error handling patterns:**
- Validate inputs with explicit checks
- Use `or begin ... return 1 ... end` for command chaining
- Provide clear error messages with `echo "❌ Error description"`
- Exit with `return 1` on errors
- Use `command` prefix for external tools to avoid function shadowing
- Check `$status` after commands: `if test $status -ne 0`

**Documentation in comments:**
- Section headers with `# ===` separators
- Multi-line description comments
- Usage examples inline with `# Usage: function-name arg`
- Maintain consistent formatting with 2-space indentation

### Bash Scripts

**Structure:**
- Shebang with strict mode: `#!/bin/bash` + `set -e`
- Self-reference: `DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"`
- Error messages: `echo "Error: description" >&2`
- Exit codes: `return 1` or `exit 1`

### Configuration Files

**Stow symlinks:**
- All configs must exist in dotfiles directory
- Symlink target: `~/.config/` → `dotfiles/.config/`
- Critical files (never delete): `functions/index.fish`, `config.fish`, `conf.d/nvm.fish`, `fish_plugins`

**Environment variables:**
- Use `set -gx` for global exports in `conf.d/env.fish`
- Use `set -Ux` for user-universal variables
- Format: `set -Ux VAR_NAME value`

## Git Workflow (CRITICAL)

**Branch format:** `<type>/<issue-#>-<slug>`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

**Never commit to main/beta/prod** - always create feature branch first

**Git operations must use slash commands:**
```fish
/git:start 42              # Create branch from issue
/git:branch feat new-thing # Create branch with type
/git:commit "message"      # Stage and commit
/git:finish                # Push, PR, merge, cleanup
```

See `.claude/commands/git/` for available commands.

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

**Command chaining with error handling:**
```fish
command tool arg || begin
    echo "❌ Failed to run tool"
    return 1
end
```

**Interactive prompts:**
```fish
read -l -P "Prompt text: " answer
if test -z "$answer"
    echo "❌ Input required"
    return 1
end
```

**Loop patterns:**
```fish
for item in $argv
    # Process item
end

for line in (cat file.txt)
    # Process each line
end
```

**Switch statements:**
```fish
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

**Fish syntax check:**
```bash
fish -n ~/.config/fish/functions/new-function.fish
```

**Function testing:**
```fish
# Source functions
source ~/.config/fish/functions/index.fish

# Test help
my-function --help

# Test with dummy data
my-function test-value
```

**Install validation:**
```bash
# Check symlinks
ls -la ~/.config/fish

# Reload shell
exec fish
```

## Important Files NOT to Delete

| File | Reason |
|------|--------|
| `functions/index.fish` | Critical function auto-loader - system breaks without it |
| `config.fish` | Main Fish shell configuration entry point |
| `conf.d/nvm.fish` | Node Version Manager initialization |
| `fish_plugins` | Plugin declarations for Fish shell |
| `AGENTS.md` | Project instructions for AI agents |

## Function Organization

Files are organized by domain in `functions/` directory:
- **git/** - Git/GitHub workflows (start, branch, finish, ship, commit)
- **dev.fish** - Web dev (SvelteKit, Go, Cursor, deployment)
- **system.fish** - System admin (Docker, updates, backups, SSH)
- **media.fish** - Image/video processing (ImageMagick, FFmpeg)
- **ai.fish** - AI tools (n8n, Ollama)
- **editor.fish** - Editor launchers (Neovide, Cursor, Zeditor)
- **python.fish** - Python venv management
- **pnpm.fish** - pnpm aliases
- **utils.fish** - Generic utilities
- **general_shortcut.fish** - Navigation shortcuts

## Package Manager Preferences

- **Primary:** `pnpm` (for Node.js packages)
- **Alternative:** `bun` (for quick installs)
- **System:** `paru` (Arch package manager, uses pacman under the hood)

Use `p` alias for pnpm: `p install`, `p run`, `p test`

## Import and Formatting Rules

**Fish functions:**
- No explicit imports needed - auto-loaded by `index.fish`
- Import commands manually if needed: `source /path/to/file.fish`
- Use relative paths for files in dotfiles

**Bash scripts:**
- No module imports
- Shebang must be first line
- Use `set -e` for error propagation

**Configuration files:**
- No imports required
- Keep files minimal and focused
- Use environment variables for configuration values

## Error Handling Standards

1. **Always validate inputs** before processing
2. **Use explicit error messages** with emoji indicators (✅, ❌, ⚠️)
3. **Return 1 on failure** (never silently fail)
4. **Provide actionable feedback** on errors
5. **Check command status** with `$status` after every command
6. **Use `or begin ... end`** for command chaining
7. **Check critical paths** exist before processing (files, directories, git repos)
