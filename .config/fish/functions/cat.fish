# Man pages — Bat
set -gx MANROFFOPT -c

if command -sq bat
    set -gx MANPAGER "sh -c 'col -bx | bat -plman'"
else if command -sq batcat
    set -gx MANPAGER "sh -c 'col -bx | batcat -plman'"
end

# Bat — Markdown preview via Glow
if command -sq bat; or command -sq batcat

    function bat --description "Bat with Markdown preview via Glow"
        set -l file

        # Support bat FILE and bat --style=plain FILE
        if test (count $argv) -eq 1
            set file $argv[1]
        else if test (count $argv) -eq 2
            if test "$argv[1]" = "--style=plain"
                set file $argv[2]
            end
        end

        # Markdown preview in interactive terminal
        if test -n "$file"; and test -f "$file"
            if isatty stdout; and command -sq glow
                if string match -qri '\.(md|markdown)$' -- "$file"
                    command glow -p "$file"
                    return $status
                end
            end
        end

        # Native Bat / Debian batcat
        if command -sq bat
            command bat $argv
        else
            command batcat $argv
        end
    end

    # cat — Bat without decorations
    alias cat='bat --style=plain'
end

# Kitty icat
if command -sq kitten
    alias icat='kitten icat'
end
