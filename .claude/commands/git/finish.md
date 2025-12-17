---
allowed-tools: Bash(fish:*), Bash(git:*), AskUserQuestion, Read
description: Complete PR workflow - push, create PR, and merge
---

# Complete PR workflow with context

## Step 1: Analyze PR context

Current branch: !`git branch --show-current`

Commits to include: !`git log main..HEAD --oneline`

---

## Step 2: Optionally enrich PR

Before executing ghfinish, you can:
- Suggest a custom PR title (beyond auto-detected issue title)
- Propose additional context or notes for the PR
- Ask user if they want any modifications

Then ask: "Ready to complete the PR workflow?"

---

## Step 3: Execute ghfinish workflow

!`fish -c "ghfinish"`

---

## ⚠️ Requirements

**🚫 STOP HERE if branch is main, beta, or prod**

If on a protected branch:
```
❌ Cannot finish PR on main/beta/prod

✅ Create a feature branch first:
   /git:branch <type> <slug>
```

**Other requirements:**
- All changes must be committed (use `/git:commit` if needed)
- Branch name format: `<type>/<issue-#>-<slug>` (e.g., `fix/146-button-alignment`)
  - Issue number is automatically extracted and used to close the issue

---

## What this does

1. ✅ Pushes the feature branch to remote
2. ✅ Creates a pull request with:
   - Auto-detected issue title from GitHub
   - List of all commits included in the PR
   - "Closes #issue-number" to auto-close the ticket
3. ✅ Squash merges the PR to main
4. ✅ Deletes the remote branch
5. ✅ Returns to main branch
