# Fish Functions Reference

Fish functions are organized in `~/dotfiles/.config/fish/functions/` (symlinked via Stow to `~/.config/fish/functions/`).

⚠️ **IMPORTANT:** When you add, modify, or remove functions, **UPDATE THIS FILE** to keep it in sync with actual functions. See "How to Add/Modify Functions" section below.

## Git Functions (git/)

Located in: `~/dotfiles/.config/fish/functions/git/`

### Aliases (`aliases.fish`)
- `g` - Shortcut for git
- `addup` - `git add -u`
- `addall` - `git add -A`
- `branch` - `git branch`
- `checkout` - `git checkout`
- `clone` - `git clone`
- `fetch` - `git fetch`
- `pull` - `git pull origin`
- `push` - `git push origin`
- `git-deploy` - Deploy to prod: `git switch prod && git merge main && git push`

### Branch Management (`branch.fish`)
- `gh-start <issue-num>` - Create branch from GitHub issue (auto-infers type from title)
- `gh-branch <issue-num> <slug>` - Manual branch creation

### Workflow (`workflow.fish`)
- `commit <type>: <message>` - Conventional commit with validation
- `gh-finish` - Automated PR workflow: push → PR → merge → cleanup

### Deployment (`deploy.fish`)
- `ship` - Deploy from main to production (bumps version)
- `ship-prod` - Explicit prod deployment

### GitHub Labels (`labels.fish`)
- `gh-labels-init` - Initialize standard commit type labels (feat, fix, refactor, docs, test, chore, perf, style)

### Utilities (`utilities.fish`)
- `git-echo-diff` - Show insertions/deletions since first commit
- `gh_create_issues_from_file` - Create GitHub issues from file

## Other Functions

See individual files in `~/dotfiles/.config/fish/functions/`:
- `dev.fish` - Development tools
- `ai.fish` - AI tools
- `editor.fish` - Editor shortcuts
- `general_shortcut.fish` - General shortcuts
- `media.fish` - Media tools
- `pnpm.fish` - pnpm shortcuts
- `python.fish` - Python tools
- `system.fish` - System utilities
- `utils.fish` - General utilities

## How to Add/Modify Functions

### Step 1: Create or Edit Function File

Create file in appropriate subdirectory:
```bash
# Create new git function
touch ~/dotfiles/.config/fish/functions/git/new-function.fish

# Define it
function new-git-function --description 'What it does'
    # implementation
end
```

### Step 2: Update FISH_FUNCTIONS.md (THIS FILE!)

When you add or modify a function:
1. Add/update function in the **Git Functions** section (or appropriate section)
2. Include the function name, description, and location
3. Update the table or list

Example:
```markdown
- `new-git-function` - What it does
```

### Step 3: Available Immediately

Functions are auto-loaded by `index.fish` on next shell session.

## Last Updated
December 14, 2024
