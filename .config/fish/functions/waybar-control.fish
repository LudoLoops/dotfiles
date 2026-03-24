#!/usr/bin/env fish
# Simple waybar control en fish
# Usage: waybar-control [start|stop|restart|toggle]

function waybar-control
    set WAYBAR_PID (pgrep -x waybar | count)

    function start_waybar
        if test $WAYBAR_PID -eq 0
            hyde-shell waybar &
            echo "Waybar lancé"
        else
            echo "Waybar tourne déjà (PID: $WAYBAR_PID processus)"
        end
    end

    function stop_waybar
        if test $WAYBAR_PID -gt 0
            killall waybar
            echo "Waybar arrêté"
        else
            echo "Waybar ne tourne pas"
        end
    end

    function restart_waybar
        stop_waybar
        sleep 0.1
        start_waybar
    end

    function toggle_waybar
        if test $WAYBAR_PID -gt 0
            stop_waybar
        else
            start_waybar
        end
    end

    switch (string lower $argv[1])
        case start
            start_waybar
        case stop
            stop_waybar
        case restart reload
            restart_waybar
        case toggle
            toggle_waybar
        case '*'
            echo "Usage: waybar-control [start|stop|restart|toggle]"
    end
end
