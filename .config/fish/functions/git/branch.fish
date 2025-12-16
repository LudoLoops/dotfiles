function ghbranch --description 'Create branch: ghbranch [type] <slug>'
    if test (count $argv) -lt 1
        echo "Usage: ghbranch [type] <slug>"
        echo "  ghbranch feat add-auth           # Creates: feat/add-auth"
        echo "  ghbranch add-auth                # Prompts for type, then creates branch"
        return 1
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    set branch_type ""
    set slug ""

    # Check if first argument is a valid type
    if string match -q -r '^(feat|fix|refactor|docs|test|chore|perf|style)$' "$argv[1]"
        # First arg is type
        set branch_type $argv[1]
        if test (count $argv) -lt 2
            echo "❌ Slug required when type is provided"
            return 1
        end
        set slug $argv[2]
    else
        # First arg is slug, propose type selection
        set slug $argv[1]

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

    set branch_name "$branch_type/$slug"

    echo "🔀 Creating branch: $branch_name"

    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end
