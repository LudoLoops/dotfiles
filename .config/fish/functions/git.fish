# git
alias g git
alias addup='git add -u'
alias addall='git add -A'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git add -A && git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
# alias stat='git status' # 'status' is protected name so using 'stat' instead
alias merge-main="checkout main && git merge dev && git push && git checkout dev"
# github

alias release="checkout main && git merge dev && git push && git checkout dev"

alias ghstart="gh issue develop $argv --checkout"
# alias ghfinish='gh pr create --fill --body "Closes #issue_number" --base dev && gh pr merge -d -s'

function compush --description 'git add, commit and push'
    git add -A && git commit -m "$argv" && git push
end

function ghfinish --description 'Finish on the issue number found in the current branch name and merge that pull request.'
    set current_dir (pwd)
    if test -d "$current_dir/.git"
        set branch_name (git rev-parse --abbrev-ref HEAD)
        # set issue_number (string match -a '^[0-9]+' $branch_name)
        set issue_number (string match -r '^[0-9]+' $branch_name)

        # Check if an issue number was found
        if [ -n "$issue_number" ]
            gh pr create --fill \
                --body "Closes #$issue_number" \
                && gh pr merge -d -s
        else
            echo "No issue number was found in the branch name."
            echo $branch_name
            echo $issue_number
        end
    else
        echo "This directory is not a Git repository. Please navigate to a Git repository to use this command."
    end
end

function git-echo-diff
    set first_commit (git rev-list --max-parents=0 HEAD)
    git log $first_commit..HEAD --pretty=tformat: --numstat | awk '{ added += $1; removed += $2 } END {
        printf "Insertions: %'\''d\nDeletions: %'\''d\nTotal changes: %'\''d\n", added, removed, added + removed
    }'
end
