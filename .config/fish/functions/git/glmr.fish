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

    # Detect repo from git remote
    set remote_url (git remote get-url origin 2>/dev/null)
    set repo ""
    if string match -q '*gitlab.com*' "$remote_url"
        set repo (string replace -rf '.*[:/]([^/]*/[^/]*)\.git$' '$1' "$remote_url")
        if test -z "$repo"
            set repo (string replace -rf '.*[:/]([^/]*/[^/]*)$' '$1' "$remote_url")
        end
    end

    # Fetch issue title — try with --repo first, fall back to current context
    set issue_title ""
    if test -n "$repo"
        set issue_title (glab issue view $issue --repo "$repo" --output json 2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin)['title'])" 2>/dev/null)
    else
        set issue_title (glab issue view $issue --output json 2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin)['title'])" 2>/dev/null)
    end

    # Fallback: use branch name if title fetch failed
    if test -z "$issue_title"
        set issue_title "$branch"
        echo "⚠️ Could not fetch issue title, using branch name"
    end

    echo "🚀 Pushing branch: $branch"

    git push -u origin "$branch"
    if test $status -ne 0
        echo "❌ Failed to push"
        return 1
    end

    echo "📋 Creating MR for issue #$issue: $issue_title"

    glab mr create \
        --title "$issue_title" \
        --target-branch main \
        --related-issue "$issue" \
        --remove-source-branch \
        --yes

    if test $status -eq 0
        echo "✅ MR created for issue #$issue"
    else
        echo "❌ Failed to create MR"
        return 1
    end
end
