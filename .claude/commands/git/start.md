# /git:start

## Task

Create a feature branch from a GitHub issue, using the issue's label as the branch type.

## What to do

1. Get the issue number from the user (or ask if missing)
2. Execute using Fish: `ghstart <issue-number>`

The function will:
- Fetch the issue's first label (e.g., "feat", "fix", "docs")
- Create a branch: `<label>/<issue-#>-<slug>`
- Automatically determine the slug from the issue title

## Examples

User input: `/git:start 42`
→ Execute: `ghstart 42`
→ If issue has label "feat": creates `feat/42-add-user-auth`
→ If issue has no label: asks you to add one

User input (shell): Just type `ghstart` (no args)
→ Function asks: "Issue number: "
→ You type: 42
→ Checks issue labels and creates branch
→ If no label: proposes to add one interactively
