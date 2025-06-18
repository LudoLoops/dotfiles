# script to list alls .fish files in a directory and source them

set script_dir (dirname (status current-filename))

for f in $script_dir/*.fish
    if test (basename $f) != index.fish
        source $f
    end
end
