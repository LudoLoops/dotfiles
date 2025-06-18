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

    # Initialize counter for renamed files
    set i 1

    # Loop over image files
    for img in $dir/*.{jpg,jpeg,png,JPG,JPEG,PNG,webp}
        if test -f $img
            set ext (string match -r '\.[^.]+$' -- (basename $img))
            set newname "$outdir/$i$ext"
            echo "🔧 Resizing (basename $img) → width $width px → $i$ext"
            magick "$img" -resize "$width"x "$newname"
            set i (math $i + 1)
        end
    end

    echo "✅ Done. Images saved in: $outdir"
end
