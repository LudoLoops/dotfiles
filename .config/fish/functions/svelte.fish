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
