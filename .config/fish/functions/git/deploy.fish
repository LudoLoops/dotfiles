# =============================================================================
# Deployment Pipeline: Deploy main to prod via releases branch
# =============================================================================
# Deploy to prod with automatic version bumping via releases branch
#
# Workflow:
#   1. On main: run 'ship'
#   2. Creates releases/X.Y.Z branch
#   3. Runs standard-version to bump version
#   4. Merges releases/X.Y.Z → main → prod
#   5. Returns to main
#
# Usage:
#   ship              # Deploy from main to prod with automatic version bumping

function ship --description "Deploy to prod from main with automatic version bumping"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Check if package.json exists
    if not test -f package.json
        echo "❌ package.json not found"
        return 1
    end

    # Get current branch and main branch
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || echo "main")

    # Must be on main to deploy
    if test "$current_branch" != "$main_branch"
        echo "❌ Must be on $main_branch branch to deploy"
        echo "ℹ️  You are on: $current_branch"
        echo "ℹ️  Run: git checkout $main_branch"
        return 1
    end

    # Check for uncommitted changes
    if not git diff-index --quiet HEAD --
        echo "❌ Working directory has uncommitted changes"
        echo "ℹ️  Please commit or stash changes first"
        return 1
    end

    # Show warning for prod deployment
    echo "⚠️  Deploying to PRODUCTION"
    echo "ℹ️  Make sure all tests pass before deploying"
    echo ""
    echo "🚀 Starting deployment to prod..."
    echo ""

    # Step 1: Fetch latest
    echo "✓ Fetching latest from remote..."
    git fetch origin >/dev/null 2>&1
    or begin
        echo "❌ Failed to fetch from remote"
        return 1
    end

    # Step 2: Pull latest main
    echo "✓ Pulling latest changes from $main_branch..."
    git pull origin "$main_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to pull from $main_branch"
        return 1
    end

    # Step 3: Run standard-version to bump version (will create commit and tag)
    echo "✓ Bumping version and generating CHANGELOG..."
    standard-version 2>&1 >/dev/null
    or begin
        echo "❌ Failed to bump version"
        git checkout "$main_branch" >/dev/null 2>&1
        return 1
    end

    # Step 4: Get new version from package.json
    set new_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')
    if test -z "$new_version"
        echo "❌ Could not determine new version"
        git reset --hard HEAD~1 >/dev/null 2>&1
        return 1
    end

    # Step 5: Create releases branch with version number
    echo "✓ Creating releases/$new_version branch..."
    git checkout -b "releases/$new_version" >/dev/null 2>&1
    or begin
        echo "❌ Failed to create branch: releases/$new_version"
        git reset --hard HEAD~1 >/dev/null 2>&1
        return 1
    end

    echo "   Version bumped to: $new_version"
    echo "   ✓ CHANGELOG generated automatically"

    # Step 7: Copy CHANGELOG to static/
    if test -d static
        and test -f CHANGELOG.md
        cp CHANGELOG.md static/CHANGELOG.md
        git add static/CHANGELOG.md >/dev/null 2>&1
        echo "   ✓ CHANGELOG copied to static/"
    end

    # Step 8: Push releases branch
    echo "✓ Pushing releases/$new_version branch..."
    git push -u origin "releases/$new_version" >/dev/null 2>&1
    or begin
        echo "❌ Failed to push branch"
        return 1
    end

    # Step 9: Merge releases → main
    echo "✓ Merging releases/$new_version into $main_branch..."
    git checkout "$main_branch" >/dev/null 2>&1
    git pull origin "$main_branch" >/dev/null 2>&1
    git merge "releases/$new_version" --ff-only >/dev/null 2>&1
    or begin
        echo "❌ Merge failed"
        return 1
    end

    # Step 10: Push main
    echo "✓ Pushing $main_branch..."
    git push origin "$main_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to push $main_branch"
        return 1
    end

    # Step 11: Merge main → prod
    echo "✓ Switching to prod branch..."
    git checkout prod >/dev/null 2>&1
    or begin
        echo "❌ Failed to checkout prod branch"
        return 1
    end

    echo "✓ Pulling latest prod..."
    git pull origin prod >/dev/null 2>&1
    or begin
        echo "❌ Failed to pull prod"
        return 1
    end

    echo "✓ Merging $main_branch into prod..."
    git merge "$main_branch" --ff-only >/dev/null 2>&1
    or begin
        echo "❌ Merge failed"
        echo "ℹ️  Try: git merge $main_branch --no-ff"
        return 1
    end

    # Step 12: Push to prod (triggers auto-deploy)
    echo "✓ Pushing to prod (auto-deploy triggered)..."
    git push origin prod >/dev/null 2>&1
    or begin
        echo "❌ Failed to push to prod"
        return 1
    end

    # Step 13: Return to main
    echo "✓ Returning to $main_branch..."
    git checkout "$main_branch" >/dev/null 2>&1
    git pull origin "$main_branch" >/dev/null 2>&1

    # Success!
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "✅ Deployment to prod Successful!"
    echo "════════════════════════════════════════════════════════"
    echo "🎯 Version: $new_version"
    echo "📍 Branch: prod"
    echo "⏳ Auto-deploy in progress..."
    echo ""
    echo "ℹ️  Changes are now live in production!"
    echo "════════════════════════════════════════════════════════"

    return 0
end

# Alias for explicit prod deployment
function ship-prod --description "Deploy to prod: explicit command"
    ship $argv
end
