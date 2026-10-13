---
name: post-merge
description: Clean up local Git state after a GitHub or GitLab MR/PR has been merged. Use when asked to clean up after a merged MR/PR by updating main and removing its worktree and local branch.
---

# Post-Merge Cleanup

Use this skill after a Merge Request / Pull Request has been merged.

Examples:

- `cleanup la MR !24`
- `!24 est mergée, nettoie`
- `post-merge !24`

## Workflow

1. Check the MR/PR remotely and confirm that it is actually merged.
2. If a linked issue exists, confirm that it is closed.
3. If the MR/PR is not merged, stop and report it.
4. Update the local `main` from the remote.
5. Identify the worktree and local branch associated with the merged MR/PR.
6. Check that the worktree contains no uncommitted changes.
7. Remove the worktree.
8. Delete the local branch.
9. Prune stale Git worktree metadata if necessary.

## Rules

- Never delete anything unless the MR/PR is confirmed merged.
- Never delete a worktree containing uncommitted changes.
- Never delete the remote branch unless explicitly requested.

## Final response

Report that:

- the MR/PR is merged
- the linked issue is closed, when applicable
- `main` is up to date
- the worktree was removed
- the local branch was removed
