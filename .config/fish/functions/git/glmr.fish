function glmr --description 'Push current branch and create GitLab MR'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    set branch (git branch --show-current)

    if test -z "$branch"; or test "$branch" = "main"; or test "$branch" = "master"
        echo "❌ Switch to a feature branch first"
        return 1
    end

    # Extract issue number from branch name (e.g. 42-add-login → 42)
    set issue (string split -m1 '-' "$branch")[1]

    if not string match -qr '^[0-9]+$' "$issue"
        echo "❌ Could not extract issue number from branch: $branch"
        return 1
    end

    # Fetch issue title
    set issue_title (glab issue view $issue --output json 2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin)['title'])")

    if test -z "$issue_title"
        echo "❌ Could not fetch issue #$issue"
        return 1
    end

    echo "🚀 Pushing branch: $branch"

    git push -u origin "$branch"
    if test $status -ne 0
        echo "❌ Failed to push"
        return 1
    end

    echo "📋 Creating MR for issue #$issue"

    set mr_output (glab mr create \
        --title "$issue_title" \
        --target-branch main \
        --related-issue "$issue" \
        --remove-source-branch 2>&1)

    # Extract MR number from URL (e.g. .../merge_requests/42)
    # string match works on both Linux and macOS (fish builtins)
    set mr_url_line (echo "$mr_output" | grep 'merge_requests/')
    set mr_number ""
    if test -n "$mr_url_line"
        # Extract digits after "merge_requests/"
        set mr_number (string replace -rf '.*merge_requests/([0-9]+).*' '$1' "$mr_url_line")
    end

    if test -n "$mr_number"
        echo "✅ MR !$mr_number created for issue #$issue"
    else
        echo "$mr_output"
        echo "✅ MR created for issue #$issue"
    end
end
