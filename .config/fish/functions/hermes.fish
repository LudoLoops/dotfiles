# SSH into aether and attach zellij hermes session
# Usage: hermes
function hermes
    if test "$hostname" = aether
        zellij attach -c hermes
    else
        ssh aether -t "zellij attach -c hermes"
    end
end
