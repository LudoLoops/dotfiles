function rename_md_to_svx
    for file in *.md *.MD
        if test -f $file
            set newname (string replace -r '\.md$|\.MD$' '.svx' $file)
            mv "$file" "$newname"
        end
    end
end
