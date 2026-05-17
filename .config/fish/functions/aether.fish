# SSH into aether and attach zellij session
# Usage: aether [session_name]
# Default session: hermes
function aether
    set -l session hermes
    if test (count \$argv) -gt 0
        set session \$argv[1]
    end
    ssh aether -t "zellij -l default attach -c \$session"
end
