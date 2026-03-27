---
description: Auto-label a GitHub issue based on its description, using existing repo labels.
allowed-tools: Bash(gh *)
argument-hint: <issue-url-or-number>
---

Pull the information about the issue $ARGUMENTS using `gh`.

Based on the issue description, determine the existing labels that are relevant to the issue and use `gh issue edit` to add those labels to the issue.

Recommend new labels if they would help categorize the issue better.
