### "bat" as manpager
set -x MANROFFOPT -c
if type -q bat
    set -x MANPAGER "sh -c 'col -bx | bat -plman'"
else if type -q batcat
    set -x MANPAGER "sh -c 'col -bx | batcat -plman'"
end

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

# bat — Debian uses batcat, Arch uses bat
if type -q bat
    alias cat='bat --style=plain'
else if type -q batcat
    alias cat='batcat --style=plain'
end
# Kitty icat — only if kitten is available
if type -q kitten
    alias icat='kitten icat'
end
