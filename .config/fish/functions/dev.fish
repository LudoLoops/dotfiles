# =============================================================================
# Web Development Tools
# =============================================================================
# SvelteKit projects, Svelte routes, Go builds, Cursor IDE configuration

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
