---
allowed-tools: Bash(fish:*), AskUserQuestion
description: Create feature branch manually
argument-hint: "[type] <slug>"
---

# Create feature branch

Execute: `ghbranch $ARGUMENTS`

!`fish -c "ghbranch $ARGUMENTS"`

---

## What happens

Creates a feature branch with format: `<type>/<slug>`

**Two modes:**

**Mode 1:** With type - `/git:branch feat my-feature` → `feat/my-feature`

**Mode 2:** Interactive - `/git:branch my-feature` → prompts for type selection

**Available types:** feat, fix, refactor, docs, test, chore, perf, style

## Example

Input: `/git:branch fix button-alignment`

Output: Creates branch `fix/button-alignment`
