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
