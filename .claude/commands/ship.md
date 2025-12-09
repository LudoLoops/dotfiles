# Automated Deployment Pipeline (ship)

Automate your entire deployment workflow: version bumping, branch merging, and auto-deploy — all in one command.

## How it works:

1. **Shell Execution**: Run `ship [beta|prod]` from your git repository
   ```fish
   ship              # Smart auto-detect based on current branch
   ship beta         # Explicit deploy to beta
   ship prod         # Full pipeline: beta → prod
   ship-beta         # Alias for `ship beta`
   ship-prod         # Alias for `ship prod`
   ```

2. **Smart Branch Detection**:
   - From `main`: `ship` → deploys to beta (bumps version)
   - From `main`: `ship prod` → full pipeline (beta → prod)
   - From `beta`: `ship` → deploys to prod only
   - From `beta`: `ship prod` → deploys to prod only

3. **Automatic Steps** (depending on target):
   - ✅ Validates clean working directory
   - ✅ Fetches latest from remote
   - ✅ Bumps version (patch) — only for beta deploy
   - ✅ Merges changes to target branch(es)
   - ✅ Pushes to remote (triggers auto-deploy)
   - ✅ Returns to main branch
   - ✅ Provides clear status feedback

## Usage scenarios:

### Deploy to Beta (from main)
```fish
git checkout main
ship
# Result: Version bumped, merged to beta, auto-deploy triggered
```

### Deploy to Prod (from beta)
```fish
git checkout beta
ship
# Result: Merged to prod, auto-deploy triggered (no version bump)
```

### Full Pipeline (from main)
```fish
git checkout main
ship prod
# Result: Version bumped → beta merge → prod merge → both auto-deploy
```

## Key features:

- ✅ **Smart branch detection**: Knows which target is appropriate
- ✅ **Automatic version bumping**: Only on beta (patch level)
- ✅ **Merge handling**: Graceful conflict detection and reporting
- ✅ **Generic**: Works for ANY project with `package.json` + git
- ✅ **Fast**: All validation and merges automated
- ✅ **Reliable**: Clear error messages if anything fails
- ✅ **No Claude needed**: Zero token usage for deployment

## Integration with workflow:

```fish
# 1. Develop on main
git checkout main
git checkout -b feat/my-feature
# ... make changes ...
git commit -am "feat: add new feature"
git push origin feat/my-feature

# 2. Create PR on GitHub, merge to main
# (or merge locally if no PR required)

# 3. Deploy to beta
ship
# ✓ Version bumped to 1.2.3
# ✓ Merged to beta
# ✓ Auto-deploy triggered

# 4. Test in beta environment

# 5. Deploy to production
ship prod
# ✓ Merged beta → prod
# ✓ Auto-deploy triggered
# ✓ Changes live!
```

## What each command does:

### `ship` (from main)
1. Check git status (must be clean)
2. Fetch latest from remote
3. Bump version (patch)
4. Push version bump to main
5. Merge main → beta
6. Push to beta (auto-deploy)
7. Return to main

### `ship prod` (from main - full pipeline)
1. All steps from `ship beta` above
2. Then merge beta → prod
3. Push to prod (auto-deploy)
4. Return to main

### `ship` (from beta)
1. Check git status (must be clean)
2. Fetch latest from remote
3. Merge beta → prod
4. Push to prod (auto-deploy)
5. Return to main

## Error handling:

If anything fails:
- ✅ Clear error message explaining what went wrong
- ✅ Suggestions for resolution (e.g., "Run: git merge --abort")
- ✅ Safe state (function stops, doesn't corrupt repo)
- ✅ You're returned to a known branch (main)

## Why this is better:

- ✅ **Deterministic**: Same result every time (no variation)
- ✅ **Token efficient**: Zero Claude involvement
- ✅ **Fast**: Instant execution (no AI waiting)
- ✅ **Reliable**: All validation automated
- ✅ **Generic**: Works for any SvelteKit, Next.js, Node project
- ✅ **Safe**: Validates state before each step
- ✅ **Professional**: Follows deployment best practices

## When to use this:

- ✅ Deploying web applications (SvelteKit, Next.js, etc.)
- ✅ Projects with semantic versioning in `package.json`
- ✅ Repos with `main` → `beta` → `prod` branches
- ✅ Any workflow with auto-deploy on git push

## When NOT to use:

- ❌ Manual deployments (use git directly)
- ❌ Projects without auto-deploy pipeline
- ❌ If you need to bump major/minor versions (use `pnpm version` manually)

## Note:

If you want Claude's intelligence for other deployment steps (health checks, smoke tests, notifications), you can combine this with other tools. But **the core deployment pipeline is fully automated** — no Claude needed!
