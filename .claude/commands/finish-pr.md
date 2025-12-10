# gh-finish: Complete PR Workflow

Complete the entire PR workflow in one command: push → create PR → squash merge → cleanup.

Part of the `gh-start` / `gh-finish` workflow pair for starting and finishing GitHub issues.

## Quick Start

```fish
gh-start 42              # Create branch from issue #42
# ... make changes ...
commit feat: add feature # Commit changes (conventional commit)
gh-finish               # Push, PR, merge, cleanup - ALL AUTOMATED!
```

## How it works:

Run `gh-finish` from a feature branch to automatically:

1. ✅ **Push** the current branch to remote with upstream tracking
2. ✅ **Create PR** from branch → main (auto-fills title, closes issue)
3. ✅ **Merge** with squash merge strategy
4. ✅ **Delete** the remote branch automatically
5. ✅ **Return** to main branch and pull latest

## Usage:

```fish
gh-finish
```

That's it! No arguments needed.

## Prerequisites:

- ✅ You must be on a feature branch (not main, beta, or prod)
- ✅ All changes must be committed
- ✅ Branch name must match pattern: `<type>/<issue-#>-<slug>`
- ✅ GitHub CLI (`gh`) must be installed and authenticated

## Example:

```fish
# Start an issue
gh-start 97

# Make changes and commit
# ... edit files ...
commit refactor: centralize footer component

# Finish the issue - handles everything
gh-finish

# Output:
# 📤 Step 1: Pushing branch to remote...
# ✅ Branch pushed
#
# 📝 Step 2: Creating PR for issue #97...
# ✅ PR created
#
# 🔀 Step 3: Merging PR (squash merge)...
# ✅ PR merged and remote branch deleted
#
# 🏠 Step 4: Returning to main...
# ✅ ✅ ✅ Workflow complete!
#    Issue #97 closed
#    PR merged with squash
#    Branch cleaned up
```

## What's included:

- ✅ **Protected branch check** - prevents running on main/beta/prod
- ✅ **Uncommitted changes detection** - forces you to commit first
- ✅ **Auto issue detection** - extracts issue # from branch name
- ✅ **Squash merge** - keeps history clean
- ✅ **Auto-close issue** - PR body includes "Closes #97"
- ✅ **Clean return** - pulls latest main before returning

## Aliases:

- `gh-finish` - Primary command
- `ghfinish` - Backwards compatibility alias

## Error Handling:

```fish
# ❌ Protected branch check
gh-finish  # (on main)
# Error: Cannot finish on protected branch: main

# ❌ Uncommitted changes check
gh-finish  # (has changes)
# Error: You have uncommitted changes
# 💡 Commit them first: commit '<type>: <message>'

# ❌ Branch name validation
gh-finish  # (on branch "my-branch")
# Error: Branch name doesn't match pattern: <type>/<issue-#>-<slug>
```

## Workflow Summary

```
Issue #42 exists on GitHub
    ↓
gh-start 42
    ↓
[Create local branch: feat/42-add-auth]
    ↓
... make changes ...
    ↓
commit feat: add authentication
    ↓
gh-finish
    ↓
[Push to origin]
    ↓
[Create PR (auto title from issue)]
    ↓
[Squash merge to main]
    ↓
[Delete remote branch]
    ↓
[Return to main, pull latest]
    ↓
✅ Done! Issue #42 closed, work complete
```

## Pro Tips

- 💡 Always use conventional commits: `commit feat: <description>`
- 💡 Issue numbers come from GitHub issue, not branch name
- 💡 Squash merge keeps main history clean (one commit per feature)
- 💡 The PR body automatically includes "Closes #42" to auto-close issues
- 💡 No manual GitHub interaction needed - fully automated
