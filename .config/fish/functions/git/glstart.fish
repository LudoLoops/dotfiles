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
    set issue_labels (echo "$issue_json" | python3 -c "import sys, json; print(' '.join(json.load(sys.stdin).get('labels', [])))")

    # Map type labels to branch prefixes
    set type_prefix ""
    for label in $issue_labels
        switch $label
            case feature
                set type_prefix "feat"; break
            case bug
                set type_prefix "fix"; break
            case devops
                set type_prefix "chore"; break
        end
    end

    # Slugify: lowercase, replace non-alphanumeric with dash, collapse, trim
    set slug (string lower "$issue_title" | string replace -ra '[^a-z0-9]' '-' | string replace -ra '-+' '-' | string trim -c '-')

    if test -n "$type_prefix"
        set branch "$issue-$type_prefix-$slug"
    else
        set branch "$issue-$slug"
    end

    echo "🔀 Creating branch: $branch"
    echo "   Issue #$issue: $issue_title"

    git checkout -b "$branch"

    if test $status -eq 0
        echo "✅ Checked out: $branch"
    else
        echo "❌ Failed to create branch"
        return 1
    end
end
