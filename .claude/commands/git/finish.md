# /git:finish

Complete the PR workflow: push, create PR, and squash merge.

## What to do

Execute using Fish: `ghfinish`

This function automatically:
1. Pushes the feature branch to remote
2. Creates a pull request
3. Squash merges the PR to main
4. Deletes the remote branch
5. Returns to main branch

## Requirements

- Must be on a feature branch (not main, beta, or prod)
- All changes must be committed
