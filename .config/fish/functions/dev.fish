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
    command bun x sv create --template minimal --types ts --add prettier eslint playwright tailwindcss="plugins:typography,forms" devtools-json mdsvex mcp="ide:opencode+setup:remote" --install bun "$path"
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

    # Install Skeleton UI packages
    command bun i -D @skeletonlabs/skeleton @skeletonlabs/skeleton-svelte
    or begin
        echo "Error: Failed to install Skeleton UI dependencies." >&2
        return 1
    end

    # Create or update layout.css with Tailwind and Skeleton imports
    set css_file src/routes/layout.css
    if test ! -f "$css_file"
        command touch "$css_file"
    end

    command echo -e '@import \'tailwindcss\';\n@import \'@skeletonlabs/skeleton\';\n@import \'@skeletonlabs/svelte\';\n@import \'@skeletonlabs/skeleton/themes/cerberus\';' >>"$css_file"
    or begin
        echo "Error: Could not append to $css_file." >&2
        return 1
    end

    # Update src/app.html to set the theme
    set app_html src/app.html
    if test -f "$app_html"
        # Create a temporary file for cross-platform compatibility
        set temp_file (mktemp)
        command sed 's/<html/<html data-theme="cerberus"/' "$app_html" >"$temp_file"
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
        echo "❌ Error: path(s) required"
        echo "Usage: mkroute path1 [path2 ... pathN]"
        return 1
    end

    for dir in $argv
        set file "$dir/+page.svelte"

        # Create directory
        mkdir -p $dir || begin
            echo "❌ Error: failed to create directory: $dir"
            continue
        end

        # Create +page.svelte if it doesn't exist
        if not test -f $file
            touch $file || begin
                echo "❌ Error: failed to create file: $file"
                continue
            end
            echo "✅ Created: $file"
        else
            echo "⚠️  File already exists: $file"
        end
    end
end

# SvelteForge - Custom build tool for SvelteKit
function svelteForge
    if not test -f ~/1Dev/Projects/Lelab/SvelteForge/svelteForge/index.ts
        echo "❌ Error: SvelteForge index.ts not found"
        return 1
    end

    p dlx tsx ~/1Dev/Projects/Lelab/SvelteForge/svelteForge/index.ts || begin
        echo "❌ Error: Failed to run SvelteForge"
        return 1
    end
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
                    ln -s $src $dest || begin
                        echo "❌ Failed to link: "(basename $src)
                        continue
                    end
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
        set branch_type feat
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
        bun exec eslint src/ 2>&1 | head -20
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
        bun check 2>&1 | tail -5
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
        bun test 2>&1 | tail -10
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
