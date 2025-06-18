function towebp
    set quality 85
    for f in *.jpg *.jpeg *.png *.JPG *.JPEG *.PNG
        if test -f "$f"
            set out (string replace -r '\.(jpg|jpeg|png|JPG|JPEG|PNG)$' '' $f).webp

            # Ne pas convertir si le fichier .webp existe déjà
            if test -e "$out"
                echo "⏩ Skipping $f (already exists)"
                continue
            end

            cwebp -q $quality "$f" -o "$out"
            echo "✅ $f → $out"
        end
    end
end
