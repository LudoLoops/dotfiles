# /git:ship

## Task

Deploy from main to prod with automatic version bumping.

## What to do

Execute the Fish function using Bash: `ship`

This automatically:
1. Verifies git status is clean
2. Bumps version using `standard-version`
3. Generates CHANGELOG automatically
4. Merges main → prod (fast-forward only)
5. Returns to main branch

## Requirements

- Must be on main branch
- Working directory must be clean
- `package.json` must exist
- `standard-version` installed via pnpm
