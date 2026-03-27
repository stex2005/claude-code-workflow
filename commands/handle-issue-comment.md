---
description: Reply to a GitHub issue comment using codebase and discussion history as context.
allowed-tools: Bash(gh *), Bash(git *), Read, Glob, Grep
argument-hint: <issue-url-or-number>
---

## Goal

Reply to a comment on an issue appropriately, using the codebase, issue description and comment history as context.

## Steps

1. Get all the comments to build context using `gh issue view $ARGUMENTS --comments`.
2. Read relevant parts of the codebase to understand the context.
3. Reply to the comment appropriately, using the codebase, issue description and comment history as context.
