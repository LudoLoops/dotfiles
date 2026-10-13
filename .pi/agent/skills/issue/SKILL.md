---
name: issue
description: Implement GitHub/GitLab issues in isolated Git worktrees and safely clean up already-merged PR/MR worktrees. Use for issue implementation requests, merged PR/MR cleanup, or starting the next issue after a merge.
---

# Issue Lifecycle

Handle both **post-merge cleanup** and **issue implementation**. When implementing a new issue, first check whether a previous issue worktree in the **same repository** is ready for post-merge cleanup. Explicit requests such as `post-merge !24` or `cleanup PR #24` run only the cleanup phase.

## Preflight and post-merge cleanup

1. Identify the target repository, remote, default branch, and existing worktrees (`git worktree list --porcelain`). Match any candidate worktree and branch to its **specific** GitHub PR or GitLab MR. Do not sweep unrelated worktrees or guess associations.
2. Confirm the PR/MR is **merged on the remote** in the correct repository and base branch. If there is a linked issue, verify whether it is closed; if not, report it and leave the worktree untouched. If the PR/MR is open, closed unmerged, missing, or ambiguous, **do not clean it up**. Never merge a PR/MR just to enable cleanup.
3. Before touching local Git state, verify the exact worktree and local branch, check `git status --porcelain --untracked-files=all`, and ensure there are **no uncommitted or untracked changes**. Check the local branch tip against the reviewed PR/MR head: if it has additional or unmatched commits, stop instead of discarding them.
4. Check that the main worktree is clean and on the default branch. Fetch the remote and update the local default branch **fast-forward only** (`git pull --ff-only`). Never force, reset, rebase, or create an automatic merge to resolve divergence; report any blocker.
5. Only for a verified, merged, clean, correctly matched worktree: run `git worktree remove <path>` (without `--force`), then delete its local branch with `git branch -d <branch>`. If safe deletion refuses (for example, after a squash merge), report it rather than forcing deletion. Prune stale worktree metadata only if necessary.
6. Report cleanup performed or skipped and why. When invoked solely for cleanup, stop here. When starting another issue, proceed if there is no unsafe conflict; **do not reuse, remove, or overwrite** a still-active/unmerged issue worktree. If the requested new work would conflict with unfinished work, stop and request an explicit decision about parallel work.

## Implement an issue

1. Read the complete issue, relevant discussions, repository instructions, and acceptance criteria. Confirm the target repository and default branch.
2. From the updated remote default-branch tip, create a **new dedicated issue branch and worktree**. Never implement in the main worktree. Do not reuse an earlier issue's branch or worktree.
3. Inspect affected code and related tests before editing. Use tools selectively:
   - **Serena MCP**, when available: `find_symbol`, `get_symbols_overview`, and `find_referencing_symbols` for definitions, callers, TypeScript/Svelte consumers, and potential regressions. Separate actual calls/imports/usages from text matches, generated registries, fixtures, and documentation.
   - **Graphify**, only when initialized and useful: query the existing graph for cross-module dependencies or architectural impact. Confirm its findings in source code. A READY label or impact count does not prove correctness.
   - For small, localized changes, direct code reading/search may suffice. Avoid duplicate searches; stop when evidence is sufficient. If a tool fails or returns incomplete results, fall back to source inspection. Never infer that no dependencies exist merely because none were returned.
   - Never automatically run a full Serena index or rebuild Graphify just for investigation.
4. Implement only the requested behavior in the issue worktree. Preserve existing interfaces, security boundaries, and repository conventions. Use Serena symbol editing only when safer than an ordinary patch.
5. Add/update regression tests for changed behavior, including relevant error paths and edge cases. Review the final diff for unintended changes.
6. Run applicable tests, lint, typecheck/check, and build. Fix failures caused by the change; disclose unresolved or unavailable checks rather than claiming they passed.
7. If Graphify was already initialized in the repository, synchronize its tracked outputs with the final code **once before opening the PR/MR**. Prefer the repository's existing update script/hook; do not regenerate on every edit or commit. Include required generated changes.
8. Commit the validated change, push its issue branch, and create a PR/MR against the correct base. Check that it exists and report its link and commit SHA.

## PR/MR description

Write clear, human-readable English:
- What changed and why.
- Tests/checks run and their results.
- Remaining limitations or known problems.
- `Closes #<issue>` where supported, with the correct linked issue.

## Safety rules

- Never delete a worktree with uncommitted/untracked files or an unverified merge status.
- Never delete the remote branch unless explicitly requested. Never delete or overwrite an unrelated worktree.
- Never edit or commit **issue implementation** in the main worktree or push implementation directly to the default branch.
- Never merge the PR/MR or manually close the issue. Stop implementation after opening the PR/MR.
- No unrelated refactors, cleanup, or scope expansion.
- Serena is optional; Graphify is required only when previously initialized in the repository.
- Do not install tools/dependencies or change project configuration solely to enable optional analysis without justification.
- Never treat green CI, graph status, or tool output as proof of correctness.
- Report PR/MR URL, commit SHA, checks, and limitations after implementation; for cleanup, report remote merge/issue status, default-branch update, worktree and branch removal, and blockers.
