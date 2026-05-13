# Review status (pre-merge readiness check)

## Context

- Current directory: !`pwd`
- Current branch: !`git branch --show-current 2>/dev/null || echo "(not a git repo)"`
- Arguments: $ARGUMENTS

## Invocation forms

| Form | Meaning |
|---|---|
| `/review-status` | head = current branch, base = repo default branch (develop / main / master, auto-detected). |
| `/review-status <head>` | head = `<head>`, base = default branch. `<head>` may be a step shortcut (`step2`) or full branch name. |
| `/review-status <head> <base>` | head = `<head>`, base = `<base>`. Both accept step shortcuts. Example: `/review-status step2 step1` reviews step2 against step1. |
| `/review-status <PR_NUMBER>` | Single numeric arg → fetch PR's head + base from GitHub, plus run the PR-description sanity checks (step 5 below). |

**Resolving step shortcuts:** when an arg is `step<N>` (no full path), expand it to the branch matching `*/step<N>*` in the current repo. If multiple match, ask the user which one.

**Auto-detecting the default branch:** prefer `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`; fall back to checking which of `develop` / `main` / `master` exists locally.

## Your task

Run a pre-merge readiness review of the diff `<base>..<head>` (or the PR). Surface issues that linting, format, and CI don't catch — specifically the kind that cause review pushback: stale comments, broken cross-file references, missed test fixture updates, lingering TODOs, stale PR descriptions.

This command is meant to be run **before requesting review** (or in response to reviewer pushback) so the author finds the issues themselves instead of the reviewer finding them.

## What to check

Run these checks in order. Stop and report each finding; don't auto-fix unless the user asks.

### 1. Build + tests + lint (the table stakes)

- Build the package: `catkin build <pkg>` (or appropriate equivalent — detect from `package.xml`/`Cargo.toml`/`package.json`).
- Run the test suite if present.
- `ruff check` + `ruff format --check` (or analogous formatter) on the changed files.

Report each as ✓ / ✗ — and if ✗, show the first 3 errors verbatim.

### 2. Cross-file caller check for deletions (the hard one)

This is the highest-value check — single-file orphan sweeps regularly miss callers in sibling files.

For each commit in the diff (`git log --oneline <base>..<head>`):
- Find symbols REMOVED by the commit: function defs, class defs, `self.X = ...` assignments, imports.
- For each removed symbol, grep the **entire package** (not just the changed file) for remaining references:
  ```bash
  # function/class
  grep -rn "\b<name>\b" --include='*.py' <package_root>

  # self.X proxy/attribute (consumed by sibling files via the host object)
  grep -rn "\.<attr>\b" --include='*.py' <package_root>
  ```
- For each match outside the changed file, flag it: "X removed in commit <sha> but still referenced at <file>:<line>."

Pay extra attention to:
- `self.X = rospy.ServiceProxy(...)` / `self.X = rospy.Publisher(...)` — these can be called by any class instantiated with a reference to the node (e.g., `self.node.X` in sibling helpers).
- Methods on manager classes used across multiple nodes.
- Re-exported symbols (`from .foo import X` in `__init__.py` may have external consumers).

Single-file `ruff --fix` orphan-import passes do NOT catch this class of bug. The chore commit `c2f0088c drop imports orphaned by move_to_navigate deletion` (May 2026, task_executor) is the canonical example: removed `self.compute_relative_path` because no caller existed *in the file*, but `home_robot.py:570` was still calling `self.node.compute_relative_path(req)` in the SOFT_COLLISION retract path.

### 3. Stale comments / docstrings

Search the changed files for:
- Docstrings or comments that reference a function/class/file that no longer exists.
- "TODO" / "FIXME" / "XXX" / "HACK" added in this PR — flag for the author to decide if they should land.

### 4. Test fixture coverage

If the PR adds a new service/action/topic consumed by a Behaviour or node:
- Check whether existing test fixtures (`conftest.py`, `client_manager` mocks) still match the new shape.
- Run the test suite and surface any `AttributeError: 'types.SimpleNamespace' object has no attribute 'X'` — that's the signature of an unupdated fixture.

### 5. PR description sanity (PR mode only)

Only runs when the invocation was `<PR_NUMBER>` (numeric arg). Skip silently otherwise.

- Fetch the PR body. Verify the "Summary of Changes" bullets still match the actual diff (`gh pr view N --json files --jq '.files[].path'`).
- Verify the cross-repo / stacked-PR tables (if present) reference still-open PRs in the correct order.
- Check for review comments that haven't been replied to or addressed in a follow-up commit.

### 6. Stack consistency (if branch matches `*/step<N>*`)

- For step branches, verify the chain `develop ← step1 ← step2 ← stepN` — each child contains its parent's tip (`git merge-base --is-ancestor`).
- If a parent moved forward since this branch was based, surface it: "stepN is `<X>` commits behind stepN-1."
- Check the corresponding PR's `baseRefName` matches the local parent.

## Reporting format

Print a checklist:

```
[✓] Build
[✓] Tests (2638 passed)
[✓] ruff check + format
[✗] Cross-file caller check
    - self.compute_relative_path removed in 45e3c198 but home_robot.py:570 still calls self.node.compute_relative_path
[✓] No stale comments
[✗] Test fixture coverage
    - tests/test_completion.py:48 client_manager fixture is missing clear_octomap_service
[✓] PR description matches diff
[✓] Stack ancestry clean
```

For each ✗, show enough context (file:line, sha, exact symbol) that the user can act without re-running grep.

## Rules

- Read-only by default. Never edit files, never push, never create commits — surface findings, let the user decide.
- Resolve args per the "Invocation forms" table above. Print the resolved `head` and `base` at the top of the report so the user can confirm the comparison range.
- For multi-repo workspaces (e.g., a `src/` containing multiple git repos), default to the repo of the current working directory. Operate on other repos only if explicitly asked.
- Don't run the build/tests if the user passes `--no-build` (useful when they've already built and just want the cross-file/text checks).
- For deletion sweeps, the package root is the closest ancestor containing `package.xml` (ROS), `pyproject.toml`/`setup.py`, or analogous root marker. If unsure, use `git rev-parse --show-toplevel`.
