# Code Optimization Review

Analyze code performance issues and suggest optimizations based on real metrics.

## Prerequisites:

Before this analysis, run:
```fish
check-quality    # Validates TypeScript, ESLint, and tests
```

This ensures code quality baseline before optimization review.

## How it works:

1. **Real Metrics Collection**:
   - TypeScript compilation time
   - Linting issues (which slow down builds)
   - Test coverage overview
   - Bundle size (if SvelteKit/build tool available)

2. **Claude Analysis**:
   - Reviews your code structure
   - Identifies performance bottlenecks
   - Suggests specific optimizations

## Usage:

```fish
# Step 1: Verify code quality
check-quality

# Step 2: I analyze the output and suggest optimizations
# [Describe your performance concerns or just ask for analysis]
```

## Optimization focus areas:

- **Runtime Performance**
  - Inefficient loops, algorithms
  - Unnecessary re-renders (Svelte)
  - Bundle size analysis

- **Build Performance**
  - Long compilation times
  - Heavy dependencies
  - Unused imports/code

- **Memory Usage**
  - Memory leaks
  - Large object allocations
  - Event listener cleanup

- **Database Queries**
  - N+1 query problems
  - Missing indexes
  - Inefficient joins

## Example workflow:

```fish
# Run quality checks first
check-quality

# Then ask for optimization analysis
# "The dashboard page is slow to load, analyze performance"
# or "Review bundle size and suggest optimizations"

# Claude will:
# 1. See the code quality baseline
# 2. Analyze your specific concerns
# 3. Suggest concrete optimizations
```

## Output Interpretation:

| Metric | Good | Warning | Bad |
|--------|------|---------|-----|
| TypeScript build | < 5s | 5-15s | > 15s |
| ESLint warnings | 0 | 1-5 | > 5 |
| Test pass rate | 100% | 90-99% | < 90% |

---

## Token Efficiency:

- ✅ Real metrics reduce hallucination
- ✅ Concrete data for analysis
- ✅ Faster iteration on fixes
- ✅ Measurable improvements

**This command combines shell execution (real data) with Claude analysis (intelligence).**
