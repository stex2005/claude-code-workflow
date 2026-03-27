---
description: Create a draw.io diagram showing the PR stack across repos — steps, changes, and which repos are affected.
allowed-tools: Bash(git *), Bash(gh *), Bash(ls *), Bash(for *), Bash(cd *), Bash(drawio:*), Bash(xdg-open:*), Read, Write, Edit, Glob, Grep
---

## Context

- Current directory: !`pwd`
- Directory contents: !`ls`
- Arguments: $ARGUMENTS (optional: output file path)

## Workspace detection

Detect the workspace mode before proceeding:

1. **Single-repo mode**: The current directory contains a `.git` folder → diagram shows steps for this repo only (column layout simplifies to a single column).
2. **Multi-repo mode**: The current directory does NOT contain `.git`, but has subdirectories that do → diagram shows the matrix of steps × repos.
3. **Error**: Neither condition is met → inform the user and stop.

## Your task

Generate a draw.io diagram that visualizes the entire PR stack — showing which steps exist, what each step changes, and (in multi-repo mode) which repos are involved.

### Step 0: Gather data

**Branch naming convention:**

Step branches follow two patterns:
- **Main steps** (linear chain): `<slug>/step1`, `<slug>/step2`, etc. Each step builds on the previous one.
- **Fork branches** (independent work branching from a step): `<slug>/step2-<fork-name>`. A fork branches off from the step it's named after (e.g., `step2-sensor-cleanup` forks from `step2`) and is independent — it does NOT feed into step3.

Detect forks by checking for branches matching `*/step<N>-*`. The part after the dash is the fork name.

**Single-repo mode:**
1. Find step branches: `git branch --list '*/step*'`
   If no branches match, inform the user and stop.
2. Classify each branch as a main step or a fork:
   - `*/step<N>` (no suffix after the number) → main step N
   - `*/step<N>-<name>` → fork from step N, named `<name>`
3. For each branch, collect:
   - Branch name
   - One-line summary: `git log --oneline <base>..<branch> | head -5`
   - Diff stat: `git diff --stat <base>..<branch>`
   - Whether a PR exists: `gh pr list --head <branch> --json number,state,url`
   - For main steps, base is the previous step (or develop for step1). For forks, base is the step they fork from.
4. Read the plan files from `~/.claude/plans/` to get step titles and goals.

**Multi-repo mode:**
1. Scan all sub-repos for step branches:
   ```bash
   for d in */; do (cd "$d" && branches=$(git branch --list '*/step*' 2>/dev/null); [ -n "$branches" ] && echo "REPO:${d%/}" && echo "$branches"); done
   ```
   If no branches match, inform the user and stop.
2. Classify each branch as a main step or a fork (same rules as above).
3. For each repo with step branches, collect per step/fork:
   - Branch name
   - Commit messages — compare against the correct base:
     - step1: `git log --oneline develop..step1`
     - stepN: `git log --oneline step(N-1)..stepN`
     - stepN-forkname: `git log --oneline stepN..stepN-forkname`
   - Read the changed files to understand what was done
   - Whether a PR exists: `gh pr list --head <branch> --json number,state,url`
4. Read the plan files from `~/.claude/plans/` to get step titles and goals.
5. For each repo+step, write a brief summary (1-2 sentences) of what the changes do — focus on the *what* and *why*, not file counts.
6. Build a data structure:
   ```
   Step 1 "split files"        → [common (..., PR #142 open), hal (..., no PR)]
   Step 2 "gripper class"      → [common (..., PR #143 open), sim (..., PR #205 open)]
   Fork 2-sensor-cleanup       → [hal (..., PR #210 open)]
   Step 3 "planning logic"     → [task_executor (..., no PR)]
   ```

### Step 1: Design the matrix layout

Create a **table/matrix** with repos as columns and steps/forks as rows:

```
                        | common | hal | sim | task_executor | orchestrator |
  Step 1: split files   |  ✔ PR  |  ✔  |  —  |      —        |      —       |
  Step 2: gripper class |  ✔ PR  |  —  |  ✔  |      —        |      —       |
  ↳ sensor-cleanup      |   —    |  ✔  |  —  |      —        |      —       |
  Step 3: planning      |   —    |  —  |  —  |     ✔ PR      |      —       |
```

