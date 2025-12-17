---
allowed-tools: Bash(git:*), Bash(fish:*), AskUserQuestion, Read
description: Create a commit with intelligent message generation
argument-hint: "[message]"
---

# Create commit with intelligent message

## Step 1: Verify branch

Current branch: !`git branch --show-current`

**🚫 STOP HERE if branch is main, beta, or prod**

If on a protected branch:
```
❌ Cannot commit to main/beta/prod

✅ Create a feature branch first:
   /git:branch <type> <slug>

Examples:
   /git:branch fix button-alignment
   /git:branch feat user-auth
   /git:branch docs readme-update
```

Only continue if on a feature branch (e.g., `fix/123-slug`, `feat/my-feature`)

## Step 2: Analyze changes

!`git diff --cached --stat || git status --short`

## Step 3: Create commit

!`if [ -z "$1" ]; then echo "❌ Message required. Usage: /git:commit 'your message here'"; exit 1; else fish -c "commit '$1'"; fi`

---

## Examples

- `/git:commit "update button alignment"` → Creates commit with that message
- `/git:commit` → Analyzes changes, generates descriptive message, asks for confirmation
