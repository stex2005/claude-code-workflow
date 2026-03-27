---
description: Save or update the current plan to docs/superpowers/plans/ in the repo
allowed-tools: Bash(ls:*), Bash(mkdir:*), Read, Write, Edit, Glob, Grep
---

## Your task

Save the current conversation's plan to `docs/superpowers/plans/` in the current repo.

### Steps

1. If the user specified a plan name, use that. Otherwise, infer a short name from the current work or ask.
2. Create the directory `docs/superpowers/plans/` if it doesn't exist.
3. If a plan file already exists for this feature, read it first to understand what's there.
4. Write or update the plan file using the superpowers plan format:
   - Filename: `YYYY-MM-DD-<feature-name>.md` (use today's date for new plans).
   - Include the standard header: Goal, Architecture, Tech Stack.
   - Structure as tasks with checkbox steps (`- [ ]` syntax).
   - Include exact file paths, code snippets, and commands.
5. Confirm to the user what was saved and where.

### Rules

- Plans live in `docs/superpowers/plans/` in the repo, NOT in `~/.claude/plans/`.
- Follow the superpowers plan format (tasks with checkbox steps, TDD, exact file paths).
- Preserve existing plan content that is still relevant. Update checkbox status rather than rewriting from scratch.
- Do NOT delete existing plan files unless the user explicitly asks.
