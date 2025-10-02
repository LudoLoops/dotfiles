function imgResize
    # Default width: 1280 if no argument is provided
    set width (if test (count $argv) -ge 1; echo $argv[1]; else; echo 1280; end)

    # Current working directory
    set dir (pwd)
    set outdir "$dir/resized"

    # Check if ImageMagick is installed
    if not type -q magick
        echo "Error: ImageMagick (magick) is not installed."
        return 1
    end

    # Create output directory
    mkdir -p $outdir

    # Loop over image files
    for img in $dir/*.{jpg,jpeg,png,JPG,JPEG,PNG,webp}
        if test -f $img
            set filename (basename $img)
            set newpath "$outdir/$filename"
            echo "🔧 Resizing $filename → width $width px → $filename"
            magick "$img" -resize "$width"x "$newpath"
        end
    end

    echo "✅ Done. Images saved in: $outdir"
end

function image-reduce
    # Current directory (e.g. your project subfolder)
    set root $PWD

    # Backup root: save originals to ../original/ (flat structure)
    set backup_root (realpath "$root/..")/original

    # Report file: append only, lists converted .webp files
    set report_file "$root/image-report.txt"

    # Check if cwebp is available
    if not command -v cwebp > /dev/null
        echo "❌ Error: cwebp not found. Install with: sudo pacman -S webp"
        return 1
    end

    # Directories to scan
    set dirs src/assets static

    set total 0
    set converted 0

    # Process each directory
    for dir in $dirs
        set full_dir "$root/$dir"

        if not test -d "$full_dir"
            echo "📁 Skipping: $full_dir (not found)"
            continue
        end

        # Find all .jpg, .jpeg files
        for img in (find "$full_dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \))
            set total (math $total + 1)

            set abs_path (realpath "$img")

            # Relative path from root (e.g. static/img/photo.jpg)
            set rel_path (string replace -r "^$root/" "" "$abs_path")

            # WebP output path
            set webp_path (string replace -r '\.(jpe?g)$' '.webp' -- "$abs_path")

            # Relative WebP path for reporting (e.g. static/img/photo.webp)
            set rel_webp_path (string replace -r '\.(jpe?g)$' '.webp' -- "$rel_path")

            # Skip if .webp already exists
            if test -e "$webp_path"
                echo "⏩ Exists: $rel_webp_path"
                continue
            end

            # Backup path: ../original/static/img/photo.jpg (flat)
            set backup_path "$backup_root/$rel_path"

            # Ensure backup directory exists
            mkdir -p (dirname "$backup_path")

            # Copy original
            cp "$abs_path" "$backup_path"

            # Convert to WebP (quality 85)
            cwebp -q 85 "$abs_path" -o "$webp_path"

            if test $status -eq 0
                echo "✅ Converted: $rel_webp_path"
                echo "$rel_webp_path" >> "$report_file"
                set converted (math $converted + 1)
            else
                echo "❌ Failed: $rel_path"
            end
        end
    end

    # Final summary
    echo ""
    echo "🎉 Compression complete: $converted/$total images converted"
    echo "   WebP files saved in original locations"
    echo "   Originals backed up in: $backup_root"
    echo "   List of converted files: $report_file"
end
