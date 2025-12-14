function gh-start --description 'Create branch from GitHub issue: gh-start <issue-number> [type]'
    if test (count $argv) -eq 0
        echo "Usage: gh-start <issue-number> [type]"
        echo "Example: gh-start 42"
        echo "         gh-start 42 fix"
        echo ""
        echo "Types: feat, fix, refactor, docs, test, chore, perf, style"
        echo ""
        echo "Type is optional - it will be inferred from the issue title if not provided."
        return 1
    end

    set issue_num $argv[1]
    set issue_type $argv[2]

    if not string match -qr '^[0-9]+$' "$issue_num"
        echo "❌ Issue number must be numeric"
        return 1
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Fetch issue title from GitHub
    set issue_title (gh issue view $issue_num --json title --jq '.title' 2>/dev/null)

    if test -z "$issue_title"
        echo "❌ Could not fetch issue #$issue_num. Check if it exists."
        return 1
    end

    # If type not provided, infer from issue title
    set title_clean "$issue_title"
    if test -z "$issue_type"
        # Check if title starts with conventional commit format (type: description)
        if string match -qi 'feat:*' "$issue_title"
            set issue_type "feat"
            set title_clean (string sub -s 6 "$issue_title" | string trim)
        else if string match -qi 'fix:*' "$issue_title"
            set issue_type "fix"
            set title_clean (string sub -s 5 "$issue_title" | string trim)
        else if string match -qi 'refactor:*' "$issue_title"
            set issue_type "refactor"
            set title_clean (string sub -s 10 "$issue_title" | string trim)
        else if string match -qi 'docs:*' "$issue_title"
            set issue_type "docs"
            set title_clean (string sub -s 6 "$issue_title" | string trim)
        else if string match -qi 'test:*' "$issue_title"
            set issue_type "test"
            set title_clean (string sub -s 6 "$issue_title" | string trim)
        else if string match -qi 'perf:*' "$issue_title"
            set issue_type "perf"
            set title_clean (string sub -s 6 "$issue_title" | string trim)
        else if string match -qi 'style:*' "$issue_title"
            set issue_type "style"
            set title_clean (string sub -s 7 "$issue_title" | string trim)
        else if string match -qi 'chore:*' "$issue_title"
            set issue_type "chore"
            set title_clean (string sub -s 7 "$issue_title" | string trim)
        else
            # Fallback: check title for type keywords
            set title_lower (string lower "$issue_title")

            if string match -qi '*fix*' "$title_lower" || string match -qi '*bug*' "$title_lower" || string match -qi '*repair*' "$title_lower"
                set issue_type "fix"
            else if string match -qi '*refactor*' "$title_lower" || string match -qi '*cleanup*' "$title_lower" || string match -qi '*reorganize*' "$title_lower"
                set issue_type "refactor"
            else if string match -qi '*doc*' "$title_lower" || string match -qi '*readme*' "$title_lower"
                set issue_type "docs"
            else if string match -qi '*test*' "$title_lower" || string match -qi '*spec*' "$title_lower"
                set issue_type "test"
            else if string match -qi '*perf*' "$title_lower" || string match -qi '*optim*' "$title_lower" || string match -qi '*speed*' "$title_lower"
                set issue_type "perf"
            else if string match -qi '*style*' "$title_lower" || string match -qi '*format*' "$title_lower"
                set issue_type "style"
            else if string match -qi '*chore*' "$title_lower" || string match -qi '*update*' "$title_lower" || string match -qi '*upgrade*' "$title_lower"
                set issue_type "chore"
            else
                # Default to feat for features/new functionality
                set issue_type "feat"
            end
        end
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
    echo "   Type: $issue_type (inferred from issue title)"

    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end

# Alias for backwards compatibility
alias ghstart='gh-start'

function gh-branch --description 'Create a feature branch from issue number: gh-branch <issue-number> <slug>'
    if test (count $argv) -lt 2
        echo "Usage: gh-branch <issue-number> <slug>"
        echo "Example: gh-branch 42 add-auth-method"
        echo ""
        echo "Creates branches like: feat/42-add-auth-method"
        return 1
    end

    set issue_num $argv[1]
    set slug $argv[2]

    if not string match -qr '^[0-9]+$' "$issue_num"
        echo "❌ Issue number must be numeric"
        return 1
    end

    # Determine type from gh CLI if possible, default to feat
    set branch_type "feat"

    set branch_name "$branch_type/$issue_num-$slug"

    if git rev-parse --git-dir >/dev/null 2>&1
        git checkout -b "$branch_name"
        echo "✅ Created and checked out branch: $branch_name"
    else
        echo "❌ Not a git repository"
        return 1
    end
end
