---
description: Analyze a GitHub issue, assess information sufficiency, and create an implementation plan.
allowed-tools: Bash(gh *), Bash(git *), Read, Write, Glob, Grep
argument-hint: <issue-url-or-number>
---

## Steps

1. Pull the information and comments about the issue $ARGUMENTS using `gh issue view $ARGUMENTS --comments`.
2. Read relevant parts of the codebase to understand the current state related to the issue.
3. Given the codebase, the issue description, and any discussion within the issue comments, determine if there is enough information to implement the issue.
   - If there is not enough information, list the missing information and suggest asking for clarification via `gh issue comment`.
   - If there is enough information, create a plan to implement the issue.

## Plan format

Write the plan to stdout using the following format:

```markdown
---
issue: $ARGUMENTS (link to issue)
---

# Summary

A high level overview of what needs to get done.

# Expectations and Assumptions

A list of expectations and assumptions about the issue.

# Current State

A summary of the current state of the codebase related to the issue.

# Related Issues

A list of related issues that may impact the implementation.

# Information Sufficiency Assessment

An evaluation of whether there is enough information to implement the issue.

# Open Questions

A list of open questions that need to be answered before implementation can begin.

# Implementation Plan

A detailed plan to address the issue.
```
