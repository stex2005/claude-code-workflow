---
description: Reply to a PR comment — evaluate feedback, implement or explain rejection, with user approval.
allowed-tools: Bash(gh *), Bash(git *), Read, Write, Edit, Glob, Grep
argument-hint: <pr-number>
---

## Goal

Reply to a comment on a pull request appropriately, using the codebase, pull request description and comment history as context.

## Steps

1. Get all the prior comments to build context using `gh pr view $ARGUMENTS --comments`.
2. Read relevant parts of the codebase to understand the context.
3. Determine whether the feedback (the comment) is appropriate and actionable.
   - If it is appropriate and actionable, implement the requested changes in the codebase.
   - If it is not appropriate or actionable, respond to the comment explaining why the change will not be made.
     - When addressing the comments, first display its content, then explain your reasoning for accepting or rejecting it, then let me approve or reject your decision.
       - If the decision is approved, either make the change or respond to the comment as appropriate.
4. If changes are made, commit and push them to the PR branch.
