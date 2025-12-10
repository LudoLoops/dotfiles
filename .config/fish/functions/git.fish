# git
alias g git
alias addup='git add -u'
alias addall='git add -A'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'

alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
# alias stat='git status' # 'status' is protected name so using 'stat' instead
alias git-deploy="git switch prod && git merge main && git push && git checkout main"
# github

function gh-workflow --description 'Complete GitHub workflow: gh-start issue → commit changes → gh-finish (push, PR, merge, cleanup)'
    echo "📋 GitHub Workflow Guide"
    echo ""
    echo "🚀 SIMPLIFIED WORKFLOW (Recommended)"
    echo ""
    echo "1️⃣  Start work on an issue:"
    echo "   gh-start <issue-number>"
    echo "   Example: gh-start 42"
    echo ""
    echo "2️⃣  Make changes and commit:"
    echo "   commit <type>: <description>"
    echo "   Example: commit feat: add JWT authentication"
    echo ""
    echo "3️⃣  Finish: Push, create PR, merge, cleanup (ALL AUTOMATED!):"
    echo "   gh-finish"
    echo ""
    echo "   That's it! gh-finish handles everything:"
    echo "   ✅ Pushes branch to remote"
    echo "   ✅ Creates PR (auto-fills title, closes issue)"
    echo "   ✅ Squash merges to main"
    echo "   ✅ Deletes remote branch"
    echo "   ✅ Returns to main"
    echo ""
    echo "---"
    echo ""
    echo "📚 MANUAL WORKFLOW (if you prefer step-by-step control)"
    echo ""
    echo "1️⃣  Create branch: gh-branch <issue-#> <slug>"
    echo "2️⃣  Make changes and commit: commit <type>: <description>"
    echo "3️⃣  Push: git push -u origin"
    echo "4️⃣  Create PR: gh-pr"
    echo "5️⃣  Merge: gh pr merge --squash --delete-branch"
    echo ""
    echo "✨ Commit types: feat, fix, refactor, docs, test, chore, perf, style"
end

function gh-start --description 'Create branch from GitHub issue: gh-start <issue-number> [type]'
    if test (count $argv) -eq 0
        echo "Usage: gh-start <issue-number> [type]"
        echo "Example: gh-start 42"
        echo "         gh-start 42 fix"
        echo ""
        echo "Types: feat, fix, refactor, docs, test, chore, perf, style"
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
    set issue_title (gh issue view $issue_num --json title --query '.title' 2>/dev/null)

    if test -z "$issue_title"
        echo "❌ Could not fetch issue #$issue_num. Check if it exists."
        return 1
    end

    # If type not provided, default to feat
    if test -z "$issue_type"
        set issue_type "feat"
    end

    # Validate type
    if not string match -q "feat|fix|refactor|docs|test|chore|perf|style" "$issue_type"
        echo "❌ Invalid type. Use: feat, fix, refactor, docs, test, chore, perf, style"
        return 1
    end

    # Convert title to slug (lowercase, replace spaces with dashes)
    set slug (string lower "$issue_title" | string replace -ra ' ' '-' | string replace -ra '[^a-z0-9-]' '')

    set branch_name "$issue_type/$issue_num-$slug"

    echo "🔀 Creating branch: $branch_name"

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

function compush --description 'git add, commit and push'
    commit $argv && git push
end

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

function gh-pr --description 'Create PR from current branch and close associated issue'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    set branch_name (git rev-parse --abbrev-ref HEAD)
    set issue_number (string match -r '^[a-z]+/([0-9]+)' "$branch_name" -c)

    if test -z "$issue_number"
        echo "❌ Branch name doesn't match pattern: <type>/<issue-#>-<slug>"
        echo "Current branch: $branch_name"
        return 1
    end

    echo "📝 Creating PR for issue #$issue_number..."
    gh pr create --fill --body "Closes #$issue_number"

    if test $status -eq 0
        echo "✅ PR created successfully"
    else
        echo "❌ Failed to create PR"
        return 1
    end
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

    # Extract issue number from branch name
    set issue_number (string match -r '^[a-z]+/([0-9]+)' "$branch_name" -c)

    if test -z "$issue_number"
        echo "❌ Branch name doesn't match pattern: <type>/<issue-#>-<slug>"
        echo "Current branch: $branch_name"
        return 1
    end

    # Check for uncommitted changes
    if not git diff-index --quiet HEAD --
        echo "❌ You have uncommitted changes"
        echo "💡 Commit them first: commit '<type>: <message>'"
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

# Alias for backwards compatibility
alias ghfinish='gh-finish'

function gh_create_issues_from_file
    set file $argv[1]
    if test -z "$file"
        set file "issues.txt"
    end

    if not test -f "$file"
        echo "❌ File not found: $file"
        return 1
    end

    echo "📤 Creating issues from $file..."

    for line in (cat $file)
        if test -z "$line"
            continue
        end
        echo "➡️  Creating issue: $line"
        gh issue create --title "$line" --body "Auto-created via gh CLI."
        sleep 1
    end
end

function git-echo-diff
    set first_commit (git rev-list --max-parents=0 HEAD)
    git log $first_commit..HEAD --pretty=tformat: --numstat | awk '{ added += $1; removed += $2 } END {
        printf "Insertions: %'\''d\nDeletions: %'\''d\nTotal changes: %'\''d\n", added, removed, added + removed
    }'
end

function gh-labels-init --description 'Initialize GitHub labels with standard commit types'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    set -l labels_data \
        "feat#a2eeef" \
        "fix#008672" \
        "refactor#d4c5f9" \
        "docs#0075ca" \
        "test#fbca04" \
        "chore#cccccc" \
        "perf#ff6b6b" \
        "style#ffd700"

    echo "📤 Creating standard commit type labels..."

    for label in $labels_data
        set parts (string split '#' "$label")
        set name $parts[1]
        set color $parts[2]

        echo "➡️  Creating label: $name"
        gh label create "$name" --description "Type: $name" --color "$color" 2>/dev/null || echo "   (label may already exist)"
    end

    echo "✅ Labels initialized"
end
