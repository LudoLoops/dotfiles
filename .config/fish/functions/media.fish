# =============================================================================
# Media Processing & Conversion
# =============================================================================
# Image resizing, WebP conversion, video encoding, file format conversion

# Image Resizing with ImageMagick
# Resizes images to specified width (default 1280px)
# Usage: imgResize [width]
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

# Image Reduction & WebP Conversion (Batch)
# Converts JPG/JPEG images to WebP, backs up originals, generates report
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

# Individual File WebP Conversion
# Converts JPG/PNG files in current directory to WebP format (quality 85)
# Usage: toWebp
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

# Video Conversion to DaVinci Resolve Format
# Converts video to ProRes 422 HQ format for DaVinci Resolve
# Usage: convert_to_Davinci input_file
function convert_to_Davinci
    # Check for input argument
    if test (count $argv) -lt 1
        echo "Usage: convert_to_Davinci <input_file>"
        echo "Example: convert_to_Davinci input.mov"
        return 1
    end

    # Input file name
    set input_file $argv[1]

    # Output file name (default: output.mov)
    set output_file "output.mov"

    # Check if input file exists
    if not test -e $input_file
        echo "Erreur : Le fichier '$input_file' n'existe pas."
        return 1
    end

    # Display conversion message
    echo "Conversion de '$input_file' en ProRes 422 HQ..."

    # Execute FFmpeg conversion
    ffmpeg -i $input_file -c:v dnxhd -profile:v dnxhr_lb -pix_fmt yuv422p -c:a pcm_s16le -f mov output.mov

    # Check if conversion succeeded
    if test $status -eq 0
        echo "Conversion terminée : '$output_file' a été créé."
    else
        echo "Erreur lors de la conversion."
    end
end

# Markdown to SvelteKit Format Conversion
# Renames .md and .MD files to .svx format
# Usage: rename_md_to_svx
function rename_md_to_svx
    for file in *.md *.MD
        if test -f $file
            set newname (string replace -r '\.md$|\.MD$' '.svx' $file)
            mv "$file" "$newname"
        end
    end
end
