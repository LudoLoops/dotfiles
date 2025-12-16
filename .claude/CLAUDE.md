# Global CLAUDE.md

Global guidance for Claude Code across all projects.

## 🚀 Quick Start

**Always use `pnpm` (never npm or yarn)**

```bash
pnpm install          # Install dependencies
pnpm add <package>    # Add package
pnpm add -D <package> # Add dev dependency
pnpm dev              # Start dev server
pnpm test             # Run tests
pnpm build            # Build
```

## ⚠️ CRITICAL RULES - ZERO EXCEPTIONS

**These rules MUST be followed without exception. Failure is not acceptable.**

1. **🚫 NEVER COMMIT TO MAIN/BETA/PROD**
   - ALWAYS create a feature branch FIRST before ANY file changes
   - Format: `<type>/<issue-#>-<slug>` (e.g., `feat/113-fix-changelog`)
   - If you find yourself on main/beta/prod: STOP, create branch, cherry-pick changes

2. **🔒 PROTECTED BRANCHES ARE SACRED**
   - main, beta, prod are read-only
   - Only way to change them: PR → Review → Merge via GitHub
   - NO exceptions for "quick fixes" or "small changes"

3. **📋 ALWAYS CREATE A BRANCH BEFORE EDITING ANY FILES**
   - This is the first step, before anything else
   - Check current branch: `git branch`
   - If on main/beta/prod: `git checkout -b <new-branch>`

## 🎯 Key Principles

1. **pnpm everywhere** - Never npm or yarn
2. **Read project CLAUDE.md** - Each project may have specific guidance
3. **Use existing scripts** - Check `package.json` first
4. **Edit existing files** - Create new only if necessary
5. **No `any` in TypeScript** - Create proper type interfaces
6. **Console.log in dev only** - Guard logs for development visibility
7. **Skeleton without dark** - Use 100-900 scale instead of dark variants

## 📝 Git Workflow

### Branches

Format: `<type>/<issue-#>-<slug>`

Types: `feat/`, `test/`, `docs/`, `bug/`, `refactor/`

Example: `feat/issue-11-margin-calculations`

### Commits & Issues

**All issues and commits must be in English**

Format: Conventional Commits

```
<type>: <subject (imperative, lowercase, no period)>

<body (wrap at 100 chars, explain why not what)>

Closes #<issue-number>
```

### Non-negotiable Rules

- 🚫 **NEVER commit to main, beta, or prod** - Zero exceptions, always use feature branches
- 🚫 **NEVER edit files while on main, beta, or prod** - Create branch FIRST
- ✅ Always create feature branch BEFORE making ANY changes
- ✅ Always reference issue in commits (`Closes #11`)
- ✅ One issue per branch
- ✅ Tests must pass: `pnpm test`
- ✅ Code must be formatted: `pnpm format`
- ✅ TypeScript must check: `pnpm check`
- ✅ Create PR and wait for approval before merging
- ✅ NEVER force push to main/beta/prod

### GitHub Labels

Standard commit type labels must exist on all GitHub repositories. If labels are missing, initialize them using:

```bash
gh-labels-init
```

This creates all 8 standard labels with consistent colors: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

### Recommended Git Workflow

```fish
start 42                 # Create branch from issue #42 (slash command: /start)
commit feat: add login   # Make changes and commit
finish                   # Push → PR → merge → cleanup (slash command: /finish)
ship                     # Deploy to production (slash command: /ship)
```

**Available Fish functions:** See `~/.claude/FISH_FUNCTIONS.md`
**Available commands:** See `~/.claude/commands/git/`

## 📍 Documentation Structure

### Global Setup (`~/.claude/`)

This directory contains instructions and context that Claude Code uses across all projects.

**Managed with GNU Stow:** All configuration files in `~/.claude/` are symlinked from `~/dotfiles/.claude/` for version control and synchronization. Changes in dotfiles are instantly reflected in `~/.claude/`.

| File/Folder | Purpose | For |
|-------------|---------|-----|
| `README.md` | Quick overview and navigation | You (human) |
| `CLAUDE.md` | Global instructions and conventions | Claude Code |
| `claude/` | Reference context docs | Claude Code |
| `commands/` | Slash command definitions | Claude Code |
| `docs/` | Detailed guides for humans | You (human) |

