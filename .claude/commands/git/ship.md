---
allowed-tools: Bash(fish:*), Bash(git:*)
description: Deploy to production with version bumping
---

# Deploy to production

Execute: `ship`

!`fish -c "ship"`

---

## What happens

Automated deployment pipeline from main to prod:
1. ✅ Verifies git status is clean
2. ✅ Bumps version (patch)
3. ✅ Generates CHANGELOG automatically
4. ✅ Merges main → prod
5. ✅ Returns to main branch

## Requirements

- Must be on main branch
- Working directory must be clean
- `package.json` must exist
- `standard-version` installed via pnpm

## Usage

From main: `/git:ship` → Deploys to prod with version bump
From beta: `/git:ship` → Deploys to prod (version already bumped)
