# Code Quality & Bug Review

Review code for bugs and suggest improvements based on real checks.

## Prerequisites:

Before code review, run:
```fish
check-quality    # Validates TypeScript, ESLint, and tests
```

This catches obvious errors and style issues automatically.

## How it works:

1. **Automated Checks** (via `check-quality`):
   - TypeScript type errors (catches ~80% of bugs)
   - ESLint violations (catches style and logical issues)
   - Test failures (validates functionality)

2. **Claude Deep Review**:
   - Logic and algorithm review
   - Edge cases and error handling
   - Code maintainability
   - Security considerations
   - Performance implications

## Usage:

```fish
# Step 1: Run automated checks
check-quality

# Step 2: Ask for review
# "Review my code for bugs" or "Check edge cases in auth logic"
```

## Review focuses on:

### Bug Detection
- Null/undefined checks
- Off-by-one errors
- Incorrect type usage
- Logic errors

### Code Quality
- Error handling
- Validation
- Edge cases
- Exception flow

### Security
- Input validation
- SQL injection risks
- XSS vulnerabilities
- Authentication/Authorization gaps

### Maintainability
- Complex logic simplification
- Better naming
- Separation of concerns
- Code duplication

## Example workflow:

```fish
# 1. Run checks
check-quality

# 2. If tests fail, review the failures:
# "Check-quality found these test failures - review what's wrong"

# 3. For logic review:
# "Review my authentication logic for security issues"

# 4. For specific files:
# "Review src/routes/dashboard/+page.svelte for bugs"
```

## What to expect:

### After `check-quality` passes:
- ✅ No type errors
- ✅ No linting issues
- ✅ All tests pass

### After Claude review:
- 📋 Logical issues identified
- 🔒 Security vulnerabilities flagged
- 🐛 Edge cases highlighted
- 💡 Improvement suggestions

## Token Efficiency:

- ✅ Automated checks remove obvious issues
- ✅ Claude focuses on complex logic
- ✅ Reduces back-and-forth iterations
- ✅ Concrete error messages aid analysis

**This command combines automated validation (precision) with Claude review (intelligence).**

---

## Integration with CI/CD:

The same `check-quality` checks should also run in your CI pipeline:

```yaml
# Example: .github/workflows/test.yml
- run: pnpm check          # TypeScript
- run: pnpm exec eslint    # Linting
- run: pnpm test           # Tests
```

**Local development matches CI validation.**
