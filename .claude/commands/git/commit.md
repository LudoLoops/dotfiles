# /git:commit

## Task

Create a commit using the Fish `commit` function.

## What to do

1. If the user provided a message, use it as-is
2. If no message provided:
   - Analyze the changed files using `git diff`
   - Generate a pertinent, concise commit message
3. Execute the commit using Bash: `commit "your message"`

## Examples

User input: `/git:commit "add login form validation"`
→ Execute: `commit "add login form validation"`

User input: `/git:commit` (empty)
→ Analyze changes
→ Generate message (e.g., "add user authentication")
→ Execute: `commit "add user authentication"`
