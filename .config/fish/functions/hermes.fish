# SSH into aether and attach zellij hermes session
# Usage: hermes (TufTux only)
function hermes
    if test "$hostname" = "aether" || test "$HOSTNAME" = "aether"
        zellij attach -c hermes
    else
        ssh aether -t "zellij attach -c hermes"
    end
end
