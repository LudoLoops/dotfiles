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

### Version Bumping Strategy

**Beta deployment:**
- Auto-bumps patch version (`1.0.0` → `1.0.1`)
- Lets you see progress in beta testing
- Version bump happens automatically with `ship` command

**Production deployment:**
- Uses the already-bumped beta version
- No additional version bump
- You know the exact version that was tested

**Example:**
```
Day 1: main 1.0.0 → ship → beta 1.0.1
Day 2: main 1.0.1 → ship → beta 1.0.2
Day 3: main 1.0.2 → ship prod → prod 1.0.2 (same as beta)
```

### Manual Version Bump (if needed)

```bash
pnpm version:patch     # 1.0.0 → 1.0.1
pnpm version:minor     # 1.0.0 → 1.1.0
pnpm version:major     # 1.0.0 → 2.0.0
```

---

## 🚀 Deployment (Using `ship`)

The `ship` function automates all deployments. See: `~/.claude/commands/ship.md`

### Deploy to Beta (Staging)

```bash
git checkout main
ship
# ✓ Version auto-bumped (patch)
# ✓ Merged to beta
# ✓ Auto-deployed to staging environment
```

### Deploy to Production

**Option 1 - From beta (after testing):**
```bash
git checkout beta
ship prod
# ✓ Merged to prod
# ✓ Auto-deployed to production
```

**Option 2 - Full pipeline from main:**
```bash
git checkout main
ship prod
# ✓ Version bumped
# ✓ Merged to beta
# ✓ Merged to prod
# ✓ Both auto-deployed
```

---

## ⚡ Quick Workflow

### 1. Develop Feature

```bash
git checkout main
git pull origin main
git checkout -b feat/my-feature

# ... make changes ...

git add .
git commit -m "feat: add my feature"
git push -u origin feat/my-feature
```

### 2. Create Pull Request

On GitHub:
1. Open PR: `feat/my-feature` → `main`
2. Wait for approval
3. Merge with "Squash and Merge"

### 3. Deploy to Beta

```bash
git checkout main
git pull origin main
ship
# Wait for auto-deploy to complete
```

### 4. Test in Staging

- Visit staging URL
- Verify changes work
- Test edge cases

### 5. Deploy to Production

```bash
git checkout main
ship prod
# Or from beta: git checkout beta && ship prod
```

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
| Long-lived branches (2+ weeks) | Merge conflicts | Smaller PRs, frequent rebases |
| Unclear commit messages | Hard to track changes | Use conventional commits |
| Forgetting to pull before push | Rejected pushes | Always `git pull` before work |
| Merging `beta` to `main` | Wrong direction | Only `main` → `beta` |

---

## 📚 Related Documentation

- **Deployment automation:** `~/.claude/commands/ship.md`
- **Smart branch creation:** `~/.claude/commands/branch.md`
- **Global conventions:** `~/.claude/CLAUDE.md`

---

**Last Updated:** December 2025
**Applies to:** All web development projects with `main` → `beta` → `prod` deployment
