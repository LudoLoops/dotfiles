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
    command pnpm i -D @skeletonlabs/skeleton @skeletonlabs/svelte
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
