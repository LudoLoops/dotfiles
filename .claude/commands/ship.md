Execute the ship deployment command.

Run `fish -c "ship $ARGS"` in the project directory to deploy to the specified target (prod or beta).

The function automatically:
- **For prod (from main):** Bumps version (intelligent patch/minor/major based on commit types), generates CHANGELOG using `standard-version`, commits, pushes to main, then merges/pushes to prod
- **For beta:** Deploys without version bump (beta is testing-only, no versioning)
- Detects merge conflicts and provides helpful guidance
- Returns to main branch after deployment

Usage:
- `ship` (from main) - Deploy to prod with auto version bump and CHANGELOG generation
- `ship prod` - Explicit prod deployment (bumps version)
- `ship beta` - Deploy to beta for testing (no version bump)
- `ship-beta` - Alias for `ship beta`
- `ship-prod` - Alias for `ship prod`

Smart behavior:
- **From main (default):** → prod (with version bump)
- **From main explicit:** `ship beta` → beta (no bump)
- **From beta:** → prod (automatically)

Version bumping logic (using `standard-version`):
- `feat:` commits → minor version bump
- `fix:` or `chore:` commits → patch version bump
- `BREAKING CHANGE:` → major version bump
- CHANGELOG auto-generated from commit history

The entire deployment pipeline is automated and requires no Claude involvement.
