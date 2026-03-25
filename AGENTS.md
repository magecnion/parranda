# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) and OpenCode when working with code in this repository.

## Overview

**Parranda** is a collection of Dockerized AI agent environments (Claude Code, OpenCode) that run in isolation mode for safety and reproducibility. Each agent gets its own Docker image built on a shared base image, with persistent state stored on the host and target projects mounted at runtime.

## Build Commands

All build commands run from the project root:

```sh
# Build the shared base image (must be built first)
make base

# Build the Claude Code image
make claudecode

# Build the OpenCode image (always force-rebuilds to get latest opencode)
make opencode
```

The `opencode` target passes `--build-arg CACHE_BUST=$(date +%s)` to always pull the latest `opencode-ai` npm package.

## Running Agents

Each agent has a `run.sh` script that wraps `docker run` with the correct volume mounts:

```sh
# Run Claude Code on a project
./claudecode/run.sh /path/to/project

# Run OpenCode on a project
./opencode/run.sh /path/to/project
```

Both scripts accept an optional env var to override where persistent state is stored on the host:
- `CLAUDECODE_HOME_DIR` (default: `./claudecode/node`)
- `OPENCODE_HOME_DIR` (default: `./opencode/node`)

## Architecture

### Image Hierarchy

```
base/Dockerfile       → agent-base image
                           node:23-slim + git, curl, nano, make, gh + Rust toolchain
                      ↓
claudecode/Dockerfile → claudecode image (installs @anthropic-ai/claude-code via npm, CMD: claude)
opencode/Dockerfile   → opencode image   (installs opencode-ai, CMD: opencode)
```

### Volume Mounts at Runtime

Each container mounts:
- The target project → `/home/node/app/` inside the container
- Agent-specific config/state dirs from the host `node/` subdirectory → the agent's home dirs inside the container

Agent configuration and conversation history persist across container runs via these mounts; the container process itself is ephemeral.

### Global Agent Instruction Files

Each agent expects a global instruction file at:
- `claudecode/node/.claude/CLAUDE.md`
- `opencode/node/.config/opencode/AGENTS.md`

These are loaded by the agent for every project it works on, regardless of the project's own config files.

**When any Dockerfile is modified**, also update this file (`AGENTS.md`) if any section references the changed behaviour (e.g. the image hierarchy diagram, installation method, or tools list). Additionally, if tools are added or removed in `base/Dockerfile`, update the tools list in the global instruction files above.

### Resource Limits

Both containers run with `--memory=4g --cpus=2`.

### Persistent State Locations (host-side)

| Agent | Host path | Mounted to (in container) |
|---|---|---|
| claudecode | `claudecode/node/.claude/` | `/home/node/.claude/` |
| claudecode | `claudecode/node/.claude.json` | `/home/node/.claude.json` |
| opencode | `opencode/node/.local/share/opencode/` | `/home/node/.local/share/opencode/` |
| opencode | `opencode/node/.local/state/opencode/` | `/home/node/.local/state/opencode/` |
| opencode | `opencode/node/.config/opencode/` | `/home/node/.config/opencode/` |
