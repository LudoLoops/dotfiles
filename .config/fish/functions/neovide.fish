function neovide
    command neovide $argv & disown
end

function v
    if count $argv >/dev/null
        neovide $argv & disown
    else
        neovide . & disown
    end

end
