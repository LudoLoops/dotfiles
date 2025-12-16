# /git:branch

Create a feature branch with type prefix.

## What to do

Execute using Fish: `ghbranch <type> <issue-number> <slug>`

Where:
- `<type>` is the commit type: feat, fix, refactor, docs, test, chore, perf, style
- `<issue-number>` is the GitHub issue number
- `<slug>` is a short description (lowercase, hyphens)

## Examples

```fish
ghbranch feat 42 add-auth
# Creates: feat/42-add-auth

ghbranch fix 15 button-alignment
# Creates: fix/15-button-alignment

ghbranch docs 8 update-readme
# Creates: docs/8-update-readme
```

## Related commands

- `/git:start` - Create branch from GitHub issue (auto-detects type from label)
- `/git:finish` - Push, create PR, and squash merge
