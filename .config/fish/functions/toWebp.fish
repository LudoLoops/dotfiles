function toWebp
    # Check if cwebp is installed
    if not command -v cwebp > /dev/null 2>&1
        echo "❌ Error: 'cwebp' is not installed."
        return 1
    end

    set quality 85
    set files *.jpg *.jpeg *.png *.JPG *.JPEG *.PNG
    set valid_files

    # Filter existing files only
    for f in $files
        if test -f "$f"
            set valid_files $valid_files $f
        end
    end

    if test -z "$valid_files"
        echo "🟡 No image files found (.jpg, .jpeg, .png)"
        return 0
    end

    echo "🔧 Converting to WebP (quality $quality)..."

    for f in $valid_files
        # Replace extension with .webp (case-insensitive)
        set out (string replace -r '\.(jpe?g|png|JPE?G|PNG)$' '.webp' -- $f)

        if test -e "$out"
            echo "⏩ Skipped: '$out' already exists"
            continue
        end

        # Perform conversion
        cwebp -q $quality "$f" -o "$out"

        if test $status -eq 0
            set src_size (stat -f%z "$f" | awk '{print int($1/1024)}')k 2>/dev/null || echo "?k"
            set dst_size (stat -f%z "$out" | awk '{print int($1/1024)}')k 2>/dev/null || echo "?k"
            echo "✅ $f ($src_size) → $out ($dst_size)"
        else
            echo "❌ Failed: $f"
        end
    end
end
