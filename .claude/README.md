# ~/.claude - Claude Code Setup & Context

Personal instructions and context for Claude Code across all projects.

## Quick Overview

```
~/.claude/
├── README.md                  ← You are here
├── CLAUDE.md                  ← Global instructions for Claude
├── claude/                    ← Context & reference docs for Claude
├── commands/                  ← Slash commands (/branch, /optimize, etc.)
├── docs/                      ← Detailed documentation (for you)
└── [other system folders]
```

## What's What

| Folder | For | Purpose |
|--------|-----|---------|
| `CLAUDE.md` | Claude | Global principles, git workflow, conventions |
| `claude/` | Claude | Reference docs (Fish functions, optimization strategy) |
| `commands/` | Claude | Slash command definitions |
| `docs/` | You | Detailed guides explaining the structure |

## For Claude Code

Claude automatically reads `CLAUDE.md` and `claude/` folder contents when analyzing your projects.

## For You

- **Quick questions?** → `README.md` (this file)
- **How is this organized?** → `docs/STRUCTURE.md`
- **What's in claude/ folder?** → `docs/CLAUDE-CONTEXT.md`
- **How do I use Fish functions?** → `claude/fish-dev-functions.md`
- **What about command optimization?** → `claude/commands-optimization.md`

## Key Files

### Instructions
- **`CLAUDE.md`** - Global instructions (pnpm, git workflow, TypeScript rules, etc.)

### Context for Claude
- **`claude/fish-dev-functions.md`** - All available Fish shell functions for development
- **`claude/commands-optimization.md`** - Optimization strategy for slash commands

### Commands
- **`commands/branch.md`** - Smart branch creation
- **`commands/optimize.md`** - Code optimization review
- **`commands/review.md`** - Code quality & bug review

## Quick Start

1. **Read `CLAUDE.md`** - Understand the principles
2. **Read `docs/STRUCTURE.md`** - Understand the organization
3. **Use Fish functions** - `smart-branch feat 42`, `check-quality`
4. **Use slash commands** - `/branch`, `/optimize`, `/review`

## Updates & Maintenance

When updating this structure, document changes in:
- `CLAUDE.md` - If it affects Claude's behavior
- `docs/STRUCTURE.md` - If folder layout changes
- This `README.md` - If overview changes

---

**Last updated:** December 2024
**See also:** `docs/STRUCTURE.md` for detailed explanation
