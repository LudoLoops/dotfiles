function bat --description "Bat with Markdown preview via Glow"
    if test (count $argv) -eq 1
        set -l file $argv[1]

        if test -f "$file"; and isatty stdout
            if string match -qri '\.(md|markdown)$' -- "$file"
                command glow -p "$file"
                return $status
            end
        end
    end

    command bat $argv
end
