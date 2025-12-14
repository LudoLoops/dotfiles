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

### 1. Start Feature (Simplified!)

```bash
gh-start 42              # Create branch from issue #42 (auto-infers type)
# Result: feat/42-branch-name created and checked out
```

### 2. Make Changes & Commit

```bash
# ... make your changes ...

commit feat: add my feature    # Conventional commit with validation
```

### 3. Finish & Merge (Fully Automated!)

```bash
gh-finish
# Automatically:
# ✓ Pushes branch to remote
# ✓ Creates PR (closes issue #42)
# ✓ Squash merges to main
# ✓ Deletes branch
# ✓ Returns to main
```

### 4. Deploy to Production

```bash
ship
# Automatically:
# ✓ Bumps version (via standard-version)
# ✓ Generates CHANGELOG
# ✓ Merges to prod
# ✓ Triggers auto-deploy
```

**That's it!** Full workflow from issue to production with 4 commands.

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

## 🚫 Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Commit directly to `main` | Bypasses PR review | Use feature branch + PR |
| Forgetting to create feature branch | Commits on main | Always create branch FIRST |
| Long-lived branches (2+ weeks) | Merge conflicts | Smaller PRs, frequent rebases |
| Unclear commit messages | Hard to track changes | Use conventional commits |
| Not using `gh-start` | Manual branch creation | Use `gh-start <issue-#>` |
| Not using `gh-finish` | Manual PR/merge steps | Use `gh-finish` (fully automated) |

---

## 📚 Related Documentation

- **Fish functions reference:** `~/.claude/FISH_FUNCTIONS.md`
- **Global conventions:** `~/.claude/CLAUDE.md`

---

**Last Updated:** December 14, 2025
**Applies to:** All web development projects with `main` → `prod` deployment pipeline
