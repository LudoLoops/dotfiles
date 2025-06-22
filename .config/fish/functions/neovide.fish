function __launch_detached
    nohup $argv >/dev/null 2>&1 &
    set pid $last_pid
    disown $pid
end

function v
    if count $argv >/dev/null
        __launch_detached neovide $argv
    else
        __launch_detached neovide .
    end
end

alias neovide='v'
