function ghstart --description 'Create branch from GitHub issue'
    set issue_num $argv[1]

    # If no issue number provided, ask interactively
    if test -z "$issue_num"
        read -l -P "Issue number: " issue_num
        if test -z "$issue_num"
            echo "❌ Issue number required"
            return 1
        end
    end

    if not string match -qr '^[0-9]+$' "$issue_num"
        echo "❌ Issue number must be numeric"
        return 1
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Fetch issue data from GitHub
    set issue_data (gh issue view $issue_num --json title,labels --jq '{title: .title, labels: .labels[].name}' 2>/dev/null)

    if test -z "$issue_data"
        echo "❌ Could not fetch issue #$issue_num. Check if it exists."
        return 1
    end

    set issue_title (gh issue view $issue_num --json title --jq '.title' 2>/dev/null)
    set issue_labels (gh issue view $issue_num --json labels --jq '.labels[].name' 2>/dev/null | string split '\n')

    # Get type from labels (first label is the type)
    set issue_type ""
    if test (count $issue_labels) -gt 0 -a -n "$issue_labels[1]"
        set issue_type "$issue_labels[1]"
    else
        # No label found - propose to add one
        echo "⚠️  Issue #$issue_num has no labels"
        echo ""
        echo "Available types: feat, fix, refactor, docs, test, chore, perf, style"
        read -l -P "Add label: " issue_type

        if test -z "$issue_type"
            echo "❌ Label required"
            return 1
        end

        # Try to add the label to the issue
        if not gh issue edit $issue_num --add-label "$issue_type" 2>/dev/null
            echo ""
            echo "⚠️  Label '$issue_type' doesn't exist in the repo"
            read -l -P "Create standard labels? (y/n) " create_labels

            if string match -iq "y" "$create_labels"
                echo ""
                setup-labels
                echo ""
                # Try adding label again
                gh issue edit $issue_num --add-label "$issue_type" 2>/dev/null && echo "✅ Label added"
            else
                echo "❌ Cannot proceed without labels"
                return 1
            end
        else
            echo "✅ Label added"
        end
    end

    # Clean title (remove type prefix if present)
    set title_clean "$issue_title"
    if string match -qi "$issue_type:*" "$issue_title"
        set title_clean (string sub -s (math (string length $issue_type) + 3) "$issue_title" | string trim)
    end

    # Validate type
    if not string match -q -r '^(feat|fix|refactor|docs|test|chore|perf|style)$' "$issue_type"
        echo "❌ Invalid type. Use: feat, fix, refactor, docs, test, chore, perf, style"
        return 1
    end

    # Convert title to slug (lowercase, replace spaces with dashes)
    set slug (string lower "$title_clean" | string replace -ra ' ' '-' | string replace -ra '[^a-z0-9-]' '')

    set branch_name "$issue_type/$issue_num-$slug"

    echo "🔀 Creating branch: $branch_name"
    echo "   Type: $issue_type (from label)"
    echo "   Title: $title_clean"

    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end

function ghbranch --description 'Create a branch with type: ghbranch <type> <issue-number> <slug>'
    if test (count $argv) -lt 3
        echo "Usage: ghbranch <type> <issue-number> <slug>"
        echo "Example: ghbranch feat 42 add-auth"
        echo ""
        echo "Available types: feat, fix, refactor, docs, test, chore, perf, style"
        echo "Creates branches like: feat/42-add-auth"
        return 1
    end

    set branch_type $argv[1]
    set issue_num $argv[2]
    set slug $argv[3]

    if not string match -qr '^[0-9]+$' "$issue_num"
        echo "❌ Issue number must be numeric"
        return 1
    end

    # Validate type
    if not string match -q -r '^(feat|fix|refactor|docs|test|chore|perf|style)$' "$branch_type"
        echo "❌ Invalid type. Use: feat, fix, refactor, docs, test, chore, perf, style"
        return 1
    end

    set branch_name "$branch_type/$issue_num-$slug"

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end
