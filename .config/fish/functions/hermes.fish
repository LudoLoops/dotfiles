# SSH into aether and attach zellij hermes session
# Usage: hermes (from TufTux)
function hermes
    ssh aether -t "zellij attach -c hermes"
end
