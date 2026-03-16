#!/usr/bin/env fish
# Initialize standard-version configuration in the current project
# Copies .versionrc.json template from ~/.config/fish/templates/

function version-init --description 'Initialize standard-version config in current project'
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Check if .versionrc.json already exists
    if test -f .versionrc.json
        echo "⚠️  .versionrc.json already exists in this project"
        echo "ℹ️  Remove it first if you want to reinitialize"
        return 1
    end

    # Find the template file
    set template_path ~/.config/fish/templates/.versionrc.json

    if not test -f "$template_path"
        echo "❌ Template not found at: $template_path"
        return 1
    end

    # Copy the template to the project
    cp "$template_path" .versionrc.json
    or begin
        echo "❌ Failed to copy template"
        return 1
    end

    echo "✅ Initialized standard-version config"
    echo "   File created: .versionrc.json"
    echo "   Template source: $template_path"
    echo ""
    echo "📝 Next steps:"
    echo "   • Review .versionrc.json if needed"
    echo "   • Add it to git: git add .versionrc.json"
    echo "   • Use 'ship' to deploy with automatic version bumping"

    return 0
end
