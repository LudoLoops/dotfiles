---
allowed-tools: Bash(fish:*), Bash(gh:*), AskUserQuestion
description: Create feature branch from GitHub issue
argument-hint: <issue-number> [type]
---

# Create feature branch from GitHub issue

Execute: `ghstart <issue-number> [type]`

!ghstart "$1" "$2"

---

## What happens

This creates a feature branch from a GitHub issue with:
- **Smart type detection**: Extracts type from issue title (e.g., "docs: ..." → docs)
- **Alias mapping**: Maps common prefixes (bug → fix, improvement → feat)
- **Validation**: Checks if extracted type is valid, proposes menu if not
- **Override**: Pass explicit type to override auto-detection
- Branch format: `<type>/<issue-#>-<slug>`
- Auto-generated slug from issue title

## Valid types

`feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

## Type aliases (auto-mapped)

- `bug` → `fix`
- `improvement` → `feat`

## Examples

**Auto-detect from issue title:**
```
Issue: "docs: update CLAUDE.md and add guidelines"
Input: /git:start 42
Output: Creates branch `docs/42-update-claudemd-and-add-guidelines`
```

**Bug prefix mapped to fix:**
```
Issue: "bug: login form not working"
Input: /git:start 99
Output: Creates branch `fix/99-login-form-not-working`
```

**Override with explicit type:**
```
Input: /git:start 42 refactor
Output: Creates branch `refactor/42-title-slug`
```

**Invalid type in issue, asks user:**
```
Issue: "foo: some title"
Input: /git:start 42
Output: Shows menu to select type (foo is not recognized)
```
