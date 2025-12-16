function ghfinish --description 'Complete PR workflow: push → create PR → squash merge → cleanup'
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

    # Extract issue number from branch name (format: type/issue-slug) - optional
    set issue_number (string match -r '^[a-z]+/([0-9]+)' "$branch_name" | head -1)

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
    if test -n "$issue_number"
        echo "📝 Step 2: Creating PR for issue #$issue_number..."
        gh pr create --fill --body "Closes #$issue_number"
    else
        echo "📝 Step 2: Creating PR..."
        gh pr create --fill
    end

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
    if test -n "$issue_number"
        echo "   Issue #$issue_number closed"
    end
    echo "   PR merged with squash"
    echo "   Branch cleaned up"
end
