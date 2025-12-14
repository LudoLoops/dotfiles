# /gh-finish: Complete GitHub PR workflow

Execute the Fish function `gh-finish` to automatically merge PR, close issue, delete branch, and return to main.

## Function Location
`~/dotfiles/.config/fish/functions/git/workflow.fish`

## Usage

```
gh-finish
```

## What it does

1. ✅ Push branch to remote with upstream tracking
2. ✅ Create PR from branch → main (auto-fills title, closes issue)
3. ✅ Merge with squash merge strategy
4. ✅ Delete remote branch automatically
5. ✅ Return to main branch and pull latest

## Example

```
# After committing changes:
/gh-finish

# Output:
# 📤 Step 1: Pushing branch to remote...
# ✅ Branch pushed
#
# 📝 Step 2: Creating PR...
# ✅ PR created
#
# 🔀 Step 3: Merging PR (squash merge)...
# ✅ PR merged and remote branch deleted
#
# 🏠 Step 4: Returning to main...
# ✅ ✅ ✅ Workflow complete!
#    Issue closed
#    PR merged with squash
#    Branch cleaned up
```

## Prerequisites

- Must be on a feature branch (not main, beta, or prod)
- All changes must be committed
- Branch name must match: `<type>/<issue-#>-<slug>`
- GitHub CLI (`gh`) must be installed and authenticated

## Standard Workflow

```
/gh-start 105              # Create branch from issue #105
# ... make changes ...
commit feat: add feature   # Commit with conventional commit
/gh-finish                 # Push, PR, merge, cleanup - ALL AUTOMATED!
```

## What's Handled

- ✅ Protected branch check (prevents running on main/beta/prod)
- ✅ Uncommitted changes detection
- ✅ Auto issue detection from branch name
- ✅ Squash merge (keeps history clean)
- ✅ Auto-close issue (PR body includes "Closes #XX")
- ✅ Clean return to main with latest pull
