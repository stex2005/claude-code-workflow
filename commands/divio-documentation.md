---
description: Generate documentation following the Divio/Diataxis system — tutorials, how-tos, reference, or explanation.
allowed-tools: Read, Write, Glob, Grep
---

## Divio Documentation System

There are four distinct types of documentation, each serving different user needs:

1. **TUTORIALS** (Learning-oriented, practical, for studying)
2. **HOW-TO GUIDES** (Problem-oriented, practical, for working)
3. **REFERENCE** (Information-oriented, theoretical, for working)
4. **EXPLANATION** (Understanding-oriented, theoretical, for studying)

## Decision Framework

Ask yourself:
- "I want to learn X" -> **Tutorial**
- "I want to accomplish Y" -> **How-to**
- "What are the parameters of Z?" -> **Reference**
- "Why does X work this way?" -> **Explanation**

## Guidelines per Type

### Tutorials
- Start from zero, no assumptions
- One clear path, no options or alternatives
- Every step produces a visible result
- Minimal explanation (link to Explanation instead)

### How-to Guides
- Assume basic knowledge
- Focus on one specific goal
- Be concise and action-oriented
- Don't teach concepts (link to Explanation)

### Reference
- Mirror the codebase organization
- Absolute consistency in tone and format
- All parameters, return values, exceptions
- No instructions or opinions

### Explanation
- Broader, higher-level view
- Discuss background, context, design decisions
- Explore trade-offs and alternatives
- No step-by-step instructions

## Your task

Determine which type of documentation is needed for the user's request, then generate it following the strict guidelines for that type. Keep the four types separate — don't mix them. Cross-link between types where appropriate.
