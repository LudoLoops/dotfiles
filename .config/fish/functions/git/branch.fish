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
