function __exegol-vpn_containers
    set -l base "$HOME/1Dev/pentest/vpn"

    for file in $base/*.ovpn
        path basename "$file" | string replace -r '\.ovpn$' ''
    end
end

function __exegol-vpn_profiles
    set -l library "$HOME/1Dev/pentest/vpn/library"

    for file in $library/*.ovpn
        path basename "$file" | string replace -r '\.ovpn$' ''
    end
end

complete -c exegol-vpn -f

# First argument: active VPNs
complete -c exegol-vpn \
    -n 'test (count (commandline -opc)) -eq 1' \
    -a '(__exegol-vpn_containers)'

# Second argument: library profiles
complete -c exegol-vpn \
    -n 'test (count (commandline -opc)) -eq 2' \
    -a '(__exego-vpn_profiles)'
