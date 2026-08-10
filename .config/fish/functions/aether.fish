# SSH into aether via herdr — survives WezTerm window close
# nohup blocks SIGHUP from WezTerm, herdr detects PTY EOF and detaches cleanly
function aether
    nohup herdr --remote aether
end
