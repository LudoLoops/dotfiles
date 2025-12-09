# Fish Shell Development Functions

Guide to essential Fish shell functions available in this development environment. These functions are auto-loaded at shell startup via `functions/index.fish`.

## Quick Reference

### Git & GitHub Workflow

```fish
gh-workflow              # Display complete GitHub workflow guide
gh-start <issue-#>       # Create feature branch from GitHub issue
gh-branch <issue-#> <slug> # Quick branch creation
commit <type>: <subject> # Conventional commit with validation
compush <type>: <subject> # Commit + push in one command
gh-pr                    # Create PR (auto-closes associated issue)
gh-finish                # Merge PR, delete branch, return to main
gh-labels-init           # Initialize standard commit type labels
```

### Package Management

```fish
p <command>              # pnpm (primary package manager)
pdx <package>            # pnpm dlx (run packages without install)
pex <command>            # pnpm exec (run scripts)
```

### Development Tools

```fish
sv-create <path>         # Create new SvelteKit project (TS, Tailwind, Skeleton UI)
mkroute <path>           # Create SvelteKit route with +page.svelte
zc <path>                # Navigate to path and open in Cursor
zz <path>                # Navigate to path and open in Zeditor
v <path>                 # Launch Neovide GUI editor
```

### Quick Helpers

```fish
!!                       # Re-run previous command (bash history feature)
!$                       # Re-run last argument of previous command
```

---

## Detailed Command Documentation

### 🔀 Git & GitHub Workflow Functions

#### `gh-workflow`
Displays the complete GitHub workflow guide showing the optimal development process.

**Usage:**
```fish
gh-workflow
```

**Output:**
Shows step-by-step instructions for:
1. Creating a feature branch from an issue
2. Making changes and committing
3. Creating a pull request
4. Merging and cleanup

---

#### `gh-start <issue-number> [type]`
Creates a feature branch directly from a GitHub issue, automatically fetching the issue title and converting it to a slug.

**Usage:**
```fish
gh-start 42              # Auto-detects issue type as 'feat'
gh-start 42 fix          # Specify issue type as 'fix'
```

**Behavior:**
- Fetches issue title from GitHub (`gh issue view`)
- Converts title to slug (lowercase, spaces → dashes)
- Creates branch: `<type>/<issue-#>-<slug>`
- Example: `feat/42-add-user-authentication`

**Supported types:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

**Note:** Requires GitHub CLI (`gh`) installed and authenticated.

---

#### `gh-branch <issue-number> <slug>`
Manual alternative to `gh-start` when you want explicit control over the branch name.

**Usage:**
```fish
gh-branch 42 add-auth
# Creates: feat/42-add-auth
```

**When to use:**
- When you want to control the slug exactly
- When issue title is unclear or too verbose
- Faster than `gh-start` if you know the slug

---

#### `commit [type: subject]`
Creates a conventional commit with validation. Without arguments, auto-commits with timestamp.

**Usage:**
```fish
# Conventional commit (required format)
commit feat: add user authentication
commit fix: resolve login timeout issue
commit docs: update API documentation
commit refactor: simplify database queries

# Auto-commit with timestamp (if no arguments)
commit
# Creates: auto-commit: 25-Dec-2024 14:30
```

**Format validation:**
- Must include colon separator: `type: subject`
- Lowercase recommended (not enforced)
- Common types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

**Behavior:**
- Stages all changes: `git add -A`
- Creates commit with message
- Does NOT push (use `compush` to push after)

---

#### `compush [type: subject]`
Commits and pushes in a single command.

**Usage:**
```fish
compush feat: add dark mode toggle
# Equivalent to: commit feat: add dark mode toggle && git push
```

**Time-saving tip:**
Use when you're confident about changes and want to push immediately.

---

#### `gh-pr`
Creates a GitHub pull request from the current branch, automatically extracting the issue number from branch name.

**Usage:**
```fish
# From branch: feat/42-add-auth
gh-pr
# Creates PR that closes #42
```

**Branch format required:**
- Format: `<type>/<issue-#>-<slug>`
- Extracted issue number used in PR body: `Closes #42`

**Features:**
- `--fill` flag: Auto-fills PR title and body from commits
- Auto-closes associated issue when PR is merged

---

#### `gh-finish`
Merges the current PR and cleans up (deletes branch, returns to main).

**Usage:**
```fish
gh-finish
```

