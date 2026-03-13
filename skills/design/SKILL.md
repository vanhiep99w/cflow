---
name: design
description: "Use after brainstorming when project has UI components — creates wireframes and mockups using Pencil MCP design tools"
---

# Design with Pencil MCP

## Overview

Create wireframes and visual designs for UI components using Pencil MCP tools before implementation.

**Core principle:** Design UI before coding it. Visual feedback catches UX issues early.

**Announce at start:** "I'm using the cf:design skill to create UI designs with Pencil."

## Prerequisites

- Pencil desktop app or IDE extension must be running
- Pencil MCP server must be connected

**Check on start:**
```bash
# Verify Pencil MCP is available by attempting to use batch_get
# If MCP tools not available → warn and skip
```

**If Pencil unavailable:**
> "Pencil MCP not connected. Skipping design phase. Proceeding to cf:plan."
> Invoke cf:plan directly.

## Checklist

1. **Verify Pencil connected** — attempt batch_get, confirm MCP tools available
2. **Read spec** — load spec_ref from epic, identify screens/components needing design
3. **List screens** — present: "These screens need design: [list]. Agree?"
4. **Create wireframes** — for each screen: batch_design → create .pen → get_screenshot → preview
5. **User review loop** — per screen: "ổn" → next / "đổi layout" → update → re-preview / "không phải" → clarify → redesign
6. **Finalize** — user approves all screens → commit .pen files
7. **Update Beads** — `bd update <design-task-id> --done`, save design_ref to epic
8. **Transition** — invoke cf:plan

## Pencil MCP Tools

| Tool | Use |
|------|-----|
| batch_design | Create/modify design elements (insert, copy, update, replace, move) |
| batch_get | Read component hierarchy, search patterns, inspect structure |
| get_screenshot | Render preview of design, verify visual output |
| snapshot_layout | Analyze layout structure, detect positioning issues |
| get_editor_state | Get current context: selection info, active file |
| get_variables / set_variables | Read/update design tokens, theme values |

## Process

For each screen identified:

1. Read spec requirements for this screen
2. Use `batch_design` with insert operations to create layout
3. Use `get_screenshot` to preview
4. Present preview to user (describe what was created)
5. User feedback → iterate or approve

## After Design

- Save all .pen files in project
- Commit: `git add *.pen && git commit -m "design: add wireframes for <feature>"`
- Update epic: `bd update <epic-id> --note "design_ref: <path-to-pen-files>"`
- Mark design task done: `bd update <design-task-id> --done`
- Invoke cf:plan

## Red Flags

**Never:**
- Skip to implementation without user approval of designs
- Assume designs from spec description alone (create visual, get feedback)
- Proceed if Pencil MCP is not connected (skip design phase instead)

**Always:**
- Get explicit user approval for each screen
- Save .pen files and commit them
- Update Beads with design_ref
