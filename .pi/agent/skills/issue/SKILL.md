---
name: issue
description: Implement a GitHub or GitLab issue in its own Git worktree, validate, push, and open a PR/MR without merging. Use for issue implementation requests.
---

# Implement Issue

## Workflow

1. Read the full issue, relevant discussions, repository instructions, and acceptance criteria. Confirm the target repository and default branch.
2. Fetch the remote default branch and create a dedicated issue branch and worktree from its current tip. Never implement in the main worktree.
3. Inspect affected code and related tests before editing. Use tools selectively:
   - **Serena MCP**, when available: `find_symbol`, `get_symbols_overview`, and `find_referencing_symbols` for definitions, callers, TypeScript/Svelte consumers, and potential regressions. Separate actual calls/imports/usages from text matches, generated registries, fixtures, and documentation.
   - **Graphify**, only when initialized and useful: query the existing graph for cross-module dependencies or architectural impact. Confirm its findings in source code. A READY label or impact count does not prove correctness.
   - For small, localized changes, direct code reading/search may suffice. Avoid duplicate searches; stop when evidence is sufficient. If a tool fails or returns incomplete results, fall back to source inspection. Never infer that no dependencies exist merely because none were returned.
   - Never automatically run a full Serena index or rebuild Graphify just for investigation.
4. Implement only the issue's requested behavior in the worktree. Preserve existing interfaces, security boundaries, and repository conventions. Use Serena symbol editing only when safer than an ordinary patch.
5. Add/update regression tests for changed behavior, including relevant error paths and edge cases. Review the final diff for unintended changes.
6. Run applicable tests, lint, typecheck/check, and build. Fix failures caused by the change; disclose unresolved or unavailable checks rather than claiming they passed.
7. If Graphify was already initialized in the repository, ensure its tracked outputs are synchronized with the final code **once before opening the PR/MR**. Prefer the repository's existing update script/hook; do not regenerate on every edit or commit. Include required generated changes in the branch.
8. Commit the complete validated change, push its issue branch, and create a PR/MR targeting the correct branch. Check that the PR/MR exists and report its link and commit SHA.

## PR/MR description

Write clear, human-readable English:
- What changed and why.
- Tests/checks run and their results.
- Remaining limitations or known problems.
- `Closes #<issue>` where supported and referring to the correct linked issue.

## Rules

- Never edit or commit implementation changes in the main worktree or push directly to the default branch.
- Never merge the PR/MR or manually close the issue.
- No unrelated refactors, cleanup, or scope expansion.
- Serena is optional; Graphify is required only when previously initialized in the repository.
- Do not install tools/dependencies or change project configuration solely to enable optional analysis without justification.
- Never treat green CI, graph status, or tool output as proof of correctness.
- Stop after opening the PR/MR. Report the PR/MR URL, commit SHA, checks, and outstanding limitations.
