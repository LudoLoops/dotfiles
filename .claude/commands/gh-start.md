# /gh-start: Create feature branch from GitHub issue

Execute the Fish function `gh-start` to automatically create a feature branch from a GitHub issue.

## Usage

```fish
/gh-start <issue-number> [type]
```

## Parameters

- `<issue-number>` (required) - GitHub issue number
- `[type]` (optional) - Branch type: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`
  - Defaults to `feat` if not specified

## What it does (via Fish gh-start function)

1. ✅ Fetches issue title from GitHub
2. ✅ Converts title to URL-safe slug (lowercase, spaces → dashes)
3. ✅ Creates branch: `<type>/<issue-#>-<slug>`
4. ✅ Checks out the new branch
5. ✅ Shows confirmation with branch name

## Examples

```fish
# Auto-detect type as 'feat'
/gh-start 42

# Specify type as 'fix'
/gh-start 15 fix

# Specify type as 'docs'
/gh-start 99 docs
```

## Standard Workflow

```fish
/gh-start 105              # Create branch from issue #105
# ... make changes ...
commit feat: add feature   # Commit with conventional commit
/gh-finish                 # Push, PR, merge, cleanup - ALL AUTOMATED!
```

## Generated Branch Names

Examples of branches created by `gh-start`:

- Issue #42 "Add user authentication" → `feat/42-add-user-authentication`
- Issue #15 "Fix login timeout" with `fix` → `fix/15-fix-login-timeout`
- Issue #99 "Update README" with `docs` → `docs/99-update-readme`

## Prerequisites

- GitHub CLI (`gh`) must be installed and authenticated
- Must be in a git repository
- Issue must exist on GitHub

## Supported Types

- `feat` - Feature implementation (default)
- `fix` - Bug fix
- `refactor` - Code refactoring
- `docs` - Documentation changes
- `test` - Test additions/updates
- `chore` - Maintenance tasks
- `perf` - Performance improvements
- `style` - Code style/formatting

## Error Handling

```fish
# ❌ Missing issue number
/gh-start
# Error: Issue number required

# ❌ Invalid issue type
/gh-start 42 invalid
# Error: Invalid type. Use: feat, fix, refactor, docs, test, chore, perf, style

# ❌ GitHub authentication issue
/gh-start 42
# Error: Failed to fetch issue from GitHub
# 💡 Run: gh auth login
```

## Smart Features

- ✅ Auto-detects issue type if not provided (defaults to `feat`)
- ✅ Fetches real issue title from GitHub (not manual input)
- ✅ Generates URL-safe branch names automatically
- ✅ Validates issue exists before creating branch
- ✅ Switches to new branch immediately

## Integration with gh-finish

`gh-start` and `gh-finish` work as a pair:

```fish
gh-start 42                    # Create feat/42-issue-slug
# ... edit files ...
commit feat: add new feature   # Commit changes
gh-finish                      # Auto push, PR, merge, cleanup
```

The branch name format (`<type>/<issue-#>-<slug>`) is essential for `gh-finish` to work correctly.

## Pro Tips

- 💡 Always use conventional commits after `gh-start`
- 💡 Specify type explicitly if it differs from `feat` (e.g., `gh-start 42 fix`)
- 💡 The issue number in the branch ensures PR auto-closes the issue
- 💡 Use `gh issue view <#>` to preview issue details before starting
