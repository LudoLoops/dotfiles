# /git:issue

## Task

Create a new GitHub issue with the best title and appropriate prefix.

## What to do

1. Get the description from the user
2. Analyze the description to determine the best type:
   - `feat:` - New feature or enhancement
   - `fix:` - Bug fix
   - `refactor:` - Code refactoring
   - `docs:` - Documentation updates
   - `test:` - Test additions/updates
   - `chore:` - Maintenance tasks
   - `perf:` - Performance improvements
   - `style:` - Code style/formatting
3. Generate a concise, clear issue title
4. Execute using Fish: `gh issue create --title "TYPE: title"`

## Examples

User input: `/git:issue add user authentication`
→ Analyze: This is a new feature
→ Title: "feat: add user authentication"
→ Execute: `gh issue create --title "feat: add user authentication"`

User input: `/git:issue button not aligned properly`
→ Analyze: This is a bug fix
→ Title: "fix: button not aligned properly"
→ Execute: `gh issue create --title "fix: button not aligned properly"`

User input: `/git:issue update contributing guide`
→ Analyze: This is documentation
→ Title: "docs: update contributing guide"
→ Execute: `gh issue create --title "docs: update contributing guide"`
