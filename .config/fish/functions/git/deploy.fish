# =============================================================================
# Unified Deployment Pipeline (Prod Only)
# =============================================================================
# Automated deployment to prod with version bumping and auto-deploy
#
# Usage:
#   ship              # From main: Deploy to prod (bumps version via standard-version)
#   ship prod         # Explicit prod deployment (bumps version via standard-version)
#
# Versioning (handled by standard-version):
#   feat:       → Minor bump (0.X.0)
#   fix:        → Patch bump (0.0.X)
#   chore:      → Patch bump (0.0.X)
#   BREAKING:   → Major bump (X.0.0)

function ship --description "Deploy to prod from main: ship [prod]"
    set target $argv[1]

    # Check if we're in a git repository first
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Check if package.json exists
    if not test -f package.json
        echo "❌ package.json not found"
        return 1
    end

    # Get current branch
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || echo "main")

    # Default target is prod
    if test -z "$target"
        set target prod
    end

    # Validate target argument
    if not test "$target" = prod
        echo "❌ Invalid target: $target"
        echo "ℹ️  Use: ship  or  ship prod"
        return 1
    end

    # Must be on main to deploy
    if test "$current_branch" != "$main_branch"
        echo "❌ Must be on $main_branch branch to deploy to prod"
        echo "ℹ️  You are on: $current_branch"
        echo "ℹ️  Run: git checkout $main_branch"
        return 1
    end

    # Show warning for prod deployment
    echo "⚠️  Deploying to PRODUCTION"
    echo "ℹ️  Make sure all tests pass before deploying"
    echo ""

    echo "🚀 Starting deployment to prod..."
    echo ""

    # Step 1: Verify working directory is clean
    echo "✓ Checking git status..."
    if not git diff-index --quiet HEAD --
        echo "❌ Working directory has uncommitted changes"
        echo "ℹ️  Please commit or stash changes first"
        return 1
    end

    # Step 2: Fetch latest from remote
    echo "✓ Fetching latest from remote..."
    git fetch origin >/dev/null 2>&1
    or begin
        echo "❌ Failed to fetch from remote"
        return 1
    end

    # Step 3: Pull latest changes from main
    echo "✓ Pulling latest changes from $main_branch..."
    git pull origin "$main_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to pull from $main_branch"
        return 1
    end

    # Step 4: Bump version and generate CHANGELOG
    echo "✓ Bumping version and generating CHANGELOG..."
    pnpm exec standard-version 2>&1 >/dev/null
    or begin
        echo "❌ Failed to bump version"
        git checkout "$main_branch" >/dev/null 2>&1
        return 1
    end

    # Get the new version from package.json
    set new_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')
    set tag_name "v$new_version"
    echo "   Version bumped to: $new_version"
    echo "   ✓ CHANGELOG generated automatically"

    # Copy CHANGELOG.md to static/ for public access
    if test -f CHANGELOG.md
        cp CHANGELOG.md static/CHANGELOG.md
        echo "   ✓ CHANGELOG copied to static/"
    else
        echo "   ⚠️  CHANGELOG.md not found after generation"
    end

    # Stage the static/CHANGELOG.md copy
    echo "✓ Staging static/CHANGELOG.md..."
    git add static/CHANGELOG.md >/dev/null 2>&1

    # Amend the commit to include static/CHANGELOG.md
    git commit --amend --no-edit >/dev/null 2>&1
    or begin
        echo "⚠️  Could not amend commit, but version bump is done"
    end

    # Step 5: Push changes and tag to main
    echo "✓ Pushing changes and tag to $main_branch..."
    git push origin "$main_branch" "$tag_name" >/dev/null 2>&1
    or begin
        echo "❌ Failed to push to $main_branch"
        return 1
    end

    # Step 6: Switch to prod and merge
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

    echo "✓ Merging main into prod..."
    set merge_message "merge: release v$new_version to production"
    git merge "$main_branch" -m "$merge_message" >/dev/null 2>&1
    or begin
        echo "❌ Merge conflict detected. Please resolve manually."
        echo "ℹ️  Run: git merge --abort  and try again"
        return 1
    end

    # Step 7: Push to prod (triggers auto-deploy)
    echo "✓ Pushing to prod (auto-deploy triggered)..."
    git push origin prod >/dev/null 2>&1
    or begin
        echo "❌ Failed to push to prod"
        return 1
    end

    # Step 8: Return to main
    echo "✓ Returning to $main_branch..."
    git checkout "$main_branch" >/dev/null 2>&1

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
function ship-prod --description "Deploy to prod: ship prod"
    ship prod $argv
end
