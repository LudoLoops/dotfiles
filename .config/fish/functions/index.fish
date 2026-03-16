# script to list alls .fish files in a directory and source them
# Also sources .fish files in subdirectories (modules)

set script_dir (dirname (status current-filename))

# Source all .fish files in current directory
for f in $script_dir/*.fish
    if test (basename $f) != index.fish
        source $f
    end
end

# Source all .fish files in subdirectories (modules)
for dir in $script_dir/*/
    if test -d $dir
        for f in $dir/*.fish
            if test (basename $f) != index.fish
                source $f
            end
        end
    end
end
