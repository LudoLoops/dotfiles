# /git:issue

## Task

Create a new GitHub issue with the best title and appropriate label. If labels don't exist, propose to create them.

## What to do

1. Get the description from the user
2. Analyze the description to determine the best type:
   - `feat` - New feature or enhancement
   - `fix` - Bug fix
   - `refactor` - Code refactoring
   - `docs` - Documentation updates
   - `test` - Test additions/updates
   - `chore` - Maintenance tasks
   - `perf` - Performance improvements
   - `style` - Code style/formatting
3. Generate a concise, clear issue title (without prefix)
4. Check if the label exists:
   - If yes: Execute `gh issue create --title "title" --label "TYPE"`
   - If no: Propose to create labels with `setup-labels`, then create the issue
5. The label will be used by `ghstart` and `ghfinish` to determine branch type and commit prefix

## Examples

User input: `/git:issue add user authentication`
→ Analyze: This is a new feature (feat)
→ Execute: `gh issue create --title "add user authentication" --label "feat"`

User input: `/git:issue button not aligned properly`
→ Analyze: This is a bug fix
→ Execute: `gh issue create --title "button not aligned properly" --label "fix"`

User input: `/git:issue update contributing guide`
→ Analyze: This is documentation
→ Execute: `gh issue create --title "update contributing guide" --label "docs"`

If labels don't exist:
→ Prompt: "Create standard labels? (y/n)"
→ If yes: Execute `setup-labels` first, then create the issue with label
