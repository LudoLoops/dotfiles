function git-echo-diff
    set first_commit (git rev-list --max-parents=0 HEAD)
    git log $first_commit..HEAD --pretty=tformat: --numstat | awk '{ added += $1; removed += $2 } END {
        printf "Insertions: %'\''d\nDeletions: %'\''d\nTotal changes: %'\''d\n", added, removed, added + removed
    }'
end

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
