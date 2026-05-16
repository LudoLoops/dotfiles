# SSH into aether with Zellij — no nesting
# Detaches local zellij, SSH + attach remote zellij, re-attaches local on exit
function aether
    if set -q ZELLIJ
        zellij detach
        ssh aether -t "zellij attach -c default"
        zellij attach default
    else
        ssh aether -t "zellij attach -c default"
    end
end
