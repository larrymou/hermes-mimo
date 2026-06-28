# hermes-mimo

MiMo Code skill for [Hermes Agent](https://github.com/NousResearch/hermes-agent) — orchestrate [Xiaomi MiMo Code](https://github.com/XiaomiMiMo/MiMo-Code) as a coding subagent.

## What This Does

Lets Hermes delegate coding tasks to MiMo Code, Xiaomi's terminal-native AI coding assistant with persistent memory, compose workflows, and parallel execution.

## Quick Start

### Install the Skill

```bash
# Copy to Hermes skills directory
cp -r skills/mimo-code ~/.hermes/skills/

# Or use Hermes CLI
hermes skills install https://raw.githubusercontent.com/larrymou/hermes-mimo/main/skills/mimo-code/SKILL.md
```

### Prerequisites

```bash
# Install MiMo Code
npm install -g @mimo-ai/cli
# Or: curl -fsSL https://mimo.xiaomi.com/install | bash

# First launch guides auth setup
mimo
```

### Usage

**One-shot task (preferred):**
```
terminal(command="mimo run 'Add error handling to API calls'", workdir="~/project")
```

**Interactive session:**
```
terminal(command="mimo", workdir="~/project", background=true, pty=true)
```

**Parallel tasks:**
```
terminal(command="mimo run 'Fix issue #101'", workdir="/tmp/issue-101", background=true)
terminal(command="mimo run 'Add tests for #102'", workdir="/tmp/issue-102", background=true)
```

## Files

| File | Description |
|------|-------------|
| `skills/mimo-code/SKILL.md` | Full orchestration guide (420+ lines) |
| `docs/compose/specs/2026-06-28-mimo-code-skill-design.md` | Design specification |
| `tests/*.sh` | Test scripts for all orchestration patterns |

## Testing

```bash
./tests/run-all-tests.sh
```

## License

MIT
