function commit --description 'git add and commit with descriptive message or auto-commit with timestamp'
    set message "$argv"

    # If no arguments, use auto-commit with timestamp
    if test (count $argv) -eq 0
        set timestamp (date '+%d-%b-%Y %H:%M')
        set message "auto-commit: $timestamp"
    end

    git add -A && git commit -m "$message"
end
