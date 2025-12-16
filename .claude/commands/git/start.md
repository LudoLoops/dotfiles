# /git:start

Create a feature branch from a GitHub issue, using the issue's label as the type.

## What to do

Execute using Fish: `ghstart <issue-number>`

The function will:
- Fetch the issue's first label (e.g., "feat", "fix", "docs")
- Create a branch: `<issue-#>-<slug>` (without type prefix)
- Store the type in the GitHub label
- Automatically determine the slug from the issue title

## Examples

```fish
ghstart 42
→ If issue #42 has label "feat": creates branch 42-add-user-auth
→ Type is stored in GitHub label: feat
```

If issue has no label, it will ask you to add one interactively.

## Workflow

```
Issue #42 with label "feat"
         ↓
ghstart 42
         ↓
Branche: 42-add-user-auth
Type: feat (from GitHub label)
         ↓
When finishing: /git:finish reads type from label
```

## Related commands

- `/git:branch` - Create branch without issue (for quick changes)
- `/git:finish` - Push, create PR, and squash merge
