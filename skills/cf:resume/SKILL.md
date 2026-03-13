---
name: resume
description: "Use when user wants to continue a previously paused task — shows paused tasks, restores context from Beads"
---

# Resume Paused Task

## Overview

Continue a task that was previously paused, restoring full context.

**Core principle:** Seamless continuation. The user should feel like they never stopped.

**Announce at start:** "I'm using the cf:resume skill to restore your previous work."

## The Process

### Step 1: List Paused Tasks

```bash
bd ready  # Paused tasks appear first in priority order
```

Present paused tasks with their saved context:
```
⏸ PAUSED tasks:
  [id] "[title]" [priority]
    Note: <saved-progress-note>
    Context: branch:<branch> file:<file>:<line>
    Last updated: <time-ago>
```

### Step 2: User Selects Task

If one paused task: "Resume [id] '[title]'?"
If multiple: "Which task to resume?"
User can also say "làm task khác" → show pending tasks instead.

### Step 3: Restore Context

```bash
# Checkout the saved branch
git checkout <saved-branch>

# If branch doesn't exist: ask user which branch to use
# "Branch '<saved-branch>' not found. Which branch should I use?"

# Read the saved file context
# Open/read the file at saved location
```

### Step 4: Claim Task

```bash
bd update <task-id> --claim  # Sets status=in_progress + assignee
```

### Step 5: Brief User

> "Resumed [id] '[title]'. Last progress: <saved-note>. Branch: <branch>. Continue from <file>:<line>."

Then continue with implementation (invoke cf:implement or cf:tdd as appropriate).

## Integration

- **cf:start** invokes this automatically when paused tasks are detected at session start
- **cf:pause** creates the paused state this skill reads
