---
name: pause
description: "Use when user wants to stop current task and save context — detects in_progress task, saves notes and context to Beads, commits WIP"
---

# Pause Current Task

## Overview

Save progress on current task so it can be resumed later, even in a different session.

**Core principle:** Never lose context. Save everything needed to resume seamlessly.

**Announce at start:** "I'm using the cf:pause skill to save your progress."

## The Process

### Step 1: Detect Current Task

```bash
bd ready  # Find task with status=in_progress
```

If no task in_progress: "No active task to pause."

If multiple tasks in_progress (invalid state): pause all but most recent, warn user.

### Step 2: Confirm Intent

For natural language triggers ("dừng lại", "pause", "nghỉ đã"):
> "Bạn muốn pause task [id] '[title]'?"

**Disambiguation:** "stop" in other contexts (e.g., "stop explaining") does NOT trigger pause.
Only trigger when intent is clearly about stopping the current task. If uncertain, confirm first.

For `/cf:pause` command: skip confirmation, proceed directly.

### Step 3: Gather Context

Ask: "Ghi chú gì trước khi pause? (hoặc skip)"

Auto-collect:
- Current branch: `git branch --show-current`
- Current file being edited (from recent git diff)
- Progress notes from user (or auto-generate from recent changes)

### Step 4: Save to Beads

Note: If `bd update --context` is not supported by the CLI, embed context in `--note`:

```bash
bd update <task-id> --status paused \
  --note "Progress: <user-note> | context: branch:<branch> file:<file>:<line>"
```

### Step 5: Commit WIP

```bash
git add -A
git commit -m "WIP: pause <task-title>"
```

### Step 6: Confirm

> "Task [id] '[title]' paused. Progress saved. Run `bd ready` or start new session to see paused tasks."

## Red Flags

**Never:**
- Pause without saving context (branch, file, progress)
- Lose uncommitted changes (always commit WIP)
- Trigger pause from ambiguous user intent (confirm first)
