---
description: Start a new plan using the superpowers planning workflow (brainstorm → write plan → execute)
allowed-tools: Bash(ls:*), Bash(mkdir:*), Read, Write, Edit, Glob, Grep, Agent, Skill
---

## Your task

Start a new plan using the superpowers workflow. This delegates to the superpowers skills for brainstorming and plan writing.

### Steps

1. **Brainstorm first.** Invoke `superpowers:brainstorming` to explore requirements, constraints, and design before writing any plan.
2. **Write the plan.** Once brainstorming is complete, invoke `superpowers:writing-plans` to produce the implementation plan.
   - Plans are saved to `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md` in the current repo.
3. **Execution handoff.** After the plan is written, offer the execution choices as described by the writing-plans skill (subagent-driven or inline).

### Rules

- Always brainstorm before writing the plan — do not skip straight to plan writing.
- Plans live in the repo under `docs/superpowers/plans/`, not in `~/.claude/plans/`.
- Follow the superpowers plan format (tasks with checkbox steps, TDD, exact file paths, exact commands).
- Do NOT start implementation until the user approves the plan.
