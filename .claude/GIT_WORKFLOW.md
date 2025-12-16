# Git Workflow & Deployment Strategy

Standard branching, versioning, and deployment strategy for all web development projects.

**Stack:** `main` → `beta` (staging) → `prod` (production)

---

## 🏷️ Branch Naming

Use these prefixes for all feature branches (created from `main`):

| Prefix      | Purpose         | Example                 |
|-------------|-----------------|-------------------------|
| `feat/`     | New features    | `feat/dark-mode`        |
| `fix/`      | Bug fixes       | `fix/form-validation`   |
| `docs/`     | Documentation   | `docs/api-guide`        |
| `refactor/` | Code refactoring| `refactor/utils`        |
| `test/`     | Tests           | `test/e2e-dashboard`    |
| `chore/`    | Dependencies    | `chore/update-deps`     |

**Rules:**
- ✅ Always lowercase: `feat/user-auth` (NOT `feat/UserAuth`)
- ✅ Use hyphens: `feat/user-login` (NOT `feat/user_login`)
- ✅ Be concise: `fix/button-hover` (NOT `fix/very-long-description-of-button`)

---

## 📝 Commit Messages

Use **Conventional Commits** format:

```
type: description

[optional longer explanation if needed]
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `refactor:` - Code refactoring
- `test:` - Tests
- `style:` - Formatting/styling
- `chore:` - Dependencies, build config, etc.

**Rules:**
- ✅ Lowercase: `feat:` (NOT `Feat:`)
- ✅ Imperative: "add", "fix", "update" (NOT "added", "fixed")
- ✅ No period: `feat: add feature` (NOT `feat: add feature.`)

**Examples:**
```bash
git commit -m "feat: add dark mode toggle"
git commit -m "fix: resolve form validation on step 3"
git commit -m "docs: update git workflow"
```

---

## 🔀 Branching Strategy

### Protected Branches (Read-Only by Convention)

Three core branches that should never have direct commits:

- **`main`** = Development (PR merges only)
- **`beta`** = Staging/Testing (auto-deploys)
- **`prod`** = Production (auto-deploys)

### The Flow

```
Feature Branch (feat/*, fix/*, etc.)
    ↓
Pull Request → main (PR review required)
    ↓
main (development)
    ↓ ship
beta (staging/testing)
    ↓ ship prod
prod (live)
```

### Rules

- ❌ **NEVER** edit `main`, `beta`, or `prod` directly
- ✅ **ALWAYS** create a feature branch FIRST (before any changes)
- ✅ **ALWAYS** use Pull Requests for all changes to `main`
- ✅ **ALL commits go through feature branches → PR → main**

---

## 📦 Versioning

The project uses **Semantic Versioning** (MAJOR.MINOR.PATCH):
- `1.0.0` → `1.0.1` (patch - bug fixes)
- `1.0.0` → `1.1.0` (minor - new features)
- `1.0.0` → `2.0.0` (major - breaking changes)

### Version Bumping Strategy (via `standard-version`)

Version is **auto-bumped on production deployment** based on commit types:

**Commit types → Version bump:**
- `feat:` commits → Minor bump (0.X.0)
- `fix:` or `chore:` commits → Patch bump (0.0.X)
- `BREAKING CHANGE:` → Major bump (X.0.0)

**Example:**
```
Current: 1.0.0
Commits since last release: 2 × fix:, 1 × feat:
Deploy: ship
Result: Version bumped to 1.1.0 (minor, due to feat)
```

Version bumping happens automatically during `ship` deployment - no manual version management needed.

---

## 🚀 Deployment (Using `ship`)

The `ship` function automates deployment to production. See: `~/.claude/commands/git/ship.md`

### Deploy to Production

```bash
git checkout main
ship
# ✓ Version auto-bumped (via standard-version)
# ✓ CHANGELOG generated
# ✓ Merged to prod
# ✓ Auto-deployed to production environment
```

**Requirements:**
- Must be on `main` branch
- Working directory must be clean (no uncommitted changes)
- All changes should be tested before deployment

---

## ⚡ Quick Workflow (Using Fish Functions)

### 1. Create Issue with Label

```bash
/git:issue "add user authentication"
# Automatically:
# ✓ Determines type (feat, fix, docs, etc.)
# ✓ Creates issue without title prefix
# ✓ Adds corresponding label
# ✓ Proposes setup-labels if labels don't exist
```

### 2. Start Feature (Type from Label!)

```bash
ghstart 42              # Create branch from issue #42
# Automatically:
# ✓ Reads issue label (e.g., "feat")
# ✓ Creates branch: feat/42-add-user-authentication
# ✓ Proposes to add label if issue has none
```

### 3. Make Changes & Commit (No Prefix!)

```bash
# ... make your changes ...

/git:commit "add user authentication"    # Simple message, no prefix needed
# OR just type: commit "your message"    # Even simpler in shell
```

**Note:** Commits during development don't need prefixes - they'll be squashed anyway!

### 4. Finish & Merge (Type Added at Merge!)

```bash
ghfinish
# Automatically:
# ✓ Reads issue label
# ✓ Pushes branch to remote
# ✓ Creates PR with typed title: "feat: add user authentication"
# ✓ Squash merges (commit gets the type prefix)
# ✓ Closes issue
# ✓ Deletes branch
# ✓ Returns to main
```

### 5. Deploy to Production

```bash
/git:ship
# Automatically:
# ✓ Reads commit prefix from recent merges
# ✓ Bumps version (via standard-version)
# ✓ Generates CHANGELOG
# ✓ Merges to prod
# ✓ Triggers auto-deploy
```

**That's it!** Full workflow from issue to production with 5 commands. Type-free development, automated typing at merge!

---

## 🔧 Emergency Hotfix

**Scenario:** Critical bug in production while developing new features.

```bash
# 1. Fix from prod (don't break new features)
git checkout prod
git checkout -b fix/critical-issue

# ... fix ...

git commit -m "fix: critical production issue"

# 2. Merge back to prod
git checkout prod
git pull origin prod
git merge fix/critical-issue
git push origin prod

# 3. Also merge to main (so it's in development)
git checkout main
git pull origin main
git merge fix/critical-issue
git push origin main

# 4. Cleanup
git branch -d fix/critical-issue
git push origin --delete fix/critical-issue
```

---

## ✅ Pre-Deployment Checklist

Before pushing or creating PR:

- ✅ `pnpm check` passes (TypeScript)
- ✅ `pnpm lint` passes (linting)
- ✅ `pnpm test` passes (unit tests)
- ✅ `pnpm build` passes (build)
- ✅ Tested manually with `pnpm dev`
- ✅ No `.env` or secrets committed
- ✅ Branch name follows conventions
- ✅ Commit messages follow conventions

---

## 🏷️ Label-Based Type System

Instead of typing everything manually, we use **GitHub issue labels** as the source of truth:

1. **Issue created** → Add label (feat, fix, docs, etc.)
2. **Branch created** → Reads label → `feat/42-...`
3. **Branch finished** → Reads label → Creates PR `feat: ...`
4. **Squash merge** → Uses PR title → Commit gets prefix
5. **Deployment** → `standard-version` reads prefix

**Labels available:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

Use `setup-labels` to initialize them in your repo.

---

## 🚫 Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Commit directly to `main` | Bypasses PR review | Use feature branch + PR |
| Forgetting to create feature branch | Commits on main | Always create branch FIRST |
| Long-lived branches (2+ weeks) | Merge conflicts | Smaller PRs, frequent rebases |
| Issue without label | ghstart/ghfinish will prompt | Add label first or let them create it |
| Prefixing intermediate commits | Overkill, they're squashed | Only prefix matters at merge |
| Not using slash commands | Manual steps needed | Use `/git:issue`, `/git:start`, `/git:finish` |

---

## 📚 Related Documentation

- **Slash commands:** `~/dotfiles/.claude/commands/git/` (auto-discovered by Claude)
- **Global conventions:** `~/.claude/CLAUDE.md`
- **Fish functions:** `~/dotfiles/.config/fish/functions/git/` (auto-loaded)

---

**Last Updated:** December 14, 2025
**Applies to:** All web development projects with `main` → `prod` deployment pipeline
