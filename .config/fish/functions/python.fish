## python venv

function venv --description "Create and activate a new virtual environment"
    echo "Creating virtual environment in "(pwd)"/.venv"
    python3 -m venv .venv --upgrade-deps
    source .venv/bin/activate.fish

    # Append .venv to the Git exclude file, but only if it's not
    # already there.
    if test -e .git
        set line_to_append ".venv"
        set target_file ".git/info/exclude"

        if not grep --quiet --fixed-strings --line-regexp "$line_to_append" "$target_file" 2>/dev/null
            echo "$line_to_append" >>"$target_file"
        end
    end

    # Tell Time Machine that it doesn't need to both backing up the
    # virtualenv directory. (macOS-only)
    # See https://ss64.com/mac/tmutil.html
end

## auto activate venv
function auto_activate_venv --on-variable PWD --description "Auto activate/deactivate virtualenv when I change directories"

    # Get the top-level directory of the current Git repo (if any)
    set REPO_ROOT (git rev-parse --show-toplevel 2>/dev/null)

    # Case #1: cd'd from a Git repo to a non-Git folder
    #
    # There's no virtualenv to activate, and we want to deactivate any
    # virtualenv which is already active.
    if test -z "$REPO_ROOT"; and test -n "$VIRTUAL_ENV"
        deactivate
    end

    # Case #2: cd'd folders within the same Git repo
    #
    # The virtualenv for this Git repo is already activated, so there's
    # nothing more to do.
    if [ "$VIRTUAL_ENV" = "$REPO_ROOT/.venv" ]
        return
    end

    # Case #3: cd'd from a non-Git folder into a Git repo
    #
    # If there's a virtualenv in the root of this repo, we should
    # activate it now.
    if [ -d "$REPO_ROOT/.venv" ]
        source "$REPO_ROOT/.venv/bin/activate.fish" &>/dev/null
    end
end
