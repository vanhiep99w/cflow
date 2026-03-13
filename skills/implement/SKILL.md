---
name: implement
description: Use when you have a written implementation plan to execute, using Beads for task tracking and progress reporting
---

# Implement

## Overview

Load plan via Beads, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the implement skill to execute this plan."

**Note:** Tell your human partner that Cflow works much better with access to subagents. The quality of its work will be significantly higher if run on a platform with subagent support (such as Claude Code or Codex). If subagents are available, use cf:sdd instead of this skill.

## The Process

### Step 1: Load and Review Plan

1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns:
   - Run `bd ready` to get actionable tasks.
   - Pick highest priority task: `bd update <task-id> --claim`

### Step 2: Execute Tasks

For each task:
1. Claim the task: `bd update <task-id> --claim`
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as done: `bd update <task-id> --done`

**Cascade check after `bd update --done`:**
- Check if all sibling subtasks are done -> auto mark parent task done
- BUT: if any P0 bug is open and linked to parent -> do NOT auto-mark parent done (blocked)
- Check if all tasks in epic done (and no P0 bugs open) -> auto mark epic done
- Report progress: "Task X done. Epic: Y/Z tasks complete (N%)"

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finish skill to complete this work."
- **REQUIRED SUB-SKILL:** Use cf:finish
- Follow that skill to verify tests, present options, execute choice

## Error Handling

- If any `bd` command fails: retry once. If still fails, inform user with error message. Do NOT proceed with stale task state.
- If `bd update --claim` fails (conflict -- already claimed by another agent): pick next available task from `bd ready`. Inform user: "Task X already claimed. Picking next available."
- If `bd ready` returns empty: check if all done -> cf:review. No tasks exist -> cf:brainstorm. All blocked -> show blocked list.

## Interrupt Handling

- **Pause detection:** user says "dung lai" / "pause" -> invoke `cf:pause`
- **Bug detection:** user says "co bug" -> invoke `cf:bug`
- **Status check:** user says "tien do?" -> invoke `cf:status`
- **Task switch:** user says "lam task khac" -> invoke `cf:pause` then `bd ready`

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **cf:worktree** - REQUIRED: Set up isolated workspace before starting
- **cf:plan** - Creates the plan this skill executes
- **cf:finish** - Complete development after all tasks
