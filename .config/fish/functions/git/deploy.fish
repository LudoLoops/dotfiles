# =============================================================================
# Deployment Pipeline: Deploy main to prod (version bumping via feature branch)
# =============================================================================
# Deploy to prod with automatic version bumping via standard-version
#
# Workflow:
#   1. On main: run 'ship'
#   2. Creates feature branch 'chore/bump-version-X.Y.Z'
#   3. Runs standard-version to analyze commits and bump version
#   4. Commits version changes to feature branch
#   5. Creates PR and merges to main
#   6. Merges main → prod (no additional commits)
#
# Usage:
#   ship              # Deploy from main to prod with automatic version bumping
#
# Versioning (via standard-version):
#   feat:       → Minor bump (0.X.0)
#   fix:        → Patch bump (0.0.X)
#   chore:      → No bump (hidden, doesn't affect version)
#   BREAKING:   → Major bump (X.0.0)

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

    # Step 3: Get current version before bumping
    set current_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')

    # Step 4: Check if standard-version would detect changes
    echo "✓ Checking for commits since last version..."
    standard-version --dry-run 2>&1 >/dev/null
    if test $status -ne 0
        echo "ℹ️  No changes to bump version (feat/fix/perf commits required)"
        echo "📍 Current version: $current_version"
        echo "ℹ️  Skipping deployment"
        return 0
    end

    # Step 5: Create version bump branch
    echo "✓ Creating version bump branch..."
    set new_version (standard-version --dry-run 2>&1 | grep 'bumping version' | sed 's/.*bumping version.*to \([^)]*\).*/\1/' | tail -1)

    if test -z "$new_version"
        echo "ℹ️  Could not determine new version"
        return 1
    end

    set bump_branch "chore/bump-version-$new_version"

    git checkout -b "$bump_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to create branch: $bump_branch"
        return 1
    end

    # Step 6: Run standard-version to bump version and generate CHANGELOG
    echo "✓ Bumping version to $new_version..."
    standard-version 2>&1 >/dev/null
    or begin
        echo "❌ Failed to bump version"
        git checkout "$main_branch" >/dev/null 2>&1
        git branch -D "$bump_branch" >/dev/null 2>&1
        return 1
    end

    echo "   Version bumped to: $new_version"
    echo "   ✓ CHANGELOG generated automatically"

    # Step 7: Copy CHANGELOG to static/ if it exists
    if test -d static
        and test -f CHANGELOG.md
        cp CHANGELOG.md static/CHANGELOG.md
        git add static/CHANGELOG.md >/dev/null 2>&1
        echo "   ✓ CHANGELOG copied to static/"
    end

    # Step 8: Commit version changes
    echo "✓ Committing version changes..."
    git add -A >/dev/null 2>&1
    git commit --amend --no-edit >/dev/null 2>&1
    or begin
        echo "❌ Failed to commit version changes"
        git checkout "$main_branch" >/dev/null 2>&1
        git branch -D "$bump_branch" >/dev/null 2>&1
        return 1
    end

    # Step 9: Push bump branch
    echo "✓ Pushing version bump branch..."
    git push -u origin "$bump_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to push branch"
        return 1
    end

    # Step 10: Create and merge PR to main
    echo "✓ Creating PR for version bump..."
    set pr_url (gh pr create --title "chore: bump version $new_version" --body "Automatic version bump via standard-version" --head "$bump_branch" --base "$main_branch" 2>&1 | grep github.com)

    if test -z "$pr_url"
        echo "❌ Failed to create PR"
        git checkout "$main_branch" >/dev/null 2>&1
        return 1
    end

    echo "   PR created: $pr_url"

    # Step 11: Merge PR with squash
    echo "✓ Merging PR to $main_branch..."
    gh pr merge --squash --delete-branch >/dev/null 2>&1
    or begin
        echo "❌ Failed to merge PR"
        git checkout "$main_branch" >/dev/null 2>&1
        return 1
    end

    echo "   ✓ PR merged and branch deleted"

    # Step 12: Return to main and pull latest
    echo "✓ Returning to $main_branch..."
    git checkout "$main_branch" >/dev/null 2>&1
    git pull origin "$main_branch" >/dev/null 2>&1

    # Step 13: Merge main to prod (simple merge, no additional commits)
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
        echo "❌ Merge failed (likely not a fast-forward)"
        echo "ℹ️  Try: git merge $main_branch --no-ff"
        return 1
    end

    # Step 14: Push to prod (triggers auto-deploy)
    echo "✓ Pushing to prod (auto-deploy triggered)..."
    git push origin prod >/dev/null 2>&1
    or begin
        echo "❌ Failed to push to prod"
        return 1
    end

    # Step 15: Return to main
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
