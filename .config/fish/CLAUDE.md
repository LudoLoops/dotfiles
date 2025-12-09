# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal **Fish shell configuration repository** - a curated collection of custom functions, aliases, and configuration for optimized developer productivity. It's designed specifically for full-stack web development with SvelteKit, Python, Node.js, and system administration tasks.

## Repository Structure

```
fish/
├── config.fish                   # Main entry point, aliases, env vars, PATH setup
├── functions/
│   ├── index.fish              # Auto-loader for all functions (DO NOT DELETE)
│   ├── sv-create.fish          # SvelteKit project scaffolder
│   ├── git.fish                # Git shortcuts and workflows
│   ├── python.fish             # Python venv management
│   ├── general_shortcut.fish   # Quick navigation (zc, zz, update, backup)
│   └── [13 other specialized function files]
├── conf.d/
│   ├── env.fish                # Environment variable setup
│   └── nvm.fish                # Node Version Manager initialization
├── completions/                # NVM shell completions
├── fish_plugins                # Plugin declarations (NVM)
└── fish_variables              # Persistent variable state
```

## Key Concepts

### Automatic Function Loading

The `functions/index.fish` file automatically sources all `.fish` files in the `functions/` directory at shell startup. **Do not modify or delete `index.fish`** as it's critical to the entire system. When adding new functions:

1. Create a new `.fish` file in the `functions/` directory
2. It will be automatically loaded on next shell startup
3. No need to manually import or source anything

### Configuration Flow

