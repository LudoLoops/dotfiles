# Directory Structure Explained

Complete explanation of `~/.claude/` organization.

## Top-Level Files

### `README.md`
- **Audience:** You (human)
- **Purpose:** Quick overview and navigation
- **Update when:** Structure changes or new sections added

### `CLAUDE.md`
- **Audience:** Claude Code
- **Purpose:** Global instructions that Claude reads
- **Contains:**
  - Development principles (pnpm, TypeScript, etc.)
  - Git workflow and conventions
  - Commit message format
  - Documentation structure guidelines
  - Links to detailed context

### `settings.json`
- Claude Code settings (auto-managed)

## Folders

### `claude/` - Context for Claude

**Purpose:** Reference documents that Claude reads during code analysis.

**Contents:**
```
claude/
├── fish-dev-functions.md          # All available Fish functions
│                                  # (git, svelte, editors, utils, etc.)
├── commands-optimization.md       # Optimization strategy
│                                  # (how slash commands work)
└── [future context docs here]
```

**When Claude analyzes your code:**
1. Reads `CLAUDE.md` (instructions)
2. Reads files in `claude/` (context)
3. Uses this knowledge to help you better

**Add new context docs here** for things like:
- Architecture patterns
- Database schema
- API specifications
- Security guidelines
- Testing strategies

### `commands/` - Slash Commands

**Purpose:** Definitions of slash commands available in Claude Code.

**Current commands:**
```
commands/
├── branch.md                      # /branch - Smart branch creation
├── optimize.md                    # /optimize - Code optimization
└── review.md                      # /review - Code review
```

**When you type `/branch`:**
1. Claude reads `commands/branch.md`
2. Executes the command logic
3. Uses the defined workflow

**Add new slash commands** by creating new `.md` files here.

### `docs/` - Human Documentation

**Purpose:** Detailed guides for you (not for Claude).

**Current files:**
```
docs/
├── STRUCTURE.md                   # This file - explains the structure
├── CLAUDE-CONTEXT.md              # What's in the claude/ folder
└── [future guides here]
```

**Add guides for:**
- How to use specific functions
- Workflow explanations
- Setup instructions
- Troubleshooting
- FAQ

## Directory Tree

```
~/.claude/
│
├── README.md                      ← START HERE (quick overview)
├── CLAUDE.md                      ← For Claude (instructions)
├── settings.json                  ← Auto-managed
│
├── claude/                        ← Context for Claude
│   ├── fish-dev-functions.md      (13 KB) Fish shell reference
│   └── commands-optimization.md   (6 KB) Optimization strategy
│
├── commands/                      ← Slash commands
│   ├── branch.md                  Smart branch creation
│   ├── optimize.md                Code optimization
│   └── review.md                  Code review
│
├── docs/                          ← Human guides (you are here)
│   ├── STRUCTURE.md               This file
│   ├── CLAUDE-CONTEXT.md          Explanation of claude/ folder
│   └── [future guides]
│
└── [system folders]               ← Auto-managed by Claude Code
    ├── projects/
    ├── session-env/
    ├── todos/
    ├── file-history/
    └── ... (other internal data)
```

## Naming Conventions

### File Organization

- **Top-level** = Critical files (README, CLAUDE.md)
- **Folders** = Logical grouping by purpose
- **Files within folders** = Specific topics

### File Names

- **Uppercase** (README.md, STRUCTURE.md) = Important docs
- **Lowercase** (branch.md) = Specific content

### For Slash Commands

- File name = command name (without `/`)
- Example: `branch.md` → `/branch` command

## How Claude Uses This

```
When Claude Code starts:
  ↓
Reads ~/.claude/CLAUDE.md
  ↓
Reads ~/.claude/claude/* (context docs)
  ↓
When you type a command:
  ↓
Reads ~/.claude/commands/<command>.md
  ↓
Executes command with full context
```

## How You Use This

```
When you want to understand something:
  ↓
Check README.md (quick overview)
  ↓
If you need details, check docs/
  ↓
If you need context, check claude/
```

## Adding New Content

### Add a new slash command:
1. Create `commands/my-command.md`
2. Document the workflow
3. Reference relevant `claude/` docs
4. Update `README.md` if needed

### Add a new context doc:
1. Create `claude/my-topic.md`
2. Document in detail
3. Reference from `CLAUDE.md`
4. Update `docs/CLAUDE-CONTEXT.md`

### Add a new user guide:
1. Create `docs/my-guide.md`
2. Explain for humans
3. Link from `README.md` or other guides
4. Keep it focused on one topic

## Maintenance

### Before pushing changes:

1. **Update relevant docs**
   - If changing behavior → update `CLAUDE.md`
   - If adding file → update `docs/STRUCTURE.md`
   - If adding command → update `commands/` folder

2. **Keep README.md updated**
   - Changes to overview
   - New important files

3. **Document in claude/`**
   - Complex behaviors
   - Reference materials
   - Context Claude should know

## Summary

| Need | Look at |
|------|---------|
| Quick overview | `README.md` |
| Instructions | `CLAUDE.md` |
| Structure explanation | `docs/STRUCTURE.md` |
| Context for Claude | `claude/` |
| Slash commands | `commands/` |
| User guides | `docs/` |

---

**Remember:**
- Files in `claude/` are for Claude to read
- Files in `docs/` are for you to read
- `CLAUDE.md` is read by both (instructions for Claude, reference for you)

**Last updated:** December 2024
