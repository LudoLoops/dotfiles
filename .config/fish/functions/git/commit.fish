function commit --description 'git add and commit with conventional commit format or auto-commit with timestamp'
    set message "$argv"

    # If no arguments, use auto-commit with timestamp
    if test (count $argv) -eq 0
        set timestamp (date '+%d-%b-%Y %H:%M')
        set message "auto-commit: $timestamp"
    else
        # Validate conventional commit format (type: subject)
        if not string match -q '*:*' "$message"
            echo "❌ Invalid format. Use 'type: subject' (e.g., 'feat: add feature')"
            return 1
        end
    end

    git add -A && git commit -m "$message"
end
