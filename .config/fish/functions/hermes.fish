# SSH into aether and attach zellij hermes session
# Usage: hermes
function hermes
    ssh aether -t "zellij attach -c hermes"
end
