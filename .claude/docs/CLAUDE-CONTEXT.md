# Claude Context Folder (`~/claude/claude/`)

What's in the `claude/` folder and how Claude uses it.

## Overview

The `claude/` folder contains reference documentation that Claude Code reads to understand your development setup and optimization strategies.

## Current Files

### `fish-dev-functions.md` (13 KB)

**What it is:**
Complete reference guide for all available Fish shell functions in your development environment.

**Who should read it:**
- Claude Code (automatically, when analyzing code)
- You (when you want to know what functions are available)

**Main sections:**
- Quick reference (cheat sheet)
- Git & GitHub workflows (8 functions)
- Package management (pnpm with aliases)
- Development tools (SvelteKit, editors)
- Utilities & pro tips
- Environment setup

**Key functions documented:**
- `gh-start`, `gh-branch`, `gh-pr`, `gh-finish` - Git workflows
- `commit`, `compush` - Conventional commits
- `sv-create`, `mkroute` - SvelteKit tools
- `p`, `pdx`, `pex` - pnpm shortcuts
- `smart-branch`, `check-quality` - Optimized functions

**When Claude uses this:**
- You ask about Fish functions
- You mention "run the Fish command"
- Claude suggests workflows using Fish

---

### `commands-optimization.md` (6 KB)

**What it is:**
Strategic explanation of how slash commands are optimized using Fish shell functions to reduce token usage while maintaining consistency.

**Who should read it:**
- Claude Code (to understand command workflows)
- You (to understand the optimization strategy)

**Main sections:**
- Overview of optimization strategy
- Before/after comparison for each command
- Token savings calculations
- Implementation details
- Hybrid architecture explanation
- Usage guidelines

**Key concepts:**
- `/branch` → uses `smart-branch` function
- `/optimize` → uses `check-quality` for real metrics
- `/review` → uses `check-quality` for validation
- Philosophy: "Machines do validation, Claude does analysis"

**When Claude uses this:**
- You use `/branch`, `/optimize`, or `/review` commands
- Claude needs to understand the workflow
- Claude suggests optimizations

---

## How Claude Reads These Files

When Claude Code starts analysis:

```
1. Reads ~/.claude/CLAUDE.md (instructions)
   ↓
2. Reads ~/.claude/claude/* (context)
   ├─ fish-dev-functions.md
   └─ commands-optimization.md
   ↓
3. Applies this knowledge to your code analysis
```

This means Claude automatically knows:
- ✅ What Fish functions are available
- ✅ How to recommend them appropriately
- ✅ What the optimization strategy is
- ✅ When to use `smart-branch` vs manual git commands
- ✅ When to suggest `check-quality` before analysis

---

## Adding New Context Docs

When you want Claude to know about something:

### Example 1: Docker Setup Guide
Create `claude/docker-setup.md`:
```markdown
# Docker Development Setup

How to set up Docker for development projects...
```

Then reference it in `CLAUDE.md`:
```markdown
For Docker setup, see `claude/docker-setup.md`
```

### Example 2: Database Schema
Create `claude/database-schema.md`:
```markdown
# Database Schema

Current database structure and relationships...
```

Claude will automatically read and use this knowledge.

## Organization Principles

### What goes in `claude/`?

✅ **DO add:**
- Reference guides (like fish-dev-functions.md)
- Optimization strategies (like commands-optimization.md)
- Architecture patterns
- Database schemas
- API specifications
- Security guidelines
- Common workflows
- Project-specific context

❌ **DON'T add:**
- Personal notes
- Work-in-progress docs
- Outdated information
- Duplicate content from elsewhere

### Naming

- Use descriptive names
- Use hyphens: `docker-setup.md`
- Use UPPERCASE for critical docs: `ARCHITECTURE.md`
- Use lowercase for specific topics: `database-schema.md`

## File Size Guidelines

- **Small** (< 2 KB): Quick references, checklists
- **Medium** (2-10 KB): Guides, explanations
- **Large** (> 10 KB): Comprehensive references, API docs

Current files:
- `fish-dev-functions.md` = 13 KB (comprehensive reference)
- `commands-optimization.md` = 6 KB (strategic explanation)

## Updating Context Docs

When you update a context file:

1. **Make the change**
2. **Update table of contents** (if applicable)
3. **Update CLAUDE.md** (add/update reference)
4. **Update docs/CLAUDE-CONTEXT.md** (update this file)
5. **Commit** with message like: "docs: update fish-dev-functions with new function"

## Cross-References

These docs reference each other:

```
CLAUDE.md
  ↓
  References: "See claude/fish-dev-functions.md"
  References: "See claude/commands-optimization.md"
     ↓
     fish-dev-functions.md
     └─ "For optimization, see commands-optimization.md"

     commands-optimization.md
     └─ "Uses functions from fish-dev-functions.md"
```

This creates a web of knowledge Claude can navigate.

## Impact on Claude's Responses

Having good context docs means:

- ✅ Claude suggests appropriate Fish functions
- ✅ Claude understands token optimization strategy
- ✅ Claude knows your preferred workflows
- ✅ Claude can recommend consistent patterns
- ✅ Claude reduces hallucination (has real facts)
- ✅ Faster, better, more accurate help

## Example: How Claude Uses This

**Scenario 1: User asks to create a branch**

Claude reads:
- `CLAUDE.md` → knows your git conventions
- `fish-dev-functions.md` → knows about `smart-branch`
- `commands-optimization.md` → knows when to use it
- `commands/branch.md` → knows how `/branch` works

Result: Claude recommends `smart-branch feat 42` with correct explanation

**Scenario 2: User asks for code review**

Claude reads:
- `CLAUDE.md` → knows your code quality standards
- `fish-dev-functions.md` → knows about `check-quality`
- `commands-optimization.md` → knows to run checks first
- `commands/review.md` → knows the workflow

Result: Claude suggests running `check-quality` first, then analyzes the real output

---

## Best Practices

1. **Keep docs up to date**
   - Stale info is worse than no info
   - Update when you change processes

2. **Be specific**
   - Not: "Sometimes use this"
   - Yes: "Use when dealing with X"

3. **Include examples**
   - Show real usage patterns
   - Make it concrete, not abstract

4. **Cross-link**
   - Reference related docs
   - Build knowledge web

5. **Document decisions**
   - Why you chose this approach
   - Trade-offs involved
   - Alternatives considered

## Summary Table

| File | Size | Type | Purpose | How Claude Uses |
|------|------|------|---------|-----------------|
| `fish-dev-functions.md` | 13 KB | Reference | All available functions | Recommends appropriate functions |
| `commands-optimization.md` | 6 KB | Strategy | Token optimization | Explains command workflows |

**Future additions:**
- `architecture.md` - System design
- `database-schema.md` - Database structure
- `api-reference.md` - API endpoints
- `security.md` - Security guidelines
- `testing-strategy.md` - How to test

---

**Last updated:** December 2024
**See also:** `docs/STRUCTURE.md` for folder organization
