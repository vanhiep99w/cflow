---
name: status
description: "Use when user asks about project progress — shows epic progress tree from Beads with task counts, bugs, and blockers"
---

# Project Status

## Overview

Display progress overview from Beads task state.

**Announce at start:** "Checking project status..."

## The Process

### Step 1: Get Epic State

```bash
bd show <epic-id>  # Full epic with all tasks, subtasks, bugs
```

### Step 2: Calculate Progress

For each level:
- Count: done/total tasks
- Percentage: (done/total) * 100
- Identify: open bugs, blocked tasks

### Step 3: Present Progress Tree

```
📊 Epic: "<title>" [<priority>]
  Progress: X/Y tasks done (Z%)

  ✅ Task: "<done-task>" [done]
  🔄 Task: "<in-progress-task>" [in_progress]
    ├── ✅ Subtask: "<done>" [done]
    ├── 🔄 Subtask: "<current>" [in_progress]
    └── ○ Subtask: "<pending>" [pending]
  ⏸ Task: "<paused-task>" [paused]
  ○ Task: "<pending-task>" [pending, blocked by: <id>]

  🐛 Open bugs: N
    - [P0] "<bug-title>" relates_to <task-id>

  ⏱ Recent activity:
    - 2h ago: "<subtask>" marked done
    - 5h ago: "<task>" claimed
```

### Step 4: Resume

After showing status, continue with current work (don't interrupt flow).

## Integration

- **cf:start** shows a condensed version at session start
- User can invoke anytime during implementation via `/cf:status`
