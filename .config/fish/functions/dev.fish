# =============================================================================
# Web Development Tools & Deployment Pipeline
# =============================================================================
# SvelteKit projects, Svelte routes, Go builds, Cursor IDE configuration,
# Git workflows, automated deployment (beta & production)

# SvelteKit Project Scaffolder
# Creates a new SvelteKit project with TypeScript, pnpm, minimal template,
# and pre-configured dependencies including Vitest, Tailwind CSS, ESlint,
# Prettier, Playwright, DevTools JSON, and Skeleton UI with Cerberus theme.
function sv-create --argument path
    # Check if path argument is provided
    if test -z "$path"
        echo "Error: Please specify a path for the project." >&2
        return 1
    end

    # Check if directory already exists
    if test -d "$path"
        echo "Error: Directory '$path' already exists." >&2
        return 1
    end

    # Create SvelteKit project with options
    command pnpx sv create --types ts --install pnpm --template minimal --no-add-ons "$path"
    or begin
        echo "Error: Failed to create SvelteKit project." >&2
        return 1
    end

    # Go to project directory
    cd "$path"
    or begin
        echo "Error: Could not enter directory '$path'." >&2
        return 1
    end

    # Add dependencies via sv add
    command pnpx sv add vitest tailwindcss sveltekit-adapter mcp eslint prettier playwright devtools-json --install pnpm
    or begin
        echo "Error: Failed to add dependencies." >&2
        return 1
    end

    # Install Skeleton UI packages
    command pnpm i -D @skeletonlabs/skeleton @skeletonlabs/skeleton-svelte
    or begin
        echo "Error: Failed to install Skeleton UI dependencies." >&2
        return 1
    end

    # Create or update layout.css with Tailwind and Skeleton imports
    set css_file src/routes/+layout.css
    if test ! -f "$css_file"
        command touch "$css_file"
    end

    command echo -e '@import \'tailwindcss\';\n@import \'@skeletonlabs/skeleton\';\n@import \'@skeletonlabs/svelte\';\n@import \'@skeletonlabs/skeleton/themes/cerberus\';' >> "$css_file"
    or begin
        echo "Error: Could not append to $css_file." >&2
        return 1
    end

    # Update src/app.html to set the theme
    set app_html src/app.html
    if test -f "$app_html"
        # Create a temporary file for cross-platform compatibility
        set temp_file (mktemp)
        command sed 's/<html/<html data-theme="cerberus"/' "$app_html" > "$temp_file"
        and mv "$temp_file" "$app_html"
        or begin
            echo "Error: Failed to update $app_html with data-theme." >&2
            rm -f "$temp_file"
            return 1
        end
    else
        echo "Error: $app_html not found." >&2
        return 1
    end

    echo "✅ Project '$path' created and configured successfully."
end

# Svelte Route Creator
# Creates new SvelteKit routes with +page.svelte files
function mkroute
    if test (count $argv) -eq 0
        echo "Usage: mkroute path1 [path2 ... pathN]"
        return 1
    end

    for dir in $argv
        set file "$dir/+page.svelte"

        # Create directory
        mkdir -p $dir

        # Create +page.svelte if it doesn't exist
        if not test -f $file
            touch $file
            echo "✔️  Created: $file"
        else
            echo "⚠️  File already exists: $file"
        end
    end
end

# SvelteForge - Custom build tool for SvelteKit
function svelteForge
    p dlx tsx ~/1Dev/Projects/Lelab/SvelteForge/svelteForge/index.ts
end

# Go Multi-Platform Build
# Builds Go projects for Linux, Windows, and macOS with compression and zipping
function go-build-multi
    set -l project_name (basename (pwd))
    set -l tool_version (git describe --tags ^/dev/null; or echo "dev")

    echo "📦 Building $project_name version: $tool_version"

    for os in linux windows darwin
        set -l ext ""
        set -l folder ""

        switch $os
            case linux
                set folder linux
            case windows
                set folder windows
                set ext ".exe"
            case darwin
                set folder macos
        end

        set -l output_dir dist/$folder
        mkdir -p $output_dir

        set -l outfile "$output_dir/$project_name$ext"

        echo "🔧 Building for $os..."
        env GOOS=$os GOARCH=amd64 go build -ldflags "-s -w -X main.version=$tool_version" -o $outfile .

        if test $status -eq 0
            echo "✅ Built: $outfile"
            if type -q upx
                upx --best --lzma $outfile
            end

            # 🔒 Zippage
            set -l zipfile "dist/$project_name-$os.zip"
            echo "📦 Zipping: $zipfile"
            zip -j $zipfile $outfile >/dev/null
            if test $status -eq 0
                echo "✅ Created zip: $zipfile"
            else
                echo "❌ Failed to zip $outfile"
            end
        else
            echo "❌ Failed to build for $os"
        end
    end

    echo "🎉 All builds and zips completed in dist/"
