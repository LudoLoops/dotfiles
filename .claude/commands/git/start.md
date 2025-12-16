# /git:start

Create a feature branch from a GitHub issue.

## What to do

Execute using Fish: `ghstart <issue-number>`

The function will:
- Fetch the issue title
- Ask you to select the branch type (feat, fix, refactor, docs, test, chore, perf, style)
- Create a branch: `<type>/<issue-#>-<slug>`
- Automatically determine the slug from the issue title

## Example

```fish
ghstart 42

# Prompts:
# Select branch type:
#   1) feat      - New feature
#   2) fix       - Bug fix
#   ...

# You select: 1
# Creates branch: feat/42-add-user-auth
```

## Related commands

- `/git:branch` - Create branch without issue (for quick changes)
- `/git:finish` - Push, create PR, and squash merge