- **Column headers**: One per repo that has at least one step branch. Use short repo names (strip common prefixes if all repos share one).
- **Row headers**: Main steps labeled `Step N: <slug>`. Fork rows appear directly below their parent step, indented with `↳ <fork-name>` to show they branch off that step.
- **Row ordering**: Main steps in order (1, 2, 3...). Forks appear immediately after their parent step, sorted alphabetically.
- **Cells**: Each intersection shows whether that repo participates in that step/fork, with a brief summary and PR status.
- **Empty cells**: Repos not involved in a step get an empty/dash cell.

### Step 2: Generate the draw.io XML

Use draw.io's native HTML table inside a single `mxCell` to produce a clean matrix. This renders as a proper grid without needing individual cells and arrows.

**Table structure:**

```html
<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;font-size:12px;">
  <tr style="background:#dae8fc;">
    <th></th>
    <th>common</th>
    <th>hal</th>
    ...
  </tr>
  <tr>
    <td style="background:#dae8fc;font-weight:bold;">Step 1: split files</td>
    <td style="background:#d5e8d4;">Split node into pub/sub<br/>PR #142 (open)</td>
    <td style="background:#fff2cc;">Extract HW config<br/>(no PR)</td>
    <td style="background:#f5f5f5;">—</td>
    ...
  </tr>
  <tr>
    <td style="background:#dae8fc;font-weight:bold;">Step 2: gripper class</td>
    <td style="background:#d5e8d4;">Add GripperCommand<br/>PR #143 (open)</td>
    ...
  </tr>
  <!-- Fork row: indented label, lighter header background -->
  <tr>
    <td style="background:#e8e0f0;font-weight:bold;padding-left:16px;">↳ sensor-cleanup</td>
    <td style="background:#f5f5f5;">—</td>
    <td style="background:#fff2cc;">Remove legacy sensor polling<br/>(no PR)</td>
    ...
  </tr>
  ...
</table>
```

**Cell background colors by status:**
- **PR open/approved**: `#d5e8d4` (green)
- **No PR yet**: `#fff2cc` (yellow)
- **PR merged**: `#f5f5f5` (gray), gray text
- **Not involved**: `#f5f5f5` (gray), dash

**Row header colors:**
- **Main steps**: `#dae8fc` (blue)
- **Fork rows**: `#e8e0f0` (purple), label indented with `↳` prefix

**Cell content format:**
- Active cell: `<brief 1-line summary><br/>PR #N (state)` or `<brief summary><br/>(no PR)`
- Inactive cell: `—`

**mxCell for the table:**
```xml
<mxCell id="matrix" value="<HTML TABLE HERE>" style="text;html=1;overflow=fill;whiteSpace=wrap;fontSize=12;" vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="WIDTH" height="HEIGHT" as="geometry" />
</mxCell>
```

Set `width` and `height` to fit the table: ~180px per column + 200px for the row header column, ~80px per row + 40px for the header row.

### Step 3: Write the file

1. If the user provided an output path argument, use it. Otherwise suggest `docs/pr-stack-diagram.drawio`.
2. Ask the user for confirmation on file name.
3. Write the `.drawio` file.
4. Print a summary:
   - Total steps and repos involved
   - How many PRs exist vs missing
   - Which steps span the most repos

### Draw.io XML rules

- CRITICAL: `<mxfile>` MUST have `host="app.diagrams.net"` attribute.
- CRITICAL: Every edge MUST have a child `<mxGeometry relative="1" as="geometry" />` element.
- CRITICAL: Use self-closing tags for `<mxCell ... />` and `<mxGeometry ... />` when they have no children.
- Use `&#xa;` for newlines inside `value` labels (not `<br>`).
- Use the standard draw.io XML structure:
  ```xml
  <mxfile host="app.diagrams.net" type="device">
    <diagram id="unique-id" name="PR Stack Overview">
      <mxGraphModel dx="1200" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1100" pageHeight="850" math="0" shadow="0">
        <root>
          <mxCell id="0" />
          <mxCell id="1" parent="0" />
          <!-- shapes and edges here -->
        </root>
      </mxGraphModel>
    </diagram>
  </mxfile>
  ```
- Assign unique `id` attributes to every `mxCell`.
- Set `pageWidth` and `pageHeight` large enough to fit all columns and rows.
- Avoid overlapping nodes; use grid-aligned positions.

### Rules

- Always produce valid draw.io XML that can be opened without errors.
- Do NOT produce ASCII art, Mermaid, or PlantUML — only draw.io XML.
- If the stack is very large (>8 steps or >6 repos), ask the user if they want to filter or split into multiple diagrams.
- If no step branches exist in any repo, inform the user and stop.
- If the user asks to open the diagram, run `drawio <file>` (or `xdg-open <file>` as fallback). Do NOT open automatically.
