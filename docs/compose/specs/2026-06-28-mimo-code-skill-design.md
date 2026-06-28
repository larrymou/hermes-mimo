# MiMo Code Skill Design Spec

## [S1] Problem

Hermes Agent needs a skill for orchestrating MiMo Code (Xiaomi's terminal-native AI coding assistant) as a coding subagent. The skill should enable Hermes agents to delegate coding tasks to MiMoCode and help end-users configure MiMoCode within the Hermes ecosystem.

## [S2] Solution Overview

Create a standalone comprehensive SKILL.md following the claude-code skill structure. MiMoCode is forked from OpenCode and adds persistent memory, subagent orchestration, compose workflows, voice input, and dream/distill self-improvement. The skill covers both Hermes agent orchestration and end-user setup.

## [S3] Skill Metadata

```yaml
name: mimo-code
description: "Delegate coding to MiMo Code CLI (features, PRs, memory, compose)."
version: 1.0.0
platforms: [linux, macos, windows]
tags: [Coding-Agent, MiMo, Xiaomi, Code-Review, Refactoring, Memory, Compose]
related_skills: [opencode, claude-code, codex]
```

## [S4] Prerequisites

- Install: `npm install -g @mimo-ai/cli` or `curl -fsSL https://mimo.xiaomi.com/install | bash`
- Auth: First launch guides setup (MiMo Auto free tier, OAuth, import from Claude Code, custom provider)
- Verify: `mimo --version`
- Git repository recommended for code tasks
- `pty=true` for interactive TUI sessions

## [S5] One-Shot Tasks (Print Mode)

MiMoCode supports `mimo run` for bounded, non-interactive tasks:

```bash
terminal(command="mimo run 'Add error handling to API calls'", workdir="~/project")
```

With context files: `mimo run 'Review config' -f config.yaml`
With model override: `mimo run 'Refactor auth' --model openrouter/anthropic/claude-sonnet-4`

## [S6] Interactive Sessions

Start TUI in background for iterative work:

```bash
terminal(command="mimo", workdir="~/project", background=true, pty=true)
```

Monitor: `process(action="poll"|"log")`
Send input: `process(action="submit", session_id="<id>", data="...")`
Exit: Ctrl+C (`\x03`) — NOT `/exit`

### TUI Keybindings

| Key | Action |
|-----|--------|
| `Enter` | Submit message |
| `Tab` | Switch between agents (build/plan/compose) |
| `Ctrl+C` | Exit |

## [S7] Agent Modes

| Agent | Description |
|-------|-------------|
| **build** | Default. Full tool permissions for development |
| **plan** | Read-only analysis mode for code exploration |
| **compose** | Orchestration mode for specs-driven development |

Press `Tab` to switch between primary agents.

## [S8] PR Review Workflow

Built-in PR command:
```bash
terminal(command="mimo pr 42", workdir="~/project", pty=true)
```

Clone-based review for isolation:
```bash
terminal(command="REVIEW=$(mktemp -d) && git clone https://github.com/user/repo.git $REVIEW && cd $REVIEW && mimo run 'Review this PR vs main. Report bugs, security risks, test gaps.'", pty=true)
```

## [S9] Parallel Work Pattern

Use separate workdirs/worktrees to avoid collisions:

```bash
terminal(command="mimo run 'Fix issue #101 and commit'", workdir="/tmp/issue-101", background=true, pty=true)
terminal(command="mimo run 'Add parser tests and commit'", workdir="/tmp/issue-102", background=true, pty=true)
process(action="list")
```

## [S10] Persistent Memory

MiMoCode maintains cross-session memory via SQLite FTS5:

- **MEMORY.md** — project knowledge, rules, architecture decisions
- **checkpoint.md** — structured state snapshots (auto-maintained by checkpoint-writer)
- **notes.md** — temporary agent scratchpad
- **tasks/<id>/progress.md** — per-task logs

Memory is auto-injected when session resumes. Agents can search memory with `memory` tool.

## [S11] Compose Mode

Compose mode provides structured workflows for specs-driven development:

- **Plan**: `compose:plan` — create implementation plans
- **TDD**: `compose:tdd` — test-driven development
- **Debug**: `compose:debug` — structured debugging
- **Review**: `compose:review` — code review
- **Merge**: `compose:merge` — integration decisions
- **Verify**: `compose:verify` — completion verification
- **Brainstorm**: `compose:brainstorm` — design exploration
- **Execute**: `compose:execute` — plan execution with checkpoints

Switch to compose agent with `Tab`, then invoke skills.

## [S12] Voice Input

Real-time streaming voice input:

```bash
/voice    # Activate voice mode
```

Requires `sox` (`brew install sox` on macOS).
WSLg: `sudo apt install -y sox pulseaudio libasound2-plugins`

## [S13] Dream & Distill

- **`/dream`** — extracts persistent knowledge from session traces into project memory
- **`/distill`** — packages repeated workflows into reusable skills, subagents, or commands

## [S14] Configuration

Config location: `.mimocode/mimocode.json` (project) or `~/.config/mimocode/mimocode.json` (global)

Key sections:
- `provider` — API provider configuration
- `model` — model selection
- `permission` — tool permissions and external directory access
- `checkpoint` — checkpoint behavior
- `memory` — memory system settings
- `voice` — voice input configuration
- `experimental.maxMode` — parallel best-of-N reasoning

## [S15] Rules

1. Always use `pty=true` for interactive TUI sessions
2. Use `mimo run` for one-shot automation — simpler, no pty needed
3. Exit interactive sessions with Ctrl+C (`\x03`), never `/exit`
4. Scope sessions to single repo/workdir
5. Memory is auto-injected on session resume
6. Use `Tab` to switch to compose agent for specs-driven workflows
7. Monitor long tasks with `process(action="poll"|"log")`
8. Report concrete outcomes (files changed, tests, remaining risks)

## [S16] Pitfalls

1. `/exit` is NOT a valid command — it opens agent selector. Use Ctrl+C.
2. Interactive sessions require `pty=true`
3. `mimo run` does NOT need pty
4. PATH mismatch can select wrong binary
5. Enter may need to be pressed twice in TUI (once to finalize, once to send)
6. Memory files are auto-loaded — don't manually manage them
7. Compose mode requires switching to compose agent via Tab
