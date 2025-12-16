# /git:finish

## Task

Complete the PR workflow: push, create PR, merge, and cleanup.

## What to do

Execute using Fish: `ghfinish`

This automatically:
1. Pushes the branch to remote
2. Creates a PR that closes the associated issue
3. Merges with squash merge strategy
4. Deletes the remote branch
5. Returns to main

## Requirements

- Must be on a feature branch (not main, beta, or prod)
- All changes must be committed
- Branch name must match: `<type>/<issue-#>-<slug>`
