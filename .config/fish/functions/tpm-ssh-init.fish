function tpm-ssh-init
    # Set SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

    # Load keys if agent is running
    if test -S "$SSH_AUTH_SOCK"
        ~/.local/bin/tpm-ssh-agent-helper.sh
    end
end