### Structure Breakdown

```
~/.claude/
├── README.md                    ← START HERE (quick overview)
├── CLAUDE.md                    ← Global instructions (you are reading this)
├── FISH_FUNCTIONS.md            ← Reference of all Fish shell functions
│
├── commands/                    ← Slash commands (auto-discovered)
│   ├── optimize.md              # Code performance optimization
│   ├── review.md                # Code quality & bug review
│   └── git/                     # Git workflow commands
│       ├── start.md             # Create branch from issue
│       ├── finish.md            # Automated PR workflow
│       ├── ship.md              # Deploy to production
│       └── issues.md            # GitHub issues utilities
│
└── docs/                        ← Detailed human guides
    └── [future guides]
```

### Project-Specific Documentation

Per-project guides in `project-root/.claude/`:

```
project-root/
├── CLAUDE.md              # Project-specific instructions
│
.claude/
├── architecture.md        # System design, patterns
├── database.md            # Schema, queries, migrations
└── api.md                 # API routes, authentication
```

## 🐟 Fish Functions & Configuration Paths

**⚠️ IMPORTANT: Use `~/dotfiles/` for edits, NOT `~/.config/`**

All Fish functions and configuration files are **managed in `~/dotfiles/`** and automatically symlinked to `~/.config/` via GNU Stow.

- **Source (edit here):** `~/dotfiles/.config/`
- **Symlinks (read-only):** `~/.config/`
- **Never edit files in `~/.config/`** - Changes won't persist. Always edit in `~/dotfiles/`

### Git Workflow Functions

**Source Location:** `~/dotfiles/.config/fish/functions/git/`
**Symlinked to:** `~/.config/fish/functions/git/`

| Function | File | Purpose |
|----------|------|---------|
| `ship` | `ship.fish` | Deploy main → prod with version bumping |
| `commit` | `workflow.fish` | Git add + commit with conventional format |
| `gh-finish` | `workflow.fish` | Complete PR: push → PR → merge → cleanup |
| `ghfinish` | `workflow.fish` | Alias for `gh-finish` (backward compatibility) |

### How to Use

```fish
ship              # Deploy to production
commit feat: ...  # Commit with conventional format
gh-finish         # Finish PR workflow
ghfinish          # Same as gh-finish
```

### How Claude Uses This

When Claude Code starts, it automatically:

1. **Reads** `~/.claude/CLAUDE.md` (global instructions)
2. **Reads** `~/.claude/claude/*` (context documents)
   - Learns about available Fish functions
   - Understands optimization strategy
   - Knows your conventions
3. **Reads** `project-root/.claude/CLAUDE.md` (project-specific)
4. **Uses all this knowledge** when helping you

### Key Rules

- **Global instructions** in `~/.claude/CLAUDE.md`
  - Principles, conventions
  - Git workflow
  - Code quality standards

- **Documentation references** in `~/.claude/`
  - `GIT_WORKFLOW.md` - Git workflow strategy and commands
  - `commands/` - Slash commands (auto-discovered by Claude)

- **Project-specific** stays in `project-root/.claude/`
  - Architecture details
  - Database schema
  - API specifications

- **Human guides** go in `~/.claude/docs/`
  - For you to understand the structure

**Important:** Runtime & generated files (`.credentials.json`, `debug/`, `history.jsonl`, `todos/`, `projects/`, etc.) are ignored in `.gitignore` and NOT symlinked. Only configuration and documentation files are managed by Stow.

**Always update documentation when you:**
- Change a process → update `CLAUDE.md`
- Modify **git workflow** (functions or commands) → **ALWAYS update `GIT_WORKFLOW.md`**
  - When you modify `~/dotfiles/.config/fish/functions/git/*` → Update `GIT_WORKFLOW.md`
  - When you modify `~/dotfiles/.claude/commands/git/*` → Update `GIT_WORKFLOW.md`
- Add a slash command → place in `commands/` subdirectory (auto-discovered)

## ✅ Before Coding

1. Read project `CLAUDE.md`
2. Check `package.json` scripts
3. Understand project structure
4. Ask if requirements are unclear