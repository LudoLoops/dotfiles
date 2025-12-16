# /git:branch

Create a feature branch with optional type and slug.

## What to do

Execute using Fish: `ghbranch [type] <slug>`

Two usage modes:

### Mode 1: Direct with type
`ghbranch <type> <slug>`

If you know the type, provide it directly:
```fish
ghbranch feat nouvelle-feature
# Creates: feat/nouvelle-feature
```

Available types: feat, fix, refactor, docs, test, chore, perf, style

### Mode 2: Interactive (without type)
`ghbranch <slug>`

If you don't provide a type, it prompts you to choose from a label list:
```fish
ghbranch nouvelle-feature

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

# Creates: feat/nouvelle-feature
```

## Related commands

- `/git:start` - Create branch from GitHub issue (auto-detects type from label)
- `/git:finish` - Push, create PR, and squash merge
