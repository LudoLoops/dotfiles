# /gh-issues: List GitHub issues

Run `gh issue list` to display all open issues in the repository.

## Usage

```
/gh-issues
```

## What it does

Executes `gh issue list` and displays:
- Issue number
- Issue title
- State
- Labels
- Last update

## Example

```
/gh-issues

# Output from gh issue list:
Showing 12 of 12 open issues in ProNeXus-AI/Xtimator

#107  feat: improve caching system
#106  feat: add dark mode toggle
#105  feat: optimize performance
#104  fix: authentication bug
#103  docs: update API docs
...
```

## Quick workflow

See all issues and start working on one:

```
/gh-issues                  # List all open issues
/gh-start 105               # Start issue #105
# ... make changes ...
/gh-finish                  # Merge and close issue
```

## GitHub CLI reference

This is a direct wrapper for:
```bash
gh issue list
```

For more options with gh CLI:
- `gh issue list --state=all` - Show all issues
- `gh issue list --label="bug"` - Filter by label
- `gh issue list --assignee=@me` - Your assigned issues
