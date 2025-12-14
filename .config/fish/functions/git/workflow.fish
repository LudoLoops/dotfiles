function commit --description 'git add and commit with conventional commit format or auto-commit with timestamp'
    set message "$argv"

    # If no arguments, use auto-commit with timestamp
    if test (count $argv) -eq 0
        set timestamp (date '+%d-%b-%Y %H:%M')
        set message "auto-commit: $timestamp"
    else
        # Validate conventional commit format (type: subject)
        if not string match -q '*:*' "$message"
            echo "❌ Invalid format. Use 'type: subject' (e.g., 'feat: add feature')"
            return 1
        end
    end

    git add -A && git commit -m "$message"
end

function gh-finish --description 'Complete PR workflow: push → create PR → squash merge → cleanup (requires uncommitted changes committed first)'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    set branch_name (git rev-parse --abbrev-ref HEAD)

    # Check if on a protected branch
    if string match -q "main|master|beta|prod" "$branch_name"
        echo "❌ Cannot finish on protected branch: $branch_name"
        echo "⚠️  Always work on feature branches, never on main/beta/prod"
        return 1
    end

    # Extract issue number from branch name (format: type/issue-slug)
    set issue_number (string match -r '^[a-z]+/([0-9]+)' "$branch_name" | head -1)

    if test -z "$issue_number"
        echo "❌ Branch name doesn't match pattern: <type>/<issue-#>-<slug>"
        echo "Current branch: $branch_name"
        return 1
    end

    # Check for uncommitted changes (both staged and unstaged)
    set status_output (git status --porcelain)
    if test -n "$status_output"
        echo "❌ You have uncommitted changes:"
        echo "$status_output"
        echo ""
        echo "💡 Either:"
        echo "   • Commit them: commit '<type>: <message>'"
        echo "   • Or stash them: git stash"
        return 1
    end

    echo "📤 Step 1: Pushing branch to remote..."
    git push -u origin "$branch_name"

    if test $status -ne 0
        echo "❌ Failed to push branch"
        return 1
    end
    echo "✅ Branch pushed"

    echo ""
    echo "📝 Step 2: Creating PR for issue #$issue_number..."
    gh pr create --fill --body "Closes #$issue_number"

    if test $status -ne 0
        echo "❌ Failed to create PR"
        return 1
    end
    echo "✅ PR created"

    echo ""
    echo "🔀 Step 3: Merging PR (squash merge)..."
    gh pr merge --squash --delete-branch

    if test $status -ne 0
        echo "❌ Failed to merge PR"
        return 1
    end
    echo "✅ PR merged and remote branch deleted"

    echo ""
    echo "🏠 Step 4: Returning to main..."
    git checkout main
    git pull origin main

    echo ""
    echo "✅ ✅ ✅ Workflow complete!"
    echo "   Issue #$issue_number closed"
    echo "   PR merged with squash"
    echo "   Branch cleaned up"
end
