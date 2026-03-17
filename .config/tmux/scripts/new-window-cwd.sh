#!/usr/bin/env bash
# Get the current working directory of the active pane
# More reliable than #{pane_current_path}

# Get the PID of the foreground process in the active pane
pane_pid=$(tmux display-message -p '#{pane_pid}')

# Try to get the working directory from /proc
if [ -d "/proc/$pane_pid/cwd" ]; then
    cwd=$(readlink "/proc/$pane_pid/cwd")
else
    # Fallback to home
    cwd="$HOME"
fi

# Create new window in that directory
tmux new-window -c "$cwd"
