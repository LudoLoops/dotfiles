# SSH into aether with Zellij — no nesting
function aether
    if set -q ZELLIJ
        zellij action detach
    end
    ssh aether -t "zellij attach -c default"
end
