---
allowed-tools: Bash(gh:*), AskUserQuestion
description: Create a GitHub issue with intelligent type detection
argument-hint: "[description]"
---

# Create GitHub issue

## Step 1: Analyze issue type

Analyze the description to determine the best type:
- `feat` - New feature or enhancement
- `fix` - Bug fix
- `refactor` - Code refactoring
- `docs` - Documentation updates
- `test` - Test additions/updates
- `chore` - Maintenance tasks
- `perf` - Performance improvements
- `style` - Code style/formatting

## Step 2: Generate title

Create a concise, clear issue title (without type prefix)

Suggest to user and ask for confirmation

## Step 3: Check labels exist

Check if standard labels are created:
!`gh label list | grep -E "^(feat|fix|refactor|docs|test|chore|perf|style)" || echo "Labels missing"`

If missing, propose: "Create standard labels first? (recommended)"

If yes: !`fish -c "setup-labels"`

## Step 4: Create issue

!`gh issue create --title "$TITLE" --label "$TYPE"`

---

## Examples

- `/git:issue add user authentication` → Creates feat issue
- `/git:issue fix button alignment` → Creates fix issue
- `/git:issue update readme` → Creates docs issue
