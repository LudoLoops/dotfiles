function ghbranch --description 'Create a branch interactively with type selection: ghbranch <slug>'
    if test (count $argv) -lt 1
        echo "Usage: ghbranch <slug>"
        echo "Example: ghbranch add-auth"
        echo ""
        echo "Prompts for type and creates branches like: feat/add-auth"
        return 1
    end

    set slug $argv[1]

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Interactive type selection
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

    set types feat fix refactor docs test chore perf style
    set branch_type ""

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
