# SSH into aether and attach zellij session
# Usage: aether [session_name]
# Default session: hermes
function aether
    set -l session Aether
    if test (count \$argv) -gt 0
        set session \$argv[1]
    end
    ssh aether -t "zellij -l aether attach -c \$session"
end

# ssh aether -t "zellij -l aether attach -c Aether"
