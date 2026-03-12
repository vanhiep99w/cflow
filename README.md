# Cflow

Cflow là bản fork cá nhân của [Superpowers](https://github.com/obra/superpowers), tích hợp sâu hai công cụ:

- **[Beads](https://github.com/hieptran/beads)** (`bd` CLI) — Git-backed task tracker thay thế TodoWrite
- **[Pencil MCP](https://pencil.evolves.dev)** — Công cụ thiết kế UI vector cho wireframe/mockup

Mọi skill đều dùng prefix `cf:*` (viết tắt của cflow).

## Cài đặt

### Claude Code

```bash
# Thêm cflow như một plugin local
cd your-project
claude plugin add /path/to/cflow
```

### Yêu cầu

- **Beads CLI** (`bd`) — cần cài và có trong PATH:
  ```bash
  # Cài beads
  cargo install beads
  # Hoặc từ source
  git clone https://github.com/hieptran/beads && cd beads && cargo install --path .
  ```

- **Pencil MCP** (tùy chọn) — chỉ cần nếu project có UI:
  - Cài Pencil desktop app hoặc IDE extension
  - Kết nối Pencil MCP server

### Xác nhận cài đặt

Mở session mới. Cflow sẽ tự động:
1. Kiểm tra Beads (`bd show`)
2. Hiển thị task state (`bd ready`)
3. Đề xuất hành động tiếp theo

## Workflow cơ bản

```
cf:brainstorm → cf:design (nếu có UI) → cf:plan → cf:implement/cf:sdd → cf:review → cf:finish
```

### Phase 0: Bắt đầu session
Agent tự động chạy `cf:start` → kiểm tra Beads → hiển thị task state → đề xuất hành động.

### Phase 1: Brainstorm
```
/cf:brainstorm
```
- Hỏi clarify ý tưởng, tạo spec document
- Spec review loop (max 5 vòng)
- Sau khi spec approved → tạo Beads epic + tasks
- Detect UI components → hỏi chuyển sang cf:design

### Phase 2: Design (tùy chọn)
```
/cf:design
```
- Chỉ khi project có UI components VÀ Pencil MCP connected
- Tạo wireframe bằng Pencil MCP tools
- User review từng screen → iterate hoặc approve
- Lưu `.pen` files, commit, update Beads

### Phase 3: Plan
```
/cf:plan
```
- Tạo implementation plan chi tiết
- Plan review loop (max 5 vòng)
- Tạo Beads subtasks + dependencies (`bd dep add`)
- Phát hiện cyclic deps → báo lỗi

### Phase 4: Implement
```
/cf:implement    # Thực thi tuần tự với review checkpoints
/cf:sdd          # Subagent-driven: 1 subagent/task + 2-stage review
```
- `bd ready` → pick task → `bd update --claim`
- TDD: test first → implement → verify
- Hoàn thành: `bd update --done` → auto cascade
- Interrupt handling: pause, bug, status, task switch

### Phase 5: Review & Finish
```
/cf:review       # Code review (max 3 vòng)
/cf:finish       # Merge/PR + bd update epic --done
```

## Tất cả cf:* Skills

### Core Workflow (fork từ Superpowers)

| Skill | Mô tả | Thay đổi so với gốc |
|-------|--------|---------------------|
| `cf:brainstorm` | Brainstorm + spec creation | TodoWrite → `bd create epic + tasks` |
| `cf:plan` | Implementation planning | TodoWrite → `bd create subtasks + deps` |
| `cf:implement` | Thực thi plan | TaskList → `bd ready`, TaskUpdate → `bd update` |
| `cf:sdd` | Subagent-driven development | TodoWrite → `bd ready/update`, multi-agent coordination |
| `cf:tdd` | Test-driven development | Track subtask done via `bd update` |
| `cf:debug` | Systematic debugging | Bug tracking integration với Beads |
| `cf:review` | Request code review | Review result → `bd update` done/fail |
| `cf:receive-review` | Receive review feedback | Fix tracking → `bd create subtasks` |
| `cf:finish` | Finish development branch | Beads epic completion check |
| `cf:verify` | Verification before completion | `bd ready/show` verification + 3-attempt limit |
| `cf:dispatch` | Dispatch parallel agents | `bd update --claim` per agent |
| `cf:worktree` | Git worktree isolation | Save branch context to Beads |
| `cf:write-skill` | Create/edit skills | `bd create` for checklist tracking |

### Skills mới (không có trong Superpowers)

| Skill | Mô tả |
|-------|--------|
| `cf:start` | Session init — kiểm tra Beads, hiển thị task state, route to skills |
| `cf:design` | Pencil MCP design phase — wireframe, user review, `.pen` files |
| `cf:pause` | Pause task — save context (branch, file, progress) to Beads, commit WIP |
| `cf:resume` | Resume paused task — restore context, checkout branch, claim task |
| `cf:bug` | Bug reporting — P0 auto-interrupt, P1 ask, P2+ log |
| `cf:status` | Project overview — progress tree, bugs, blockers |

## Beads CLI Commands

Cflow sử dụng các `bd` commands sau:

| Command | Mục đích |
|---------|----------|
| `bd init` | Khởi tạo Beads store trong git repo |
| `bd init --stealth` | Khởi tạo local-only (không commit vào repo) |
| `bd create "<title>" --type <type>` | Tạo task (type: epic, task, subtask, bug) |
| `bd ready` | Liệt kê tasks sẵn sàng (không bị block) |
| `bd show <id>` | Xem chi tiết task |
| `bd update <id> --claim` | Claim task (atomic: set assignee + in_progress) |
| `bd update <id> --done` | Đánh dấu hoàn thành |
| `bd update <id> --status paused` | Pause task |
| `bd update <id> --note "..."` | Thêm ghi chú |
| `bd dep add <child> <parent>` | Thêm dependency |
| `bd link <id> relates_to <id>` | Link tasks |

## Interrupt Handling

Trong khi implement, agent nhận diện các interrupt:

| Trigger | Hành động |
|---------|-----------|
| "dừng lại" / "pause" | → `cf:pause` |
| "có bug" / test regression | → `cf:bug` |
| "tiến độ?" / "status" | → `cf:status` |
| "làm task khác" | → `cf:pause` rồi `bd ready` |

## Bug Priority Rules

| Priority | Phản ứng |
|----------|----------|
| P0 (critical) | Auto pause task hiện tại → `cf:debug` |
| P1 (high) | Hỏi user: fix ngay hay tiếp tục? |
| P2-P3 (medium/low) | Log bug, tiếp tục task hiện tại |

## Multi-Agent Coordination

Khi dùng `cf:sdd` hoặc `cf:dispatch` với nhiều agents:
- **Shared store**: tất cả agents dùng chung Beads store (cùng git repo)
- **Atomic claim**: `bd update --claim` đảm bảo không conflict
- **Conflict handling**: nếu task đã claimed → pick next từ `bd ready`
- **Hash-based IDs**: zero merge conflicts giữa agents

## Project Structure

```
cflow/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── brainstorm/       # cf:brainstorm (forked)
│   ├── plan/             # cf:plan (forked)
│   ├── design/           # cf:design (NEW)
│   ├── implement/        # cf:implement (forked)
│   ├── tdd/              # cf:tdd (forked)
│   ├── debug/            # cf:debug (forked)
│   ├── review/           # cf:review (forked)
│   ├── receive-review/   # cf:receive-review (forked)
│   ├── dispatch/         # cf:dispatch (forked)
│   ├── sdd/              # cf:sdd (forked)
│   ├── worktree/         # cf:worktree (forked)
│   ├── verify/           # cf:verify (forked)
│   ├── finish/           # cf:finish (forked)
│   ├── pause/            # cf:pause (NEW)
│   ├── resume/           # cf:resume (NEW)
│   ├── bug/              # cf:bug (NEW)
│   ├── status/           # cf:status (NEW)
│   ├── start/            # cf:start (NEW)
│   └── write-skill/      # cf:write-skill (forked)
├── agents/
│   └── code-reviewer.md
├── hooks/
│   ├── hooks.json
│   ├── run-hook.cmd
│   └── session-start
└── docs/cflow/
    ├── specs/
    └── plans/
```

## So sánh với Superpowers

| Feature | Superpowers | Cflow |
|---------|------------|-------|
| Task tracking | TodoWrite (session-only) | Beads (git-backed, persistent) |
| Task persistence | Mất khi session kết thúc | Lưu trong git, cross-session |
| Design phase | Không có | cf:design với Pencil MCP |
| Pause/Resume | Không có | cf:pause + cf:resume |
| Bug tracking | Không có | cf:bug với priority rules |
| Project status | Không có | cf:status với progress tree |
| Multi-agent | Có nhưng không atomic | Atomic claim via `bd update --claim` |
| Skill prefix | `superpowers:*` | `cf:*` |

## License

MIT License — fork từ [Superpowers](https://github.com/obra/superpowers) by Jesse Vincent.
