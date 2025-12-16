# /git:finish

## Task

Complete the PR workflow: push, create PR with prefixed title, merge, and cleanup.

## What to do

Execute using Fish: `ghfinish`

This automatically:
1. Pushes the branch to remote
2. Checks if issue has a label (type); if not, asks you to add one
3. Creates a PR with title: `<type>: <issue-title>`
4. Squash merges the PR (creates commit with type prefix)
5. Closes the associated issue
6. Deletes the remote branch
7. Returns to main

## How it works

- Extracts issue number from branch name
- Reads the issue's first label as the commit type
- If no label: prompts you to add one (and adds it automatically)
- PR title becomes: `feat: add user authentication` (used for commit message on squash)
- This message is read by `standard-version` for version bumping

## Requirements

- Must be on a feature branch (not main, beta, or prod)
- All changes must be committed
- Branch name must match: `<type>/<issue-#>-<slug>`