**What it does:**
1. Extracts issue number from branch name
2. Merges PR with squash (`gh pr merge -d -s`)
3. Deletes the feature branch
4. Checks out main branch

**Requirements:**
- Must be on a feature branch (format: `<type>/<issue-#>-<slug>`)
- PR must already be created (via `gh-pr`)

---

#### `gh-labels-init`
Initializes all standard GitHub labels for your repository.

**Usage:**
```fish
gh-labels-init
```

**Creates 8 standard labels:**
- `feat` (light blue) - New features
- `fix` (teal) - Bug fixes
- `refactor` (purple) - Code refactoring
- `docs` (blue) - Documentation
- `test` (yellow) - Tests
- `chore` (gray) - Maintenance tasks
- `perf` (red) - Performance improvements
- `style` (gold) - Style/formatting

**When to use:**
- First setup of a new repository
- Standardizes issue/PR labeling across projects

---

### 📦 Package Management Shortcuts

#### `p`
Alias for `pnpm` - the primary package manager.

**Usage:**
```fish
p install                # Install dependencies
p add package            # Add a package
p add -D dev-package     # Add dev dependency
p remove package         # Remove package
p update                 # Update all packages
p list                   # List installed packages
```

**Benefits of pnpm:**
- Faster than npm/yarn
- Efficient disk usage (monorepo-friendly)
- Strict dependency management
- Better reproducible installs

---

#### `pdx`
Alias for `pnpm dlx` - run packages without installing globally.

**Usage:**
```fish
pdx tsx script.ts        # Run TypeScript without global install
pdx vite build           # Use Vite build tool
pdx prisma db push       # Run Prisma CLI
```

**Use case:**
- One-off package execution
- Avoid polluting global npm
- Always runs latest version

---

#### `pex`
Alias for `pnpm exec` - run scripts from node_modules.

**Usage:**
```fish
pex jest                 # Run test suite
pex eslint src/          # Lint code
pex prettier --write src/ # Format code
```

**vs npm:**
- `npm exec` is similar but slower
- Respects local package.json scripts
- Better for monorepos

---

### 🚀 Web Development Tools

#### `sv-create <path>`
Scaffolds a new SvelteKit project with full configuration: TypeScript, pnpm, Tailwind CSS, Skeleton UI (Cerberus theme), testing, and linting.

**Usage:**
```fish
sv-create my-app
# Creates fully configured SvelteKit project ready to code
```

**Includes:**
- ✅ TypeScript configuration
- ✅ Tailwind CSS + Skeleton UI (Cerberus dark theme)
- ✅ Vitest for unit testing
- ✅ Playwright for E2E testing
- ✅ ESLint + Prettier for code quality
- ✅ DevTools JSON for better IDE support
- ✅ SvelteKit adapter presets

**After creation:**
```fish
cd my-app
p dev                    # Start development server
```

---

#### `mkroute <path> [path2 ...]`
Creates new SvelteKit routes with `+page.svelte` files.

**Usage:**
```fish
mkroute src/routes/dashboard
mkroute src/routes/settings src/routes/profile
# Creates: src/routes/dashboard/+page.svelte (empty)
#          src/routes/settings/+page.svelte
#          src/routes/profile/+page.svelte
```

**Use case:**
- Quick route scaffolding during development
- Batch create multiple routes

**Note:** Creates empty `+page.svelte` files; you add the component code.

---

#### `zc <path>`
Navigate to a directory (via Zoxide) and open it in Cursor IDE (all in background).

**Usage:**
```fish
zc projects
# → Navigate to ~/projects directory
# → Launch Cursor IDE
# → Shell prompt returns immediately
```

