---
description: Conduct a comprehensive code review of a GitHub pull request.
allowed-tools: Bash(gh *), Bash(git *), Read, Write, Glob, Grep
argument-hint: <pr-number>
---

## Setup

Pull the information about the PR $ARGUMENTS using `gh pr view $ARGUMENTS --comments` and `gh pr diff $ARGUMENTS`.

## Pre-Review Checklist

Before diving into the code, verify:

- **Build & Tests**: Verify that the build/tests pass.
- **PR Metadata**:
  - Is the title and description clear and complete?
  - Does the PR link to an issue for traceability?
  - Is the change size appropriate?
- **Understanding the Objective**:
  - Read the linked issue title and description (use `gh` to pull issue details).
  - For bug fixes: understand the root cause being addressed.

## Code Review Checklist

### Scope & Relevance

- Are there unrelated formatting changes, refactorings, or fixes that should be separate PRs?
- Do irrelevant changes obscure the actual changes being reviewed?

### Code Quality & Design

- **Naming**: Are classes, methods, functions, parameters named clearly and following conventions?
- **Design Principles**: Does the code respect SOLID? Follow existing patterns? Avoid DRY violations?
- **Code Style**: Magic numbers/strings extracted? Dead or commented-out code removed?
- **Type Safety**: Are parameters and return types annotated (in typed/type-hinted languages)?

### Testing & Coverage

- Does the PR include tests? Is new code covered?
- Do tests cover edge cases and error scenarios?
- Are tests testing behavior rather than implementation details?

### Architecture & Structure

- Are new/moved files in the right location with appropriate names?
- Are new dependencies justified, version-pinned, and license-compatible?
- Are backward-incompatible changes documented?
- Are design decisions reversible?

### Operational Concerns

- **Logging**: Appropriate levels? No sensitive data logged?
- **Error Handling**: Graceful handling? Meaningful messages? Resource cleanup?
- **Performance**: N+1 queries? Inefficient algorithms? Appropriate caching?

### Security & Data

- Input validated and sanitized?
- No hardcoded secrets or credentials?
- Parameterized queries? XSS/CSRF protections?
- PII handled appropriately? Data migrations safe and reversible?

### Documentation

- Complex algorithms or business logic commented?
- Public APIs documented?
- README or user-facing docs need updates?
- Breaking changes documented?

## Review Communication Guidelines

When providing feedback:

- Be specific and actionable — include code examples when helpful.
- Prioritize feedback using RFC 2119 language: MUST, SHOULD, MAY.
- Assume competence. Provide rationale. Criticize the code, not the person.

## Output

Print the review to the console with:
- Overall status at the top (ready to merge, needs work, etc.)
- Grouped findings by severity (MUST / SHOULD / MAY)
- Specific line references where applicable
