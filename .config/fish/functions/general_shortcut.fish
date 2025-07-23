function cursor
    command cursor $argv >/dev/null 2>&1 &
    disown
end

function zc
    z $argv && cursor . >/dev/null 2>&1 &
    disown
end
