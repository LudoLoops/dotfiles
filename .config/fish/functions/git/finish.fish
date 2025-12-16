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

    # Extract issue number from branch name (format: type/issue-slug or type-slug)
    set issue_number (string match -r '^[a-z]+/([0-9]+)' "$branch_name" | head -1)

    # Extract type from branch name
    set branch_type (string match -r '^([a-z]+)' "$branch_name" | head -1)

    set issue_type ""

    if test -n "$issue_number"
        # Issue-based branch: get type from issue labels
        set issue_labels (gh issue view $issue_number --json labels --jq '.labels[].name' 2>/dev/null | string split '\n')
        if test (count $issue_labels) -gt 0 -a -n "$issue_labels[1]"
            set issue_type "$issue_labels[1]"
        else
            # No label found - propose to add one
            echo "⚠️  Issue #$issue_number has no labels"
            echo ""
            echo "Available types: feat, fix, refactor, docs, test, chore, perf, style"
            read -l -P "Add label: " issue_type

            if test -z "$issue_type"
                echo "❌ Label required for commit prefix"
                return 1
            end

            # Try to add the label to the issue
            if not gh issue edit $issue_number --add-label "$issue_type" 2>/dev/null
                echo ""
                echo "⚠️  Label '$issue_type' doesn't exist in the repo"
                read -l -P "Create standard labels? (y/n) " create_labels

                if string match -iq "y" "$create_labels"
                    echo ""
                    setup-labels
                    echo ""
                    # Try adding label again
                    gh issue edit $issue_number --add-label "$issue_type" 2>/dev/null && echo "✅ Label added"
                else
                    echo "❌ Cannot proceed without labels"
                    return 1
                end
            else
                echo "✅ Label added"
            end
            echo ""
        end
    else
        # No issue: use type from branch name
        if not string match -q -r '^(feat|fix|refactor|docs|test|chore|perf|style)' "$branch_type"
            echo "❌ Branch name must start with valid type: feat, fix, refactor, docs, test, chore, perf, style"
            return 1
        end
        set issue_type "$branch_type"
        echo "✅ Using type from branch: $issue_type"
        echo ""
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
    if test -n "$issue_number"
        echo "📝 Step 2: Creating PR for issue #$issue_number..."
        # Get issue title for PR message
        set issue_title (gh issue view $issue_number --json title --jq '.title' 2>/dev/null)
        gh pr create --fill --title "$issue_type: $issue_title" --body "Closes #$issue_number"
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
