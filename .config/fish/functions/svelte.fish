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



# function for creating sveltekit project
function sv-create --argument path
  command pnpx sv create --types ts --install pnpm --template minimal --no-add-ons $path
  cd $path

  command pnpx sv add vitest tailwindcss sveltekit-adapter mcp eslint prettier playwright devtools-json --install pnpm
end