end

# Cursor IDE Rules Linker
# Select and symlink .mdc Cursor rules into .cursor/rules/
function cursor-rules --description "Select and symlink .mdc Cursor rules into .cursor/rules/"

    set rules_dir "$HOME/1Dev/cursor-rules"
    set target_dir ".cursor/rules"

    if not test -d $rules_dir
        echo "❌ Rules directory not found: $rules_dir"
        return 1
    end

    mkdir -p $target_dir

    set all_files (find $rules_dir -type f -iname '*.mdc' | sort)

    if test (count $all_files) -eq 0
        echo "❌ No .mdc rule files found in $rules_dir"
        return 1
    end

    echo "📄 Available .mdc rules: "

    for i in (seq 1 (count $all_files))
        echo "$i. "(basename $all_files[$i])
    end

    echo
    echo "Select rule numbers (e.g. 1 3 5) or  'A' to select all: "
    read -a selected

    if test -z "$selected"
        echo "⚠️ No selection made. Aborting."
        return 1
    end

    if test "$selected" = A -o "$selected" = all
        set selected (seq 1 (count $all_files))
    end

    for index in $selected
        if test $index -gt 0 -a $index -le (count $all_files)
            set src $all_files[$index]
            set dest $target_dir/(basename $src)
            if not test -e $dest
                ln -s $src $dest
                echo "🔗 Linked "(basename $src)" → $dest"
            else
                echo "⚠️ Skipped "(basename $src)" (already exists)"
            end
        else
            echo "⚠️ Invalid index: $index"
        end
    end

    echo
    echo "✅ Done. Selected rules are now linked in $target_dir/"

end

# =============================================================================
# Smart Branch Creation (Optimized for token efficiency)
# =============================================================================
# Deterministic branch creation using gh CLI + git
# No Claude involvement needed - guaranteed consistent results

function smart-branch --description "Create intelligent feature branch with validation"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Not a git repository"
        return 1
    end

    # Ensure on main/master first
    set current_branch (git rev-parse --abbrev-ref HEAD)
    set main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||' || echo "main")

    if test "$current_branch" != "$main_branch"
        echo "⚠️  Currently on '$current_branch', switching to '$main_branch'..."
        git checkout "$main_branch"
        or begin
            echo "❌ Failed to switch to $main_branch"
            return 1
        end
    end

    # Refresh from remote
    git fetch origin >/dev/null 2>&1

    # Check type argument
    set branch_type $argv[1]
    if test -z "$branch_type"
        set branch_type "feat"
    end

    # Validate type
    if not string match -q "feat|fix|refactor|docs|test|chore|perf|style" "$branch_type"
        echo "❌ Invalid type. Use: feat, fix, refactor, docs, test, chore, perf, style"
        return 1
    end

    # Check if there's an issue number in remaining args
    set issue_num $argv[2]
    set branch_name ""

    if test -n "$issue_num"
        # User provided issue number
        if string match -qr '^[0-9]+$' "$issue_num"
            set branch_name "$branch_type/$issue_num"
        else
            echo "❌ Issue number must be numeric"
            return 1
        end
    else
        # Generate deterministic branch name from timestamp
        set timestamp (date '+%s')
        set branch_name "$branch_type/auto-$timestamp"
    end

    # Check if branch already exists
    if git rev-parse --verify "$branch_name" >/dev/null 2>&1
        echo "❌ Branch already exists: $branch_name"
        echo "ℹ️  Use: git checkout $branch_name"
        return 1
    end

    # Create and switch to branch
    git checkout -b "$branch_name"

    if test $status -eq 0
        echo "✅ Branch created: $branch_name"
        echo "📍 Current branch: (git branch --show-current)"
        return 0
    else
        echo "❌ Failed to create branch"
        return 1
    end
end

