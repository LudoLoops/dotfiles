# Git aliases
alias g git
alias addup='git add -u'
alias addall='git add -A'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'

alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
# alias stat='git status' # 'status' is protected name so using 'stat' instead
alias git-deploy="git switch prod && git merge main && git push && git checkout main"
