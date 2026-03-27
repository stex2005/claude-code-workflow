---
description: Create a GitHub issue with background, acceptance criteria, and time budget.
allowed-tools: Bash(gh *)
argument-hint: [repo]
---

Create an issue in the repository $ARGUMENTS using `gh issue create`.

The issue should include the following sections:

```
# Background

A brief description of the context and motivation for the issue.

# Acceptance Criteria

A clear list of criteria that must be met for the issue to be considered resolved.

# Time budget

An estimate of the time required to complete the work, after which the implementer should reassess if the issue should be completed or get help.
```