# Code Quality Check (Run linting, type checking, tests)
# Returns pass/fail status for Claude analysis
function check-quality --description "Run linting, type check, and tests"
    set checks_passed 0
    set checks_failed 0

    echo "🔍 Running code quality checks..."
    echo ""

    # Check if package.json exists
    if not test -f package.json
        echo "⚠️  package.json not found. Skipping quality checks."
        return 1
    end

    # ESLint check
    if grep -q '"eslint"' package.json || grep -q '"@typescript-eslint"' package.json
        echo "📋 Running ESLint..."
        pnpm exec eslint src/ 2>&1 | head -20
        if test $status -eq 0
            echo "✅ ESLint: PASS"
            set checks_passed (math $checks_passed + 1)
        else
            echo "❌ ESLint: FAIL"
            set checks_failed (math $checks_failed + 1)
        end
        echo ""
    end

    # TypeScript check
    if test -f tsconfig.json
        echo "📘 Running TypeScript check..."
        pnpm check 2>&1 | tail -5
        if test $status -eq 0
            echo "✅ TypeScript: PASS"
            set checks_passed (math $checks_passed + 1)
        else
            echo "❌ TypeScript: FAIL"
            set checks_failed (math $checks_failed + 1)
        end
        echo ""
    end

    # Tests
    if grep -q '"test"' package.json
        echo "🧪 Running tests..."
        pnpm test 2>&1 | tail -10
        if test $status -eq 0
            echo "✅ Tests: PASS"
            set checks_passed (math $checks_passed + 1)
        else
            echo "❌ Tests: FAIL"
            set checks_failed (math $checks_failed + 1)
        end
        echo ""
    end

    # Summary
    echo "════════════════════════════════════════════════════════"
    echo "📊 Quality Check Summary:"
    echo "   Passed: $checks_passed"
    echo "   Failed: $checks_failed"
    echo "════════════════════════════════════════════════════════"

    if test $checks_failed -eq 0
        echo "✅ All checks passed!"
        return 0
    else
        echo "❌ Some checks failed. Fix before committing."
        return 1
    end
end

# =============================================================================
# Unified Deployment Pipeline (Beta & Prod)
# =============================================================================
# Automated deployment to beta or prod with version bumping and auto-deploy
# Reduces token usage by eliminating Claude involvement in deployment

