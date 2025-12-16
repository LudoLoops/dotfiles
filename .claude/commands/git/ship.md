Execute the ship deployment command.

Deploys from `main` to `prod` with automatic version bumping. Uses the Fish `ship` function directly.

## Function Location
`~/dotfiles/.config/fish/functions/git/ship.fish`

## Usage

```fish
ship              # Deploy from main to prod (bumps version)
ship prod         # Explicit prod deployment
ship-prod         # Alias for ship prod
```

## What It Does

1. ✅ Verifies git status is clean
2. ✅ Fetches latest from remote
3. ✅ Pulls latest changes from main
4. ✅ Bumps version using `standard-version`
5. ✅ Generates CHANGELOG automatically
6. ✅ Copies CHANGELOG to static/ for public access
7. ✅ Verifies prod is aligned with main (fast-forward merge only)
8. ✅ Pushes to prod (triggers auto-deploy)
9. ✅ Returns to main branch

## Version Bumping Logic (via standard-version)

- `feat:` commits → Minor bump (0.X.0)
- `fix:` or `chore:` commits → Patch bump (0.0.X)
- `BREAKING CHANGE:` → Major bump (X.0.0)
- CHANGELOG auto-generated from commit history

## Requirements

- Must be on `main` branch
- Working directory must be clean (no uncommitted changes)
- `package.json` must exist
- `standard-version` installed via pnpm

## Important Notes

- Only deploys to prod (no beta deployment)
- Version bumping is automatic via standard-version
- All changes must be on main before deploying
- No manual version bumping needed
- `prod` must always be aligned with `main` (fast-forward only)
- If merge fails: `prod` has commits that shouldn't exist - investigate before forcing

## If Merge Fails

⚠️ **Never use `--no-ff` to force the merge.** This breaks the CI/CD pipeline.

If the merge fails, it means `prod` has diverged from `main`. This should never happen in normal workflow. Check:

```fish
git log --oneline main..prod    # Commits on prod not on main
```

If there are commits, contact the team to safely reset `prod` to `main`.
