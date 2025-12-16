# /git:commit

## Task

Create a commit using the Fish `commit` function.

## What to do

1. **FIRST: Verify the current git branch**
   - Run: `git branch --show-current`
   - If the result is `main`, `beta`, or `prod` → STOP and refuse to commit
   - Show error message: "❌ Cannot commit to protected branch (main/beta/prod). Create a feature branch first using `/git:branch <type> <slug>`"

2. If the user provided a message, use it as-is
3. If no message provided:
   - Analyze the changed files using `git diff`
   - Generate a pertinent, concise commit message
4. Execute the commit using Bash: `commit "your message"`

## Examples

User input: `/git:commit "add login form validation"`
→ Execute: `commit "add login form validation"`

User input: `/git:commit` (empty)
→ Analyze changes
→ Generate message (e.g., "add user authentication")
→ Execute: `commit "add user authentication"`
