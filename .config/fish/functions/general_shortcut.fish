# run cursor from the terminal without "bug"
function cursor
    command cursor $argv >/dev/null 2>&1 &
    disown
end

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

function zz
  command zeditor .
end


function svelte-create
  command pnpx sv create --types ts --install pnpm
end
