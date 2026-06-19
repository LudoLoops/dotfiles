function glstart --description 'Create branch from GitLab issue'
    set issue $argv[1]

    if test -z "$issue"
        read -l -P "Issue number: " issue
        if test -z "$issue"
            echo "❌ Issue number required"
            return 1
        end
    end

    if not string match -qr '^[0-9]+$' "$issue"
        echo "❌ Issue number must be numeric"
        return 1
    end

    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Fetch issue title and labels from glab
    set issue_json (glab issue view $issue --output json 2>/dev/null)

    if test -z "$issue_json"
        echo "❌ Could not fetch issue #$issue"
        return 1
    end

    set issue_title (echo "$issue_json" | python3 -c "import sys, json; print(json.load(sys.stdin)['title'])")

    # Slugify: lowercase, replace non-alphanumeric with dash, collapse, trim
    set slug (string lower "$issue_title" | string replace -ra '[^a-z0-9]' '-' | string replace -ra '-+' '-' | string trim -c '-')

    set branch "$issue-$slug"

    echo "🔀 Creating branch: $branch"
    echo "   Issue #$issue: $issue_title"

    git checkout -b "$branch"

    if test $status -ne 0
        echo "❌ Failed to create branch"
        return 1
    end

    git push -u origin "$branch" 2>&1

    if test $status -eq 0
        echo "✅ Created + pushed: $branch"
    else
        echo "✅ Branch created (push failed — run 'git push -u origin $branch')"
    end
end
