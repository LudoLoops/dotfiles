# /git:start

## Task

Create a feature branch from a GitHub issue.

## What to do

1. Get the issue number from the user
2. Execute using Fish: `ghstart <issue-number>`

## Examples

User input: `/git:start 42`
→ Execute: `ghstart 42`

User input: `/git:start 15`
→ Execute: `ghstart 15`

The branch name format will be `<type>/<issue-#>-<slug>` where type is inferred from the issue title.