function ship --description "Deploy to beta or prod: ship [beta|prod]"
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

    # Smart branch detection: if on beta without explicit target, assume prod
    if test -z "$target" -a "$current_branch" = "beta"
        set target "prod"
        echo "📍 Currently on beta branch, deploying to prod..."
        echo ""
    end

    # Smart deployment: if on main without explicit target, assume beta
    if test -z "$target" -a "$current_branch" = "$main_branch"
        set target "beta"
        echo "📍 Currently on main branch, deploying to beta..."
        echo ""
    end

    # Full deployment: if on main and explicitly requesting prod, do beta then prod
    if test "$target" = "prod" -a "$current_branch" = "$main_branch"
        echo "📍 Full deployment: main → beta → prod"
        echo ""
        set target "beta-and-prod"
    end

    # Validate target argument
    if test -z "$target"
        echo "❌ Usage: ship [beta|prod]"
        echo ""
        echo "Examples:"
        echo "  ship beta    # Deploy to staging (creates release branch, bumps version, asks Claude for CHANGELOG)"
        echo "  ship prod    # Deploy full pipeline: main → beta → prod"
        echo ""
        echo "💡 Smart shortcuts:"
        echo "   From main: 'ship' → deploys to beta only"
        echo "   From main: 'ship prod' → deploys to beta AND prod (full pipeline)"
        echo "   From beta: 'ship' → deploys to prod only"
        return 1
    end

    if not test "$target" = "beta" -o "$target" = "prod" -o "$target" = "beta-and-prod"
        echo "❌ Invalid target: $target"
        echo "ℹ️  Use: ship beta  or  ship prod"
        return 1
    end

    # Block shipping from other protected branches
    if string match -q "beta|prod" "$current_branch" -a "$current_branch" != "$target" -a "$target" != "beta-and-prod"
        echo "❌ Cannot ship from protected branch: $current_branch"
        echo "ℹ️  Switch to $main_branch first: git checkout $main_branch"
        return 1
    end

    # For full deployment, show confirmation
    if test "$target" = "beta-and-prod"
        echo "⚠️  Full deployment to PRODUCTION"
        echo "ℹ️  Will deploy to both beta and prod"
        echo ""
    else if test "$target" = "prod"
        echo "⚠️  Deploying to PRODUCTION"
        echo "ℹ️  Make sure you've tested changes in beta environment first"
        echo ""
    end

    echo "🚀 Starting deployment to $target..."
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

    # Step 3: Ensure we're on main
    if test "$current_branch" != "$main_branch"
        echo "✓ Switching to $main_branch..."
        git checkout "$main_branch" >/dev/null 2>&1
        or begin
            echo "❌ Failed to switch to $main_branch"
            return 1
        end
    end

    # Step 4: Pull latest changes from main
    echo "✓ Pulling latest changes from $main_branch..."
    git pull origin "$main_branch" >/dev/null 2>&1
    or begin
        echo "❌ Failed to pull from $main_branch"
        return 1
    end

    # Step 5: Create release branch (for beta or beta-and-prod)
    if test "$target" = "beta" -o "$target" = "beta-and-prod"
        # Get current version
        set current_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')

        echo "✓ Creating release branch..."
        set release_branch "chore/release-v$current_version"

        # Check if branch already exists locally, if so delete it
        if git rev-parse --verify "$release_branch" >/dev/null 2>&1
            git branch -D "$release_branch" >/dev/null 2>&1
        end

        git checkout -b "$release_branch" >/dev/null 2>&1
        or begin
            echo "❌ Failed to create release branch"
            return 1
        end

        # Step 6: Bump version
        echo "✓ Bumping version (patch)..."
        pnpm version patch --no-git-tag-version >/dev/null 2>&1
        or begin
            echo "❌ Failed to bump version"
            git checkout "$main_branch" >/dev/null 2>&1
            git branch -D "$release_branch" >/dev/null 2>&1
            return 1
        end

        set new_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')
        echo "   Version bumped to: $new_version"

        # Step 7: Create placeholder CHANGELOG entry for Claude to fill in
        if test -f CHANGELOG.md
            echo ""
            echo "📝 CHANGELOG needs to be updated for version $new_version"

            # Create temp file with new changelog entry
            set temp_changelog (mktemp)
            set date (date '+%Y-%m-%d')

            echo "## [$new_version] - $date" > "$temp_changelog"
            echo "" >> "$temp_changelog"
            echo "### Added" >> "$temp_changelog"
            echo "- " >> "$temp_changelog"
            echo "" >> "$temp_changelog"
            echo "### Changed" >> "$temp_changelog"
            echo "- " >> "$temp_changelog"
            echo "" >> "$temp_changelog"
            echo "### Fixed" >> "$temp_changelog"
            echo "- " >> "$temp_changelog"
            echo "" >> "$temp_changelog"

            # Append existing CHANGELOG
            tail -n +1 CHANGELOG.md >> "$temp_changelog"
            mv "$temp_changelog" CHANGELOG.md
            echo "   ✓ Placeholder added to CHANGELOG.md"
            echo ""
            echo "⚠️  PAUSE: Please edit CHANGELOG.md with the actual release notes"
            echo ""
            echo "When ready, press Enter to continue with the deployment..."
            read -p ""

            # Check if CHANGELOG was edited
            if not git diff CHANGELOG.md | grep -q "^[+-]"
                echo "⚠️  CHANGELOG.md was not modified. Using placeholder entries."
            end
        end

        # Step 8: Commit version bump and CHANGELOG
        echo ""
        echo "✓ Committing version bump and CHANGELOG..."
        git add -A
        git commit -m "chore: bump version to $new_version" >/dev/null 2>&1
        or begin
            echo "❌ Failed to commit changes"
            git checkout "$main_branch" >/dev/null 2>&1
            git branch -D "$release_branch" >/dev/null 2>&1
            return 1
        end

        # Step 9: Push release branch
        echo "✓ Pushing release branch..."
        git push -u origin "$release_branch" >/dev/null 2>&1
        or begin
            echo "❌ Failed to push release branch"
            git checkout "$main_branch" >/dev/null 2>&1
            return 1
        end

        # Step 10: Create PR
        echo "✓ Creating PR to merge into $main_branch..."
        set pr_num (gh pr create --base "$main_branch" --head "$release_branch" --title "chore: bump version to $new_version" --body "Release version $new_version

- Version bumped: $new_version
- CHANGELOG updated
- Ready to merge and deploy" 2>&1 | grep -oP 'pull/\K[0-9]+' | head -1)

        if test -z "$pr_num"
            echo "⚠️  Could not create PR automatically"
            echo "   Please create manually: https://github.com/ProNeXus-AI/Xtimator/compare/$main_branch...$release_branch"
            return 1
        end

        echo "   PR #$pr_num created"

        # Step 11: Merge PR
        echo "✓ Merging PR #$pr_num..."
        gh pr merge "$pr_num" --squash --delete-branch >/dev/null 2>&1
        or begin
            echo "❌ Failed to merge PR"
            echo "ℹ️  Merge manually or fix issues and retry"
            return 1
        end

        # Step 12: Return to main and pull latest
        echo "✓ Pulling latest from $main_branch..."
        git checkout "$main_branch" >/dev/null 2>&1
        git pull origin "$main_branch" >/dev/null 2>&1
    else
        # For prod, get current version
        set new_version (grep '"version"' package.json | head -1 | sed 's/.*"version": "\([^"]*\).*/\1/')
    end

    # Handle beta-and-prod: deploy to beta first, then prod
    if test "$target" = "beta-and-prod"
        # Deploy to beta
        echo "✓ Switching to beta branch..."
        git checkout beta >/dev/null 2>&1
        or begin
            echo "❌ Failed to checkout beta branch"
            return 1
        end

        echo "✓ Pulling latest beta..."
        git pull origin beta >/dev/null 2>&1
        or begin
            echo "❌ Failed to pull beta"
            return 1
        end

        echo "✓ Merging $main_branch into beta..."
        git merge "$main_branch" --no-edit >/dev/null 2>&1
        or begin
            echo "❌ Merge conflict detected. Please resolve manually."
            echo "ℹ️  Run: git merge --abort  and try again"
            return 1
        end

        echo "✓ Pushing to beta (auto-deploy triggered)..."
        git push origin beta >/dev/null 2>&1
        or begin
            echo "❌ Failed to push to beta"
            return 1
        end

        echo ""
        echo "✓ Beta deployment complete!"
        echo ""

        # Now deploy to prod
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

        echo "✓ Merging beta into prod..."
        git merge beta --no-edit >/dev/null 2>&1
        or begin
            echo "❌ Merge conflict detected. Please resolve manually."
            echo "ℹ️  Run: git merge --abort  and try again"
            return 1
        end

        echo "✓ Pushing to prod (auto-deploy triggered)..."
        git push origin prod >/dev/null 2>&1
        or begin
            echo "❌ Failed to push to prod"
            return 1
        end

        # Return to main
        echo "✓ Returning to $main_branch..."
        git checkout "$main_branch" >/dev/null 2>&1

        # Success!
        echo ""
        echo "════════════════════════════════════════════════════════"
        echo "✅ Full Deployment Successful!"
        echo "════════════════════════════════════════════════════════"
        echo "🎯 Version: $new_version"
        echo "📍 Branches: beta → prod"
        echo "⏳ Auto-deploy in progress on both environments..."
        echo ""
        echo "ℹ️  Changes are now live in production!"
        echo "════════════════════════════════════════════════════════"

        return 0
    end

    # Regular single-target deployment
    echo "✓ Switching to $target branch..."
    git checkout "$target" >/dev/null 2>&1
    or begin
        echo "❌ Failed to checkout $target branch"
        return 1
    end

    echo "✓ Pulling latest $target..."
    git pull origin "$target" >/dev/null 2>&1
    or begin
        echo "❌ Failed to pull $target"
        return 1
    end

    # For prod, merge beta. For beta, merge main
    set source_branch (test "$target" = "prod" && echo "beta" || echo "$main_branch")

    echo "✓ Merging $source_branch into $target..."
    git merge "$source_branch" --no-edit >/dev/null 2>&1
    or begin
        echo "❌ Merge conflict detected. Please resolve manually."
        echo "ℹ️  Run: git merge --abort  and try again"
        return 1
    end

    # Step 8: Push to target (triggers auto-deploy)
    echo "✓ Pushing to $target (auto-deploy triggered)..."
    git push origin "$target" >/dev/null 2>&1
    or begin
        echo "❌ Failed to push to $target"
        return 1
    end

    # Step 9: Return to main
    echo "✓ Returning to $main_branch..."
    git checkout "$main_branch" >/dev/null 2>&1

    # Success!
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "✅ Deployment to $target Successful!"
    echo "════════════════════════════════════════════════════════"
    echo "🎯 Version: $new_version"
    echo "📍 Branch: $target"
    echo "⏳ Auto-deploy in progress..."
    echo ""

    if test "$target" = "beta"
        echo "ℹ️  Next steps:"
        echo "   1. Test changes in beta environment"
        echo "   2. When ready: ship prod"
    else
        echo "ℹ️  Changes are now live in production!"
    end

    echo "════════════════════════════════════════════════════════"

    return 0
end

# Convenience aliases for quick deployment
function ship-beta --description "Deploy to beta: ship beta"
    ship beta $argv
end

function ship-prod --description "Deploy to prod: ship prod"
    ship prod $argv
end
