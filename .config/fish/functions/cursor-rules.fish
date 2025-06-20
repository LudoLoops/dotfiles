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
