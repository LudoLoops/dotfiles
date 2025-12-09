# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal **dotfiles repository** containing system configuration files for a Linux development environment (Arch Linux). The repository is managed with [GNU Stow](https://www.gnu.org/software/stow/) for easy symlink-based installation across machines.

**Key focus areas:**
- Fish shell configuration and custom functions
- Development tools (Neovim, Kitty terminal, Starship prompt)
- Developer productivity utilities and automation

## Repository Structure

```
dotfiles/
├── .config/
│   ├── fish/                        # Fish shell configuration
│   │   ├── config.fish              # Main entry point, aliases, env vars
│   │   ├── conf.d/                  # Auto-loaded config files
│   │   │   ├── env.fish             # Environment variables
│   │   │   └── nvm.fish             # Node Version Manager init
│   │   ├── functions/               # Auto-loaded Fish functions
│   │   │   ├── index.fish           # CRITICAL: auto-loader (DO NOT DELETE)
│   │   │   ├── git.fish             # Git workflows and GitHub commands
│   │   │   ├── dev.fish             # Web dev (SvelteKit, Go, Cursor)
│   │   │   ├── system.fish          # System admin (Docker, updates, SSH)
│   │   │   ├── media.fish           # Media processing (images, video)
│   │   │   ├── ai.fish              # AI tools (n8n, Ollama)
│   │   │   ├── editor.fish          # Editor launchers (Neovide)
│   │   │   ├── python.fish          # Python venv management
│   │   │   ├── pnpm.fish            # pnpm package manager aliases
│   │   │   ├── utils.fish           # Generic utilities (!! and !$)
│   │   │   └── general_shortcut.fish # Quick navigation shortcuts
│   │   ├── completions/             # Shell completions
│   │   └── fish_plugins             # Plugin declarations (NVM)
│   ├── nvim/                        # Neovim configuration
│   └── kitty/                       # Kitty terminal configuration
├── install.sh                       # Package installation script
├── README.md                        # User-facing documentation
└── CLAUDE.md                        # This file
```

## Critical Components

### Function Loading (`functions/index.fish`)

**CRITICAL:** The `functions/index.fish` file dynamically loads all `.fish` files in the `functions/` directory at shell startup.

- **⚠️ DO NOT delete or significantly modify `index.fish`**
- All new functions are automatically loaded by this mechanism
- No manual sourcing is needed for new function files
- System will break without it

### Configuration Flow

```
1. config.fish              ← Entry point, aliases, env vars, PATH setup
2. functions/index.fish     ← Auto-loads all function files
3. conf.d/                  ← Environment variables, NVM initialization
4. Tools init               ← Starship, Zoxide, Fzf auto-initialization
```

### Function Organization

Functions are organized by purpose in separate files (all in `functions/`):

- **git.fish** (266 lines) - Git/GitHub workflows
  - `gh-start`, `gh-branch`, `gh-pr`, `gh-finish` - GitHub issue workflows
  - `commit`, `compush` - Conventional commits
  - `gh-labels-init` - Initialize standard labels
  - Aliases: `g`, `addup`, `addall`, `branch`, `checkout`, `clone`, `fetch`, `pull`, `push`

- **dev.fish** (675 lines) - Web development & deployment
  - `sv-create` - SvelteKit project scaffolder (TS, pnpm, Tailwind, Skeleton UI, tests)
  - `mkroute` - SvelteKit route creator
  - `go-build-multi` - Multi-platform Go builds (Linux, Windows, macOS)
  - `cursor-rules` - Cursor IDE rule linker
  - `smart-branch` - Deterministic branch creation with validation
  - `check-quality` - Code validation (TypeScript, ESLint, tests)
  - `ship`, `ship-beta`, `ship-prod` - Automated deployment pipeline (beta & production)

- **system.fish** (108 lines) - System administration
  - `dockcontrol` - Docker/Docker Compose management (start, stop, restart)
  - `zc`, `zz` - Zoxide + editor navigation shortcuts
  - `update` - Arch Linux and Flatpak package updates
  - `backup` - File backup creator (.bak extension)
  - `y` - Yazi file manager integration
  - `tpm-ssh-init` - SSH agent initialization

- **media.fish** (220 lines) - Image/video processing
  - `imgResize` - Image resizing with ImageMagick
  - `image-reduce` - Batch JPG to WebP conversion with backups
  - `toWebp` - Individual file WebP conversion
  - `convert_to_Davinci` - Video to DaVinci Resolve format (ProRes)
  - `rename_md_to_svx` - Markdown to SvelteKit format conversion

- **Other specialized files:**
  - **ai.fish** - n8n workflow automation and Ollama LLM server management
  - **editor.fish** - Nvim terminal editor launcher
  - **python.fish** - Python venv auto-activation on directory change
  - **utils.fish** - Generic utilities (bash history support !! and !$)
  - **pnpm.fish** - pnpm aliases: `p`, `pdx` (dlx), `pex` (exec)
  - **general_shortcut.fish** - Quick navigation and shortcuts

## Development Conventions

### Package Management

- **Primary:** `pnpm` (not npm or yarn)
- Aliases: `p` (pnpm), `pdx` (pnpm dlx), `pex` (pnpm exec)
- See `~/.claude/CLAUDE.md` for global conventions

### Git Workflow

Standard branch format: `<type>/<issue-#>-<slug>`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`
- Examples: `feat/42-add-auth`, `fix/15-button-alignment`

Conventional commits:
```fish
commit feat: add user authentication
compush fix: resolve login timeout
```

See `git.fish` for all available commands (`gh-start`, `gh-branch`, `gh-pr`, `gh-finish`).

### Adding New Functions

1. Create a new `.fish` file in `functions/` directory
2. Write the function with clear documentation
3. It's automatically loaded on next shell startup
4. No need to manually update `index.fish`

**Example:**
```fish
# functions/my-feature.fish
function my-command --description "Brief description"
    # Implementation here
