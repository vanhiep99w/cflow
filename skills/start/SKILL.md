---
name: start
description: "Use when starting any conversation - initializes Beads task state and establishes how to find and use cf:* skills"
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Cflow skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Cflow skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

## Session Init

On every session start, before any skill routing:

1. Check if Beads initialized: `bd show` — if command fails → ask user:
   "Initialize Beads? (1) Normal mode (2) Stealth/local-only mode"
   Then run `bd init` or `bd init --stealth` accordingly.
2. Check for git repo — if no git repo: "Initialize git first (`git init`) before using cflow."
3. Run `bd ready` to get task state
4. Present task state to user:

| State | Action |
|-------|--------|
| Paused tasks exist | Show first: "You have paused task: [id] '[title]'. Resume?" → invoke cf:resume |
| Pending tasks exist | "Tasks available: [list]. Pick one?" → `bd update --claim` |
| All tasks done | "All tasks complete. Review or start new?" → invoke cf:review or cf:brainstorm |
| No tasks | "No tasks. Describe what you want to build." → invoke cf:brainstorm |
| All tasks blocked (bd ready empty but tasks exist) | Show blocked list: "All tasks blocked. Blockers: [list]." Identify which blocker to resolve first. |
| Multiple tasks in_progress (invalid) | Pause all but most recent, warn user |

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke cf:brainstorm skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Track with bd create/update" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke cf:brainstorm skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke cf:brainstorm skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Track with bd create/update" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Track with bd create/update" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

## Available cf:* Skills

| Skill | When to invoke |
|-------|---------------|
| cf:brainstorm | Before any creative work — features, components, functionality |
| cf:design | After brainstorm, when project has UI components, Pencil MCP available |
| cf:plan | After brainstorm (or design), to create implementation plan |
| cf:implement | When you have a plan with tasks to execute |
| cf:tdd | When implementing any feature or bugfix |
| cf:debug | When encountering bugs, test failures, unexpected behavior |
| cf:review | After completing tasks, before merging |
| cf:receive-review | When receiving code review feedback |
| cf:dispatch | When facing 2+ independent tasks that can run in parallel |
| cf:sdd | When executing plans with subagents |
| cf:worktree | When starting feature work needing isolation |
| cf:verify | Before claiming work is complete |
| cf:finish | When implementation complete, ready to merge/PR |
| cf:pause | When user wants to stop current task and save context |
| cf:resume | When user wants to continue a paused task |
| cf:bug | When user reports a bug or test regression detected |
| cf:status | When user asks about progress |
| cf:write-skill | When creating or editing skills |
