alias p='pnpm'
alias pex='pnpm exec'
alias pdx="pnpm dlx"

set -gx PNPM_HOME "/home/loops/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
