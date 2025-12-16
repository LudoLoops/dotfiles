# /git:branch

Create a feature branch with interactive type selection from a label list.

## What to do

Execute using Fish: `ghbranch <slug>`

This will:
1. Ask you to select the branch type from a list
2. Create the branch: `<type>/<slug>`

No issue number needed - just provide the slug and choose the type.

## Example

```fish
ghbranch add-auth

# Prompts:
# Select branch type:
#   1) feat      - New feature
#   2) fix       - Bug fix
#   3) refactor  - Code refactoring
#   4) docs      - Documentation
#   5) test      - Tests
#   6) chore     - Chore
#   7) perf      - Performance
#   8) style     - Style
# Choice (1-8): 1

# Creates: feat/add-auth
```

## Related commands

- `/git:start` - Create branch from GitHub issue (auto-detects type from label)
- `/git:finish` - Push, create PR, and squash merge
