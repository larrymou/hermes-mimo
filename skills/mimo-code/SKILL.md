---
name: mimo-code
description: "Delegate coding to MiMo Code CLI (features, PRs, memory, compose)."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Coding-Agent, MiMo, Xiaomi, Code-Review, Refactoring, Memory, Compose, PTY, Automation]
    related_skills: [opencode, claude-code, codex]
---

# MiMo Code — Hermes Orchestration Guide

Delegate coding tasks to [MiMo Code](https://github.com/XiaomiMiMo/MiMo-Code) (Xiaomi's terminal-native AI coding assistant) via the Hermes terminal. MiMo Code is built as a fork of OpenCode with persistent memory, intelligent context management, subagent orchestration, compose workflows, voice input, and dream/distill self-improvement.

## Prerequisites

- **Install:** `npm install -g @mimo-ai/cli` or `curl -fsSL https://mimo.xiaomi.com/install | bash`
- **Auth:** Run `mimo` — first launch guides setup:
  - **MiMo Auto** — free tier, zero configuration
  - **Xiaomi MiMo Platform** — OAuth login
  - **Import from Claude Code** — migrate existing auth
  - **Custom Provider** — any OpenAI-compatible API
- **Verify:** `mimo --version`
- **Health check:** `mimo debug`
- **Git repository** recommended for code tasks
- **`pty=true`** required for interactive TUI sessions

## Two Orchestration Modes

### Mode 1: Print Mode (`mimo run`) — Non-Interactive (PREFERRED for most tasks)

Print mode runs a one-shot task, returns the result, and exits. No PTY needed. This is the cleanest integration path.

```
terminal(command="mimo run 'Add error handling to all API calls in src/' --model openrouter/xiaomi/mimo-v2.5", workdir="/path/to/project", timeout=120)
```

**When to use print mode:**
- One-shot coding tasks (fix a bug, add a feature, refactor)
- CI/CD automation and scripting
- Any task where you don't need multi-turn conversation

**Attach context files with `-f`:**
```
terminal(command="mimo run 'Review this config for security issues' -f config.yaml -f .env.example", workdir="/project", timeout=60)
```

**Force a specific model:**
```
terminal(command="mimo run 'Refactor auth module' --model openrouter/anthropic/claude-sonnet-4", workdir="/project", timeout=120)
```

**Set working directory with `--dir`:**
```
terminal(command="mimo run 'Fix the bug' --dir /path/to/project", timeout=60)
```

**Show model thinking:**
```
terminal(command="mimo run 'Debug why tests fail in CI' --thinking", workdir="/project", timeout=120)
```

**Set reasoning effort with `--variant`:**
```
terminal(command="mimo run 'Analyze this complex system' --variant high", workdir="/project", timeout=120)
```

### Mode 2: Interactive PTY via tmux — Multi-Turn Sessions

Interactive mode gives you a full conversational REPL with agents (build/plan/compose), memory, and real-time tool usage. **Requires tmux orchestration.**

```
# Start a tmux session
terminal(command="tmux new-session -d -s mimo-work -x 140 -y 40")

# Launch MiMo Code inside it
terminal(command="tmux send-keys -t mimo-work 'cd /path/to/project && mimo' Enter")

# Wait for startup, then send your task
terminal(command="sleep 5 && tmux send-keys -t mimo-work 'Refactor the auth module to use JWT tokens' Enter")

# Monitor progress by capturing the pane
terminal(command="sleep 15 && tmux capture-pane -t mimo-work -p -S -50")

# Send follow-up tasks
terminal(command="sleep 2 && tmux send-keys -t mimo-work 'Now add unit tests for the new JWT code' Enter")

# Exit when done (Ctrl+C, NOT /exit)
terminal(command="tmux send-keys -t mimo-work C-c")
```

**When to use interactive mode:**
- Multi-turn iterative work (refactor → review → fix → test cycle)
- Tasks requiring human-in-the-loop decisions
- Exploratory coding sessions
- When you need to switch between agents (build/plan/compose)

## Agent Modes

MiMo Code has three primary agents. Press `Tab` in the TUI to switch between them.

| Agent | Description | Use when |
|-------|-------------|----------|
| **build** | Default. Full tool permissions for development | Writing code, fixing bugs, running commands |
| **plan** | Read-only analysis mode | Code exploration, solution design, architecture review |
| **compose** | Orchestration mode for specs-driven workflows | Planning, TDD, debugging, review, merge decisions |

### Switching Agents

In interactive mode, press `Tab` to cycle between agents. The current agent is shown in the status bar.

For print mode, you can specify the agent:
```
terminal(command="mimo run --agent plan 'Analyze the architecture of src/'", workdir="/project", timeout=60)
```

## CLI Reference

### Core Commands

| Command | Purpose |
|---------|---------|
| `mimo` | Start interactive TUI |
| `mimo "query"` | Start TUI with initial prompt |
| `mimo run "query"` | Print mode (non-interactive, exits when done) |
| `mimo run --agent plan "query"` | Print mode with specific agent |
| `mimo -c` | Continue the most recent conversation |
| `mimo -s <session-id>` | Resume a specific session |
| `mimo debug` | Run debugging tools |
| `mimo --version` | Show version |

### Session Management

| Command | Purpose |
|---------|---------|
| `mimo session list` | List past sessions |
| `mimo session delete <id>` | Delete a session |
| `mimo export [sessionID]` | Export session data as JSON |
| `mimo import <file>` | Import session data from JSON |
| `mimo stats` | Token usage and costs |
| `mimo stats --days 7` | Usage for specific period |

### Model & Provider

| Command | Purpose |
|---------|---------|
| `mimo providers list` | List configured providers |
| `mimo providers login` | Authenticate with provider |
| `mimo models` | List available models |

### Common Flags

| Flag | Effect |
|------|--------|
| `run "prompt"` | One-shot execution and exit |
| `--continue` / `-c` | Continue the last session |
| `--session <id>` / `-s` | Resume a specific session |
| `--agent <name>` | Choose agent (build, plan, compose) |
| `--model provider/model` | Force specific model |
| `--file <path>` / `-f` | Attach file(s) to the message |
| `--dir <path>` | Set working directory |
| `--title <name>` | Name the session |
| `--thinking` | Show model thinking blocks |
| `--variant <level>` | Reasoning effort (high, max, minimal) |
| `--format json` | Raw JSON events output |
| `--attach <url>` | Attach to a running mimocode server |
| `--dangerously-skip-permissions` | Auto-approve permissions (dangerous) |

## Persistent Memory

MiMo Code maintains cross-session memory automatically. When a session resumes, memory is injected into context.

### Memory Files

| File | Purpose |
|------|---------|
| `MEMORY.md` | Project knowledge, rules, architecture decisions |
| `checkpoint.md` | Structured state snapshots (auto-maintained) |
| `notes.md` | Temporary agent scratchpad |
| `tasks/<id>/progress.md` | Per-task logs |

### Memory Commands

| Command | Purpose |
|---------|---------|
| `/goal` | Set a stopping condition — judge model evaluates completion |
| `/dream` | Extract persistent knowledge from session traces |
| `/distill` | Package repeated workflows into reusable skills |

Memory is managed by the agent automatically. Don't manually edit memory files unless you're adding explicit project rules.

### Subagent System

The primary agent can create subagents on demand:

- **Parallel execution** — subagents share session context and run concurrently
- **Lifecycle tracking** — monitor subagent status and progress
- **Cancellation** — stop subagents that are no longer needed
- **Background execution** — subagents run independently of the main conversation

## Compose Mode

Compose mode provides structured workflows for specs-driven development. Switch to the compose agent with `Tab`, then invoke skills.

### Built-in Skills

| Skill | Purpose |
|-------|---------|
| `compose:plan` | Create implementation plans from specs |
| `compose:tdd` | Test-driven development workflow |
| `compose:debug` | Structured debugging |
| `compose:review` | Code review |
| `compose:merge` | Integration decisions |
| `compose:verify` | Completion verification |
| `compose:brainstorm` | Design exploration |
| `compose:execute` | Plan execution with checkpoints |
| `compose:report` | Final-state report after implementation |

### Using Compose Skills

In interactive mode, switch to compose agent and invoke skills naturally:
```
Tab  (switch to compose agent)
Use compose:plan to create an implementation plan for the auth module
```

In print mode:
```
terminal(command="mimo run --agent compose 'Use compose:plan to create an implementation plan for adding OAuth support'", workdir="/project", timeout=120)
```

## Voice Input

Real-time streaming voice input powered by MiMo ASR.

### Activation

In interactive mode:
```
/voice    # Toggle voice mode
```

### Requirements

- **macOS:** `brew install sox`
- **Linux:** `sudo apt install sox`
- **WSLg:** `sudo apt install -y sox pulseaudio libasound2-plugins && export PULSE_SERVER=unix:/mnt/wgl/PulseServer`

### Voice Providers

| Provider | ASR | Voice Control | Free? |
|----------|-----|---------------|-------|
| MiMo Platform | mimo-v2.5-asr | mimo-v2.5 | Yes (logged in) |
| OpenRouter | — | openrouter/xiaomi/mimo-v2.5 | Paid |
| Custom relay | config-dependent | config-dependent | Varies |

### Configuration

Voice can be configured in `.mimocode/mimocode.json`:
```json
{
  "voice": {
    "asr_model": "mimo-v2.5-asr",
    "control_model": "openrouter/xiaomi/mimo-v2.5"
  }
}
```

## PR Review Workflow

### Quick Review (Print Mode)

```
terminal(command="cd /path/to/repo && git diff main...feature-branch > /tmp/review.diff && mimo run 'Review this diff for bugs, security issues, and style problems.' -f /tmp/review.diff --agent plan", timeout=60)
```

### Built-in PR Command

```
terminal(command="mimo pr 42", workdir="~/project", pty=true)
```

### Clone-Based Review (Isolated)

```
terminal(command="REVIEW=$(mktemp -d) && git clone https://github.com/user/repo.git $REVIEW && cd $REVIEW && mimo run 'Review this PR vs main. Check for bugs, security issues, race conditions, and missing tests.' --agent plan", timeout=120)
```

## Parallel Work Pattern

Use separate workdirs or worktrees to avoid file collisions:

```
# Task 1: Fix backend
terminal(command="mimo run 'Fix the auth bug in src/auth.py'", workdir="/tmp/issue-101", background=true)

# Task 2: Write tests
terminal(command="mimo run 'Write integration tests for the API endpoints'", workdir="/tmp/issue-102", background=true)

# Task 3: Update docs
terminal(command="mimo run 'Update README.md with the new API endpoints'", workdir="/tmp/issue-103", background=true)

# Monitor all
process(action="list")
```

### With Git Worktrees

```
# Create worktrees
terminal(command="git worktree add -b fix/issue-78 /tmp/issue-78 main", workdir="~/project")
terminal(command="git worktree add -b fix/issue-99 /tmp/issue-99 main", workdir="~/project")

# Launch MiMo Code in each
terminal(command="mimo run 'Fix issue #78: <description>. Commit when done.'", workdir="/tmp/issue-78", background=true)
terminal(command="mimo run 'Fix issue #99: <description>. Commit when done.'", workdir="/tmp/issue-99", background=true)

# After completion, push and create PRs
terminal(command="cd /tmp/issue-78 && git push -u origin fix/issue-78")
terminal(command="gh pr create --repo user/repo --head fix/issue-78 --title 'fix: ...' --body '...'")

# Cleanup
terminal(command="git worktree remove /tmp/issue-78", workdir="~/project")
```

## Configuration

### Config Locations

| Scope | Path |
|-------|------|
| Project | `.mimocode/mimocode.json` |
| Global | `~/.config/mimocode/mimocode.json` |

### Key Configuration Sections

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "mimo": {
      "options": {
        "apiKey": "your-api-key"
      }
    }
  },
  "model": "mimo/mimo-v2.5",
  "permission": {
    "external_directory": {
      "/tmp/**": "allow"
    }
  },
  "checkpoint": {
    "enabled": true
  },
  "memory": {
    "enabled": true
  },
  "voice": {
    "asr_model": "mimo-v2.5-asr",
    "control_model": "mimo-v2.5"
  },
  "experimental": {
    "maxMode": false
  }
}
```

### Provider Options

| Provider | Auth Method | Env Var |
|----------|-------------|---------|
| MiMo Auto | Free tier | None |
| Xiaomi MiMo Platform | OAuth | `mimo providers login` |
| Import from Claude Code | Migration | `mimo providers login` |
| Custom Provider | API key | Config file |
| OpenRouter | API key | `OPENROUTER_API_KEY` |

## Environment Variables

| Variable | Effect |
|----------|--------|
| `MIMO_API_KEY` | API key for MiMo provider |
| `OPENROUTER_API_KEY` | API key for OpenRouter |
| `ANTHROPIC_API_KEY` | Import from Claude Code |
| `OPENAI_API_KEY` | Custom OpenAI-compatible provider |

## Troubleshooting

### MiMo Code won't start
1. Check `mimo --version` — ensure installed
2. Run `mimo debug` — check dependencies and config
3. Verify auth: `mimo providers list`

### Tool not available
1. Check permissions in `.mimocode/mimocode.json`
2. Some tools need specific providers configured
3. Restart session after config changes

### Memory not loading
1. Check if `.mimocode/` directory exists in project
2. Memory is auto-created on first session
3. Use `/dream` to manually trigger knowledge extraction

### Voice not working
1. Install `sox`: `brew install sox` (macOS) or `sudo apt install sox` (Linux)
2. Check voice config in `mimocode.json`
3. For WSLg, ensure PulseAudio is configured

### Compose mode not responding
1. Ensure you've switched to compose agent with `Tab`
2. Skills are invoked naturally — just describe what you want
3. Check `/help` for available commands

### Goal not stopping
1. Use `/goal` to set a clear stopping condition
2. The judge model evaluates independently — be specific in your goal
3. Check `/goal status` to see current goal state

### Changes not taking effect
- **Config changes:** Restart the session
- **Tool changes:** Start a new session
- **Code changes:** Restart CLI or gateway process

## Rules for Hermes Agents

1. **Prefer `mimo run` for single tasks** — cleaner, no dialog handling, structured output
2. **Use tmux for multi-turn interactive work** — the only reliable way to orchestrate the TUI
3. **Always set `workdir`** — keep MiMo Code focused on the right project directory
4. **Set `--agent` in print mode** — use `plan` for analysis, `build` for coding, `compose` for orchestration
5. **Monitor tmux sessions** — use `tmux capture-pane -t <session> -p -S -50` to check progress
6. **Exit interactive with Ctrl+C** — NOT `/exit` which opens agent selector
7. **Clean up tmux sessions** — kill them when done to avoid resource leaks
8. **Report results to user** — after completion, summarize what changed
9. **Don't kill slow sessions** — MiMo Code may be doing multi-step work; check progress first
10. **Use `-f` for context** — attach relevant files instead of having MiMo Code read everything
11. **Memory is automatic** — don't manually manage MEMORY.md; let the agent handle it
12. **Use compose for complex workflows** — switch to compose agent for specs-driven development

## Pitfalls & Gotchas

1. **`/exit` is NOT a valid command** — it opens an agent selector dialog. Always use Ctrl+C to exit.
2. **Interactive mode REQUIRES `pty=true`** — MiMo Code is a full TUI app. Without PTY, it will hang.
3. **`mimo run` does NOT need pty** — it's non-interactive and exits cleanly.
4. **Enter may need to be pressed twice** — once to finalize text, once to send in the TUI.
5. **PATH mismatch** — shell environments may resolve different binaries. Check `which -a mimo` if behavior differs.
6. **Memory files are auto-loaded** — don't manually edit them unless adding explicit rules.
7. **Compose mode requires Tab switching** — you must switch to compose agent before invoking skills.
8. **`--format json` shows raw events** — useful for debugging but adds output volume.
9. **Session resumption requires same directory** — `-c` finds the most recent session for the current working directory.
10. **Background tmux sessions persist** — always clean up with `tmux kill-session -t <name>` when done.
