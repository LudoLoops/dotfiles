# Smart Branch Creation (Optimized)

Create a feature branch with intelligent validation and consistency.

## How it works:

1. **Shell Execution**: Run `smart-branch <type> [issue-number]`
   ```fish
   smart-branch feat 42           # Creates: feat/42
   smart-branch fix               # Creates: fix/auto-1734000000 (timestamp)
   ```

2. **Validation**:
   - ✅ Confirms git repository
   - ✅ Switches to main/master if needed
   - ✅ Checks if branch already exists
   - ✅ Fetches latest from remote

3. **Result**: Branch created with guaranteed consistency

## Supported types:
`feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`

## Examples:

```fish
# From issue #42 - feature
smart-branch feat 42

# Bugfix without issue
smart-branch fix

# Refactoring task
smart-branch refactor 15
```

## Why this is better:

- ✅ **Deterministic**: Same result every time (no AI variation)
- ✅ **Token efficient**: No Claude analysis needed
- ✅ **Fast**: Instant execution
- ✅ **Reliable**: Git validation at every step
- ✅ **Feedback**: Clear status messages

## Integration with workflow:

```fish
smart-branch feat 42       # Create branch
check-quality              # Run code quality checks
commit feat: add feature   # Commit changes
compush                    # Push to remote
gh-pr                      # Create PR (auto-closes #42)
gh-finish                  # Merge and cleanup
```

## Note:

If you want Claude's intelligence to analyze your description and suggest the best type/name, use the classic git commands instead:
- `gh-start 42` - Claude analyzes issue title
- `gh-branch 42 custom-name` - Manual control

**This command prioritizes speed and consistency over AI analysis.**
