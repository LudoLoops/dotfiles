function ghstart --description 'Create branch from GitHub issue [type]'
    set issue_num $argv[1]
    set explicit_type $argv[2]

    # Valid branch types
    set valid_types feat fix refactor docs test chore perf style

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
    set issue_title (gh issue view $issue_num --json title --jq '.title' 2>/dev/null)

    if test -z "$issue_title"
        echo "❌ Could not fetch issue #$issue_num. Check if it exists."
        return 1
    end

    # Try to extract type from issue title (before first colon)
    set extracted_type ""
    if string match -q '*:*' "$issue_title"
        set extracted_type (string split ':' "$issue_title")[1] | string trim | string lower
    end

    # Map common aliases to valid types
    if test -n "$extracted_type"
        switch "$extracted_type"
            case bug
                set extracted_type fix
            case improvement
                set extracted_type feat
        end
    end

    # Determine which type to use
    set branch_type ""

    # 1. Use explicit type if provided
    if test -n "$explicit_type"
        set branch_type (string lower "$explicit_type")
        # Map aliases in explicit type too
        switch "$branch_type"
            case bug
                set branch_type fix
            case improvement
                set branch_type feat
        end
        if not contains "$branch_type" $valid_types
            echo "❌ Invalid type: '$explicit_type'"
            echo "Valid types: feat, fix, refactor, docs, test, chore, perf, style"
            return 1
        end
    # 2. Use extracted type if valid
    else if test -n "$extracted_type" && contains "$extracted_type" $valid_types
        set branch_type "$extracted_type"
        echo "✓ Using type from issue: '$branch_type'"
    # 3. Ask user to choose
    else
        if test -n "$extracted_type"
            echo "⚠️  Issue type '$extracted_type' not recognized"
        end
        echo "Select branch type:"
        echo "  1) feat      - New feature"
        echo "  2) fix       - Bug fix"
        echo "  3) refactor  - Code refactoring"
        echo "  4) docs      - Documentation"
        echo "  5) test      - Tests"
        echo "  6) chore     - Chore"
        echo "  7) perf      - Performance"
        echo "  8) style     - Style"
        read -l -P "Choice (1-8): " choice

        switch $choice
            case 1
                set branch_type feat
            case 2
                set branch_type fix
            case 3
                set branch_type refactor
            case 4
                set branch_type docs
            case 5
                set branch_type test
            case 6
                set branch_type chore
            case 7
                set branch_type perf
            case 8
                set branch_type style
            case '*'
                echo "❌ Invalid choice"
                return 1
        end
    end

    # Clean title (remove type prefix if present)
    set title_clean "$issue_title"
    if string match -qi "$branch_type:*" "$issue_title"
        set title_clean (string sub -s (math (string length $branch_type) + 3) "$issue_title" | string trim)
    end

    # Convert title to slug (lowercase, replace spaces with dashes)
    set slug (string lower "$title_clean" | string replace -ra ' ' '-' | string replace -ra '[^a-z0-9-]' '')

    # Create branch with type prefix
    set branch_name "$branch_type/$issue_num-$slug"

    echo "🔀 Creating branch: $branch_name"
    echo "   Issue: #$issue_num"
    echo "   Type: $branch_type"
    echo "   Title: $title_clean"

    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end
