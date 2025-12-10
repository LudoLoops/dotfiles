Execute the ship deployment command.

Run `fish -c "ship $ARGS"` in the project directory to deploy to the specified target (beta or prod).

The function automatically:
- Creates a release branch (chore/release-x.x.x) for version bumps
- Bumps version using `pnpm version patch`
- Updates CHANGELOG.md with the new version
- Commits both version and CHANGELOG together
- Creates a PR from release branch to main
- Merges the PR via GitHub CLI (squash merge)
- Merges main to target branch (beta/prod)
- Pushes to trigger auto-deploy
- Returns to main branch

Usage:
- `ship` - Auto-detect (main → beta, beta → prod)
- `ship beta` - Deploy to beta with release workflow
- `ship prod` - Deploy to production
- `ship-beta` - Alias for `ship beta`
- `ship-prod` - Alias for `ship prod`

The entire deployment pipeline is automated and requires no Claude involvement.
