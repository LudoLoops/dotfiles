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

### GitHub Fish Commands

Use these Fish shell commands for GitHub workflows - they're simpler than using `gh` directly:

| Command | Purpose |
|---------|---------|
| `gh-workflow` | Show complete GitHub workflow guide (issue → branch → commit → PR → merge) |
| `gh-start <issue-#> [type]` | Create feature branch from issue number (auto-fetches title, converts to slug) |
| `gh-branch <issue-#> <slug>` | Quick branch creation: `gh-branch 42 add-auth` → creates `feat/42-add-auth` |
| `gh-pr` | Create PR from current branch (auto-closes associated issue) |
| `gh-finish` | Merge PR, delete branch, return to main |
| `gh-labels-init` | Initialize all 8 standard commit type labels |
| `commit <type>: <subject>` | Conventional commit: `commit feat: add user auth` |
| `compush <type>: <subject>` | Commit + push in one command |

**Example workflow:**
```fish
gh-start 42              # Create branch from issue #42
commit feat: add login   # Make changes and commit
gh-pr                    # Create PR (auto-closes #42)
gh-finish                # Merge and cleanup
```

**For detailed documentation on all available Fish functions**, see `.claude/docs/fish-dev-functions.md` which covers:
- Git & GitHub workflows (8 functions)
- Package management with pnpm
- SvelteKit development tools
- Editor integrations (Cursor, Neovide, Zeditor)
- Quick utilities and pro tips

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
│
├── claude/                      ← Context for Claude (auto-read)
│   ├── fish-dev-functions.md    # All available Fish shell functions
│   └── commands-optimization.md # Token optimization strategy
│
├── commands/                    ← Slash commands
│   ├── branch.md                # /branch command
│   ├── optimize.md              # /optimize command
│   └── review.md                # /review command
│
└── docs/                        ← Detailed human guides
    ├── STRUCTURE.md             # Explanation of this structure
    ├── CLAUDE-CONTEXT.md        # What's in claude/ folder
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

- **Global context** goes in `~/.claude/claude/`
  - Fish functions reference
  - Optimization strategies
  - Shared workflows

- **Global instructions** stay in `~/.claude/CLAUDE.md`
  - Principles, conventions
  - Git workflow
  - Code quality standards

- **Project-specific** stays in `project-root/.claude/`
  - Architecture details
  - Database schema
  - API specifications

- **Human guides** go in `~/.claude/docs/`
  - For you to understand the structure
  - Guides on how things work
  - Documentation about documentation

**Important:** Runtime & generated files (`.credentials.json`, `debug/`, `history.jsonl`, `todos/`, `projects/`, etc.) are ignored in `.gitignore` and NOT symlinked. Only configuration and documentation files are managed by Stow.

**Always update documentation when you:**
- Change a process → update `CLAUDE.md`
- Add a Fish function → update `claude/fish-dev-functions.md`
- Change structure → update `docs/STRUCTURE.md`

## ✅ Before Coding

1. Read project `CLAUDE.md`
2. Check `package.json` scripts
3. Understand project structure
4. Ask if requirements are unclear