1. **config.fish** is sourced first
2. **functions/index.fish** is called, which dynamically loads all function files
3. **conf.d/** files are applied (environment variables, NVM, etc.)
4. Tools like Starship and Zoxide are initialized

## Common Development Tasks

### Adding a New Function

1. Create a file in `functions/` with descriptive naming: `feature-name.fish`
2. Write the function following existing patterns (error handling, comments)
3. Test by opening a new shell or running `source functions/feature-name.fish`

### Testing Functions Interactively

```fish
# Reload all functions without restarting shell
source functions/index.fish

# Test a specific function
function-name --help
```

### Editing Aliases or Configuration

- **Shell aliases and abbreviations**: Edit `config.fish`
- **Environment variables**: Edit `conf.d/env.fish`
- **Exported global settings**: Edit `config.fish` (use `set -gx` for global export)

## Project Organization Principles

1. **Modular by purpose**: Each `.fish` file groups related functions (e.g., `git.fish` for git operations, `python.fish` for Python utilities)
2. **Abbreviations for speed**: Single-letter shortcuts for common commands (`g` for git, `p` for pnpm, `z` for zoxide)
3. **Error handling**: Functions validate inputs and provide helpful error messages
4. **Smart automation**: Auto-activation of Python venvs, automatic tool initialization

## Important Functions & Their Locations

| Function | File | Purpose |
|----------|------|---------|
| `sv-create` | dev.fish | Scaffold SvelteKit projects with TS, Tailwind, Skeleton UI |
| `git` aliases | git.fish | Fast git workflows (commit, compush, ghfinish) |
| `auto_activate_venv` | python.fish | Auto-activate Python virtual env on directory change |
| `zc` / `zz` | general_shortcut.fish | Quick editor shortcuts with zoxide |
| `mkroute` | dev.fish | Scaffold Svelte route files |
| `docker` control | dockcontrol.fish | Docker container management |
| `ship` / `ship-beta` / `ship-prod` | dev.fish | Automated deployment pipeline (beta & prod) |

## Deployment Pipeline (`ship` Command)

The `ship` function automates the entire deployment pipeline (beta & production) with zero Claude involvement needed.

### Usage

**From main branch (development):**
```bash
ship              # Deploy to beta only (default)
ship beta         # Explicitly deploy to beta
ship prod         # Full pipeline: main → beta → prod
ship-beta         # Alias for `ship beta`
ship-prod         # Alias for `ship prod`
```

**From beta branch (staging):**
```bash
ship              # Deploy to prod only (default)
ship prod         # Explicitly deploy to prod
ship-prod         # Alias
```

### Features

- ✅ Automatically detects current branch and chooses appropriate target
- ✅ Bumps version (patch) only when deploying to beta
- ✅ Validates clean working directory before deployment
- ✅ Handles merge conflicts gracefully
- ✅ Returns to main branch after deployment
- ✅ Works for any project with `package.json` and git repository
- ✅ No hardcoded project names (fully generic)

### Typical Workflow

```bash
# 1. Work on main, test locally
git checkout main

# 2. Deploy to beta (bumps version patch automatically)
ship
# Or explicitly: ship beta

# 3. Test changes in beta environment

# 4. Deploy to prod (from beta)
ship
# Or explicitly: ship prod

# 5. After testing, push to prod
# (if using full pipeline) ship prod  # From main
```

### What It Does (Step by Step)

**`ship beta` (from main):**
1. Verify working directory is clean
2. Fetch latest from remote
3. Bump version (patch)
4. Push version bump to main
5. Merge main into beta
6. Push to beta (triggers auto-deploy)
7. Return to main

**`ship prod` (from main):**
1. Same as above for beta
2. Then merge beta into prod
3. Push to prod (triggers auto-deploy)

**`ship` (from beta):**
1. Verify working directory is clean
2. Fetch latest from remote
3. Merge beta into prod
4. Push to prod (triggers auto-deploy)
5. Return to main

## Git Workflow

This repository follows the global CLAUDE.md git conventions from `/home/loops/.claude/CLAUDE.md`:

- **Conventional commits**: `<type>: <subject>` format
- **Branches**: Feature branches only, never commit to main
- **Branch format**: `<type>/<issue-#>-<slug>` (e.g., `feat/issue-1-add-new-alias`)

## Development Tools & Environment

### Installed Tools
- **Editor**: Neovide (set as EDITOR and VISUAL)
- **Terminal**: Kitty (TERM=xterm-kitty)
- **Prompt**: Starship
- **Directory navigation**: Zoxide (`z` command)
- **File listing**: Eza (`ls`, `ll`, `la` aliases)
- **File preview**: Bat (`cat` alias, manpage viewer)
- **Fuzzy finder**: Fzf (with custom options for Eza preview)
- **Node version manager**: NVM (jorgebucaran/nvm.fish plugin)
- **Package manager**: pnpm (primary)

### Critical Environment Variables
- `EDITOR=neovide` / `VISUAL=neovide`
- `TERM=xterm-kitty`
- `PIP_REQUIRE_VIRTUALENV=true` (enforces venv for pip installs)
- `MANPAGER="bat"` (enhanced manual pages)
- `GEMINI_API_KEY` (configured in conf.d/env.fish)

### PATH Additions
- `~/.npm-global/bin` (global npm packages)
- `~/.local/bin` (custom scripts)
- `~/Applications` (custom applications)
- `~/Applications/depot_tools` (Chromium tools)
- `~/.bun/bin` (Bun package manager)
- `~/.lmstudio/bin` (Local LM Studio)
- `~/.volta/bin` (Node toolchain)
- pnpm home directory

## Conventions & Best Practices

### Function Guidelines

1. **Use descriptive names**: Avoid single-letter function names (aliases are different)
2. **Include error handling**: Check for missing dependencies or invalid input
3. **Provide help/usage**: Use `--help` or comment with examples
4. **Example pattern**:
   ```fish
   function my-feature
       if not type -q required_tool
           echo "Error: required_tool not installed"
           return 1
       end
       # ... rest of function
   end
   ```

5. **Use `command` for external tools**: Prevents function shadowing
   - `command ls` instead of `ls` (to use the actual command, not alias)

### Alias Conventions

- Single-letter shortcuts for very common commands (`g`, `p`, `z`)
- Descriptive names for less-frequent operations (`zc` for Cursor + zoxide)
- No more than 2-3 levels of abbreviation
- Related aliases grouped together in `config.fish`

### Directory Abbreviations

Already implemented:
- `..` → go up one level
- `...` → go up two levels
- `.3`, `.4`, `.5` → go up 3/4/5 levels

## Important Files NOT to Delete

- **functions/index.fish** - Critical function loader
- **config.fish** - Main configuration entry point
- **conf.d/nvm.fish** - NVM initialization (needed for Node.js development)
- **fish_plugins** - Plugin declarations

## Extending for New Development Domains

When adding support for a new technology:

1. Create a new `.fish` file: `feature-domain.fish`
2. Add functions and aliases following existing patterns
3. If configuration is needed, add to `conf.d/` directory
4. Document in this CLAUDE.md under the relevant section
5. Keep related functionality together (don't scatter functions across files)

## Testing & Verification

### Quick validation
```fish
# Source without restarting shell
source config.fish

# Check for function syntax errors
fish -n functions/new-function.fish
```

### Common issues
- **Function not found**: Ensure `source functions/index.fish` is called in config.fish
- **Aliases not working**: Check that `config.fish` has sourced properly
- **Tool not found**: Verify tool is in PATH (check `which toolname`)
