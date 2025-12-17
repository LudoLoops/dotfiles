---
allowed-tools: Bash(fish:*), Bash(gh:*), AskUserQuestion
description: Create feature branch from GitHub issue
argument-hint: [issue-number]
---

# Create feature branch from GitHub issue

Execute: `fish -c "ghstart <issue-number>"`

!`fish -c 'ghstart '"$1"''`

---

## What happens

This creates a feature branch from a GitHub issue with:
- Automatic issue title fetching
- Interactive type selection (feat, fix, refactor, docs, test, chore, perf, style)
- Branch format: `<type>/<issue-#>-<slug>`
- Auto-generated slug from issue title

## Example

Input: `/git:start 42`

Output: Creates branch `feat/42-add-user-auth`
