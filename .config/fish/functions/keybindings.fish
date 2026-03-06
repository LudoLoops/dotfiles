# =============================================================================
# Keybindings & History Utilities
# =============================================================================
# History navigation, sudo support (!! / !$), M+N history bindings

# History Support for Sudo (!! and !$)
# Functions needed for !! and !$ features
# Reference: https://github.com/oh-my-fish/plugin-bang-bang

function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# The bindings for !! and !$
if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Alt + Number (M+1 to M+9) History Navigation
# Binds Alt+1 through Alt+9 to recall commands from history
function bind_M_n_history
    for i in (seq 9)
        set -l command
        if test (count $history) -ge $i
            set command "commandline -r \$history[$i]"
        else
            set command "echo \"No history found for number $i\""
        end

        if contains fish_vi_key_bindings $fish_key_bindings
            bind -M default \e$i "$command"
            bind -M insert \e$i "$command"
        else
            bind \e$i "$command"
        end
    end
end

# Initialize M+N bindings
bind_M_n_history
