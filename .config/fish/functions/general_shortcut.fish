
function zc
    z $argv && cursor . >/dev/null 2>&1 &
    disown
end

function update
    paru -Syu --noconfirm
    sudo paccache -r
    if type -q flatpak
        flatpak update -y
    end
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

function zz --argument path
    if test -n "$path"
        z "$path"
    end
    command zeditor .
end
