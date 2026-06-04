# Interactive branch checkout with fzf
# Usage: checkout → fzf picker (local + remote)
# Usage: checkout branch-name → classic git checkout
function checkout --description "git checkout with fzf when no arg given"
    if count $argv >/dev/null
        git checkout $argv
    else
        # Get all branches (local + remote), strip remote prefix for display
        set -l branch (
            git branch -a --format="%(refname:short)" 2>/dev/null | \
            grep -v HEAD | \
            sed "s|origin/||" | \
            sort -u | \
            fzf --preview="git log --oneline --graph {} | head -20" \
                --header="Checkout branch" \
                --height=40%
        )
        if test -n "$branch"
            git checkout "$branch"
        end
    end
end
