---
description: Resume work on a saved plan from docs/superpowers/plans/
allowed-tools: Bash(ls:*), Read, Write, Edit, Glob, Grep, Agent, Skill, EnterPlanMode, ExitPlanMode
---

## Your task

Resume work on an existing plan saved in `docs/superpowers/plans/` in the current repo.

### Steps

1. List available plan files under `docs/superpowers/plans/` using the Glob tool.
   - Also check `~/.claude/plans/` for legacy plans and mention them if found.
2. If the user specified a plan name in the arguments, use that. Otherwise, show the list and ask which plan to resume.
3. Read the chosen plan file.
4. Summarize:
   - Overall goal of the plan
   - Full status table of all tasks (checked `[x]` / unchecked `[ ]`)
   - Automatically identify the **first unchecked task** (the next step to implement)
5. Offer execution choice:
   - **Subagent-Driven (recommended):** Invoke `superpowers:subagent-driven-development`
   - **Inline Execution:** Invoke `superpowers:executing-plans`
6. If the user doesn't have a preference, default to subagent-driven and proceed.

### Rules

- Always re-read the plan file at the start -- it may have been updated outside this session.
- When completing a step, update the plan file to check off the checkbox (`- [x]`).
- If a step is blocked or needs clarification, flag it to the user before proceeding.
- Plans use checkbox syntax (`- [ ]` / `- [x]`), not status fields.
