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

function svelteForge
    p dlx tsx ~/1Dev/Projects/Lelab/SvelteForge/svelteForge/index.ts
end



function sv-create --argument path
    # Vérifier si l'argument path est fourni
    if test -z "$path"
        echo "Error: Please specify a path for the project." >&2
        return 1
    end

    # Vérifier si le répertoire existe déjà
    if test -d "$path"
        echo "Error: Directory '$path' already exists." >&2
        return 1
    end

    # Création du projet SvelteKit avec les options
    command pnpx sv create --types ts --install pnpm --template minimal --no-add-ons "$path"
    or begin
        echo "Error: Failed to create SvelteKit project." >&2
        return 1
    end

    # Aller dans le répertoire du projet
    cd "$path"
    or begin
        echo "Error: Could not enter directory '$path'." >&2
        return 1
    end

    # Ajout des dépendances
    command pnpx sv add vitest tailwindcss sveltekit-adapter mcp eslint prettier playwright devtools-json --install pnpm
    or begin
        echo "Error: Failed to add dependencies." >&2
        return 1
    end

    echo "✅ Project '$path' created and configured successfully."
end
