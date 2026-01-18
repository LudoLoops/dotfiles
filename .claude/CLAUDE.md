# Global CLAUDE.md

Global guidance for Claude Code across all projects.

## 🚀 Quick Start

**Always use `bun` (fallback to `pnpm`, never npm or yarn)**

```bash
bun install          # Install dependencies (or: pnpm install)
bun add <package>    # Add package (or: pnpm add)
bun add -D <package> # Add dev dependency (or: pnpm add -D)
bun dev              # Start dev server (or: pnpm dev)
bun test             # Run tests (or: pnpm test)
bun build            # Build (or: pnpm build)
```

## ⚠️ Critical Rules (Zero Exceptions)

1. **🚫 Never commit to main/beta/prod** - Always create feature branch first
   - Format: `<type>/<issue-#>-<slug>` (e.g., `feat/113-fix-changelog`)
   - Types: `feat/`, `test/`, `docs/`, `bug/`, `refactor/`

2. **🔒 Protected branches are read-only**
   - Only change via: PR → Review → Merge on GitHub
   - No exceptions for "quick fixes"

3. **📋 Create feature branch BEFORE editing any files**
   - Check current branch: `git branch`
   - If on main/beta/prod: `git checkout -b <branch-name>`

## 🎯 Key Principles

1. **bun everywhere** - Fallback to pnpm if bun unavailable, never npm or yarn
2. **Read project CLAUDE.md** - Each project may have specific guidance
3. **Use existing scripts** - Check `package.json` first
4. **Edit existing files** - Create new only if necessary
5. **No `any` in TypeScript** - Create proper type interfaces
6. **Console.log in dev only** - Guard logs for development visibility
7. **Skeleton without dark** - Use 100-900 scale instead of dark variants

## 📝 Git Workflow

### Branch Format

- Pattern: `<type>/<issue-#>-<slug>`
- Example: `feat/issue-11-margin-calculations`

### Commits & Issues

**All issues and commits must be in English**

Conventional Commits format:

```
<type>: <subject (imperative, lowercase, no period)>

<body (wrap at 100 chars, explain why not what)>

Closes #<issue-number>
```

### Required Checks Before Merge

- ✅ Tests pass: `bun test` (or `pnpm test`)
- ✅ Code formatted: `bun format` (or `pnpm format`)
- ✅ TypeScript checks: `bun check` (or `pnpm check`)
- ✅ Create PR and wait for approval
- ✅ Never force push to main/beta/prod

### GitHub Labels

Initialize standard labels with:
```bash
gh-labels-init
```

Creates 8 labels: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

### Recommended Workflow

```fish
start 42          # Create branch from issue #42
commit feat: ...  # Make changes and commit
finish            # Push → PR → merge → cleanup
ship              # Deploy to production
```

See `~/.claude/commands/git/` for command details.

## 📍 Documentation Structure

### Global Setup (`~/.claude/`)

Files are symlinked from `~/dotfiles/.claude/` via GNU Stow for version control.

| File | Purpose |
|------|---------|
| `README.md` | Quick overview and navigation |
| `CLAUDE.md` | Global instructions (this file) |
| `FISH_FUNCTIONS.md` | Reference of available Fish functions |
| `commands/` | Slash command definitions (auto-discovered) |
| `docs/` | Detailed human guides |

### Directory Tree

```
~/.claude/
├── README.md                    ← START HERE
├── CLAUDE.md                    ← Global instructions (you are reading this)
├── FISH_FUNCTIONS.md            ← Fish function reference
├── commands/                    ← Slash commands (auto-discovered)
│   ├── optimize.md              # Code optimization
│   ├── review.md                # Code quality & bug review
│   └── git/                     # Git workflow commands
│       ├── start.md             # Create branch from issue
│       ├── finish.md            # Automated PR workflow
│       ├── ship.md              # Deploy to production
│       └── issues.md            # GitHub issues utilities
└── docs/                        ← Detailed human guides
```

### Project-Specific Documentation

Per-project guides in `project-root/.claude/`:

```
.claude/
├── CLAUDE.md            # Project-specific instructions
├── architecture.md      # System design, patterns
├── database.md          # Schema, queries, migrations
└── api.md               # API routes, authentication
```

## 🐟 Fish Functions & Configuration

**⚠️ IMPORTANT: Edit in `~/dotfiles/`, NOT `~/.config/`**

All functions are managed in `~/dotfiles/` and symlinked to `~/.config/` via GNU Stow.

- **Source (edit here):** `~/dotfiles/.config/`
- **Symlinks (read-only):** `~/.config/`
- Never edit `~/.config/` - Changes won't persist

### Git Workflow Functions

| Function | Purpose |
|----------|---------|
| `ship` | Deploy main → prod with version bumping |
| `commit` | Git add + commit with conventional format |
| `gh-finish` | Complete PR: push → PR → merge → cleanup |
| `ghfinish` | Alias for `gh-finish` (backward compatibility) |

**Location:** `~/dotfiles/.config/fish/functions/git/`

## 📋 Documentation Maintenance

**Always update documentation when you:**
- Change a process → update `CLAUDE.md`
- Modify git workflow (functions/commands) → **update `GIT_WORKFLOW.md`**
  - When you modify `~/dotfiles/.config/fish/functions/git/*`
  - When you modify `~/dotfiles/.claude/commands/git/*`
- Add a slash command → place in `commands/` subdirectory (auto-discovered)

Note: Runtime files (`.credentials.json`, `debug/`, `history.jsonl`, `todos/`, `projects/`, etc.) are ignored in `.gitignore` and NOT symlinked. Only configuration and documentation are managed by Stow.

## 🎨 Svelte Conventions

**For component-specific styles:**
- ✅ Use `<style>` block for specific values (gradients, animations, custom layouts)
- ❌ Never use inline `style=` attributes
- ❌ Don't add non-global values to `layout.css` or global stylesheets

**Example:**
```svelte
<div class="my-component">
  Content here
</div>

<style>
  .my-component {
    background: linear-gradient(to bottom, #020202, #0f0505);
    /* component-specific styles only */
  }
</style>
```

**Reserve global CSS for:**
- Reset styles and fonts
- Reusable CSS variables
- Framework imports (Skeleton, Tailwind, etc.)
- Truly global styles (scrollbars, base elements)

## ✅ Before Coding

1. Read project `CLAUDE.md`
2. Check `package.json` scripts
3. Understand project structure
4. Ask if requirements are unclear
