# Cflow

Agentic workflow skills for Claude Code, fork from [Superpowers](https://github.com/obra/superpowers) with [Beads](https://github.com/steveyegge/beads) git-backed task tracking and [Pencil MCP](https://pencil.evolves.dev) UI design.

## Installation

### Claude Code (via Plugin Marketplace)

Register the marketplace:

```bash
/plugin marketplace add vanhiep99w/cflow
```

Install the plugin:

```bash
/plugin install cf@cflow-dev
```

### Claude Code (Manual)

```bash
git clone https://github.com/vanhiep99w/cflow.git
cd your-project
claude plugin add /path/to/cflow
```

### Requirements

- **[Beads CLI](https://github.com/steveyegge/beads)** (`bd`) — required, install one of:
  ```bash
  # npm
  npm install -g @beads/bd

  # Homebrew
  brew install beads

  # Go
  go install github.com/steveyegge/beads/cmd/bd@latest

  # Or via install script
  curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
  ```

- **Pencil MCP** (optional) — only needed for UI projects. Install Pencil desktop app and connect MCP server.

### Verify Installation

Start a new Claude Code session. Cflow will automatically check Beads, display task state, and suggest next action.

### Updating

```bash
/plugin update cf
```

## Usage

### Workflow

```
cf:brainstorm → cf:design (optional) → cf:plan → cf:implement/cf:sdd → cf:review → cf:finish
```

| Phase | Skill | What it does |
|-------|-------|-------------|
| Brainstorm | `/cf:brainstorm` | Clarify ideas, create spec, generate Beads epic + tasks |
| Design | `/cf:design` | Create wireframes with Pencil MCP (optional, UI only) |
| Plan | `/cf:plan` | Create implementation plan, Beads subtasks + dependencies |
| Implement | `/cf:implement` | Sequential execution with review checkpoints |
| Implement | `/cf:sdd` | Subagent-driven: 1 agent per task + 2-stage review |
| Review | `/cf:review` | Code review (max 3 rounds) |
| Finish | `/cf:finish` | Merge/PR + mark epic done |

### All Skills

| Skill | Description |
|-------|-------------|
| `cf:start` | Session init — check Beads, show task state, route to skills |
| `cf:brainstorm` | Brainstorm + spec creation |
| `cf:design` | Pencil MCP design phase — wireframe, review, `.pen` files |
| `cf:plan` | Implementation planning |
| `cf:implement` | Execute plan sequentially |
| `cf:sdd` | Subagent-driven development |
| `cf:tdd` | Test-driven development |
| `cf:debug` | Systematic debugging |
| `cf:review` | Request code review |
| `cf:receive-review` | Receive and act on review feedback |
| `cf:verify` | Verification before completion |
| `cf:dispatch` | Dispatch parallel agents |
| `cf:worktree` | Git worktree isolation |
| `cf:finish` | Finish development branch |
| `cf:pause` | Pause task — save context to Beads |
| `cf:resume` | Resume paused task |
| `cf:bug` | Bug reporting with priority rules |
| `cf:status` | Project overview — progress, bugs, blockers |
| `cf:write-skill` | Create/edit skills |

## License

MIT — fork from [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent.