**Benefits:**
- Faster than manually navigating and opening editor
- Zoxide learns frequently visited directories
- Runs in background (doesn't block shell)

**Requirements:**
- Zoxide installed (`z` command)
- Cursor IDE installed

---

#### `zz <path>`
Navigate to a directory and open it in Zeditor (terminal editor).

**Usage:**
```fish
zz src
# → Navigate to ~/src directory
# → Open Zeditor in that directory
```

**vs `zc`:**
- `zc` = Zoxide + Cursor (GUI)
- `zz` = Zoxide + Zeditor (TUI)

---

#### `v <path>`
Launch Neovide (NeoVim GUI) in a detached session, optionally opening a specific path.

**Usage:**
```fish
v                        # Open Neovide in current directory
v src/components         # Open Neovide in src/components
v ~/projects/myapp       # Open Neovide with absolute path
```

**Features:**
- Runs in detached background process
- Doesn't block shell
- Alias: `neovide` (same functionality)

**vs terminal NeoVim:**
- GUI font rendering
- Better mouse support
- Modern editor experience
- Still full NeoVim power

---

### ⚡ Bash History Features

#### `!!`
Re-run the previous command (bash history feature available in Fish).

**Usage:**
```fish
npm install      # Oops, should use pnpm
!! ↵             # Re-runs: npm install
p install        # Now use correct command
```

**Replaces:**
- `<up arrow>` + `<enter>` for quick re-execution

---

#### `!$`
Insert the last argument of the previous command.

**Usage:**
```fish
git add src/utils.ts
git commit -m "fix: update utils" !$ ↵
# Expands to: git commit -m "fix: update utils" src/utils.ts
```

**Practical example:**
```fish
mkdir /long/path/to/new/dir
cd !$ ↵
# Expands to: cd /long/path/to/new/dir
```

---

## 🚀 Typical Development Workflow

### Starting a new feature:

```fish
# 1. Create feature branch from GitHub issue
gh-start 42

# 2. Navigate and open in editor
zc my-project

# 3. Make changes, commit periodically
commit feat: add user profile page
commit fix: resolve styling bug

# 4. Push all changes
compush docs: update README

# 5. Create PR (auto-closes issue)
gh-pr

# 6. Review, merge, and clean up
gh-finish
```

### Package management during dev:

```fish
p install              # Initial setup
p add react            # Add new package
p add -D @types/react  # Add types
p update               # Keep deps current
pdx create-next-app    # One-off tool
```

### Code quality:

```fish
pex eslint src/        # Check linting
pex prettier --write   # Auto-format
pex vitest             # Run tests
pex playwright test    # E2E tests
```

---

## 🔧 Environment Setup

### PATH Configuration
These functions require:
- Git & GitHub CLI (`gh`) installed
- pnpm installed globally
- Zoxide installed (`z` command)
- Cursor IDE installed (for `zc`)
- Neovide installed (for `v`)

### First-time setup:
```fish
p install            # Install pnpm if not already done
gh auth login        # Authenticate with GitHub
```

### Verify setup:
```fish
which git            # Should be /usr/bin/git
which gh             # Should be /usr/local/bin/gh or similar
which pnpm           # Should be ~/.local/share/pnpm or similar
which z              # Should be in PATH (zoxide)
which cursor         # Should be in PATH
```

---

## 🎯 Related Functions Not Listed Above

These functions are also available but less frequently used during active development:

- **system.fish**: `dockcontrol`, `zz`, `update`, `backup` - System administration
- **dev.fish**: `go-build-multi`, `cursor-rules` - Go builds, Cursor setup
- **editor.fish**: `neovide` - Alias for `v`
- **python.fish**: Auto-venv activation on directory change
- **utils.fish**: History bindings (`!!`, `!$`)

All functions are documented in their respective `.fish` files with inline comments.

---

## 📚 Additional Resources

For more information:
- **Git workflow details**: See `/home/loops/.claude/CLAUDE.md` (global instructions)
- **Function implementations**: See `.config/fish/functions/*.fish` files
- **GitHub CLI docs**: https://cli.github.com/
- **SvelteKit docs**: https://kit.svelte.dev/
- **pnpm docs**: https://pnpm.io/

---

## 💡 Pro Tips

1. **Combine commands:**
   ```fish
   gh-start 42; zc my-project; p dev
   ```

2. **Check before push:**
   ```fish
   git diff origin/main..HEAD   # See what you're pushing
   compush fix: update utils    # Then push with confidence
   ```

3. **Use branch names for context:**
   ```fish
   gh-start 42
   # Creates meaningful branch name automatically
   # PR will auto-close issue #42
   ```

4. **Batch operations:**
   ```fish
   mkroute src/routes/dashboard src/routes/settings src/routes/profile
   # Create multiple routes at once
   ```

5. **Keep branches clean:**
   ```fish
   gh-finish   # Cleans up after each completed feature
   # Always return to main branch, branch deleted automatically
   ```

---

**Last updated:** December 2024
**Fish Shell Version:** 3.6+
**Environment:** Linux (Arch Linux)
