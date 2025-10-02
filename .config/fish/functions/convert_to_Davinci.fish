function convert_to_Davinci
    # Vérifie qu'un argument est fourni
    if test (count $argv) -lt 1
        echo "Usage: convert_to_prores <input_file>"
        echo "Example: convert_to_prores input.mov"
        return 1
    end

    # Nom du fichier d'entrée
    set input_file $argv[1]

    # Nom du fichier de sortie (par défaut : output.mov)
    set output_file "output.mov"

    # Vérifie si le fichier d'entrée existe
    if not test -e $input_file
        echo "Erreur : Le fichier '$input_file' n'existe pas."
        return 1
    end

    # Affiche la commande FFmpeg exécutée
    echo "Conversion de '$input_file' en ProRes 422 HQ..."

    # Exécute FFmpeg
    ffmpeg -i $input_file -c:v prores_ks -profile:v 3 -pix_fmt yuv422p10le -c:a pcm_s16le -f mov $output_file

    # Vérifie si la conversion a réussi
    if test $status -eq 0
        echo "Conversion terminée : '$output_file' a été créé."
    else
        echo "Erreur lors de la conversion."
    end
end
