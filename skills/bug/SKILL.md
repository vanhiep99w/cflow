---
name: bug
description: "Use when user reports a bug or test regression is detected — creates bug task in Beads, links to related tasks, triggers debug for P0"
---

# Report & Track Bug

## Overview

Create tracked bug tasks in Beads with proper priority, linking, and automatic response based on severity.

**Core principle:** Every bug is tracked. P0 bugs interrupt immediately. P2+ bugs are logged for later.

**Announce at start:** "I'm using the cf:bug skill to track this bug."

## Triggers

### 1. User reports directly
User says "có bug trong login" / "lỗi khi submit form"
→ Confirm: "Bạn muốn report bug? Liên quan task nào?"
→ **Disambiguation:** "bug in the spec" or "lỗi trong design" does NOT auto-trigger.
  Agent must confirm intent before creating bug task.

### 2. /cf:bug command
User types `/cf:bug "description"`
→ Auto-link with current in_progress task
→ Proceed to clarification

### 3. Test regression detected
During TDD, a previously passing test fails:
→ Agent analyzes: new test failing (normal TDD) vs. old test regression
→ If regression: "Test '[name]' regressed. Create bug task?"
→ User confirms → proceed. User denies → investigate inline.

## The Process

### Step 1: Clarify

Ask (if not already provided):
1. "Mô tả bug?" (what happened vs what should happen)
2. "Priority? P0=critical/blocking, P1=high, P2=medium, P3=low"
3. "Reproduce steps?" (optional but helpful)

### Step 2: Create Bug in Beads

```bash
bd create "<bug-title>" --type bug --priority <P0-P3> --parent <epic-id>
bd link <bug-id> relates_to <current-task-id>
```

### Step 3: Priority-Based Action

| Priority | Action |
|----------|--------|
| P0 | Auto invoke cf:pause on current task → invoke cf:debug for bug fix |
| P1 | Ask: "Fix ngay hay tiếp tục task hiện tại?" |
| P2-P3 | "Bug [id] logged. Tiếp tục task hiện tại." |

### Step 4: After Bug Fixed (for P0/P1 fixed immediately)

```bash
bd update <bug-id> --done --note "root cause: <description>"
```
→ Blocked tasks auto-unblock
→ If a task was paused for this bug → offer cf:resume

## Red Flags

**Never:**
- Skip creating Beads task for bugs (all bugs must be tracked)
- Auto-create bug task without user confirmation (for NL triggers)
- Ignore P0 bugs (always interrupt current work)
