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

!`git diff --cached --stat`
!`git diff HEAD --stat`

## Step 3: Generate or use provided message

If you provided a message, use it as-is.

If not provided, analyze the diffs above and:
- Generate a concise, descriptive commit message
- Plain text describing what changed (no "type:" prefix)
- Ask user if they want to modify or confirm it

## Step 4: Execute commit

**Case 1: Message was provided**

If you provided a message argument, execute the commit:

!`fish -c "commit \"$ARGUMENTS\""`

---

**Case 2: No message provided**

If no message was provided (empty), generate and confirm one:

1. Based on the changes shown in Step 2, generate a descriptive message
2. Ask user to confirm or modify:

What commit message should be used?

(User will select from: Use suggested message, Modify the message, Cancel)

3. If user confirms/modifies, execute with the chosen message:

!`fish -c "commit \"<user-confirmed-message>\""`

---

## Examples

- `/git:commit "update button alignment"` → Creates commit with that message
- `/git:commit` → Analyzes changes, generates descriptive message, asks for confirmation