end
```

## Common Development Commands

### Fish Configuration

```fish
# Reload all functions without restarting shell
source ~/.config/fish/functions/index.fish

# Check for syntax errors in a file
fish -n ~/.config/fish/functions/dev.fish

# Test a specific function
function-name --help
```

### Code Quality (Web Projects)

```fish
# Run all checks (TypeScript, ESLint, tests)
check-quality

# Individual checks (when using pnpm)
p check          # TypeScript
p exec eslint    # Linting
p test           # Tests
```

### Git Workflow

```fish
# Create branch from issue
gh-start 42

# Or quick manual branch
smart-branch feat 42

# Make changes, then commit
commit feat: add new feature

# Commit and push together
compush feat: add new feature

# Create PR (auto-closes issue)
gh-pr

# Merge and cleanup
gh-finish
```

### SvelteKit Development

```fish
# Create new SvelteKit project (full setup)
sv-create my-app

# Create new routes in existing project
mkroute src/routes/dashboard
mkroute src/routes/settings src/routes/profile
```

### Automated Deployment Pipeline

The `ship` command automates all deployment steps (version bump, merges, auto-deploy). Works for any project with `package.json` and git repository:

```fish
# From main branch (development)
ship              # Deploy to beta only (default)
ship beta         # Explicitly deploy to beta (bumps version patch)
ship prod         # Full pipeline: main → beta → prod
ship-beta         # Alias for `ship beta`
ship-prod         # Alias for `ship prod`

# From beta branch (staging)
ship              # Deploy to prod only (default)
ship prod         # Explicitly deploy to prod
```

**Key features:**
- Automatically detects branch and chooses appropriate target
- Bumps version (patch) only when deploying to beta
- Validates clean working directory before deployment
- Handles merge conflicts gracefully
- Returns to main branch after deployment
- Works for any project (no hardcoding)

**Typical workflow:**
```fish
git checkout main
ship              # Deploy to beta (bumps version)
# ... test in beta ...
ship prod         # Deploy to prod (full pipeline: beta → prod)
```

### Media Processing

```fish
# Resize images to 1280px width
imgResize 1280

# Convert images to WebP
toWebp

# Batch convert JPG to WebP with backup
image-reduce

# Convert video to DaVinci Resolve format
convert_to_Davinci input.mov
```

## Environment Variables

**Key variables set in config.fish:**

- `EDITOR=nvim` - Terminal text editor
- `VISUAL=nvim` - Terminal visual editor
- `TERM=xterm-kitty` - Terminal type for Kitty
- `PIP_REQUIRE_VIRTUALENV=true` - Enforce Python venv usage
- `MANPAGER="bat"` - Enhanced manual pages

**PATH additions:**
- `~/.npm-global/bin` - Global npm packages
- `~/.local/bin` - Custom scripts
- `~/Applications` - Custom applications
- `~/Applications/depot_tools` - Chromium tools (conditional)
- `~/.bun/bin` - Bun package manager
- `~/.volta/bin` - Node toolchain
- pnpm home directory

## Installation & Maintenance

### First-time setup:

```bash
cd ~/dotfiles
stow .config              # Creates symlinks in ~/.config
# May need to remove existing files first if they conflict
```

### Stow workflow:

- `stow .config` - Create symlinks for all configs in ~/.config
- `stow --adopt .config` - Experimental: adopt existing files (use with caution)
- Multiple calls to stow different folders work fine

### When updating Fish functions:

1. Edit the desired `.fish` file in `functions/` directory
2. Test syntax: `fish -n filename.fish`
3. Reload without restarting: `source ~/.config/fish/functions/index.fish`
4. Test the function: `function-name --help`
5. Commit changes

### When adding a new Fish function:

1. Create new `.fish` file in `functions/` (e.g., `functions/my-feature.fish`)
2. Write the function with clear documentation in comments
3. No need to modify `index.fish` - it auto-loads new files
4. Test and commit

### Expanding to other config folders:

```bash
# For Neovim
stow .config

# For Kitty (same command, already in .config)
stow .config

# Individual stow is optional - one command handles all in .config/
```

## Important Files NOT to Delete

- **functions/index.fish** - ⚠️ CRITICAL: Function auto-loader (system breaks without it)
- **config.fish** - Main Fish configuration entry point
- **conf.d/nvm.fish** - Node Version Manager initialization
- **fish_plugins** - Plugin declarations

## Reference Documentation

- **Fish functions reference:** `~/.claude/docs/fish-dev-functions.md` (global)
- **Commands optimization:** `~/.claude/docs/commands-optimization.md` (global)
- **Git workflow & branching:** `~/.claude/GIT_WORKFLOW.md` (global standard)
- **Global conventions:** `~/.claude/CLAUDE.md` (global)
- **Project README:** `README.md` (this repository)

## Related Technologies

- **Fish Shell** - 3.6+ (interactive shell)
- **GNU Stow** - Configuration symlink manager
- **Neovim** - Text editor
- **Kitty** - GPU-accelerated terminal emulator
- **Starship** - Cross-shell prompt
- **Zoxide** - Smart directory navigation (`z` command)
- **Fzf** - Fuzzy finder
- **Bat** - Better cat with syntax highlighting
- **Eza** - Better ls replacement
- **NVM** - Node Version Manager (auto-initialized via nvm.fish)
- **pnpm** - Fast, reliable package manager
- **Arch Linux** - Operating system (target platform)
