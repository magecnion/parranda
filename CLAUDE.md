# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Parranda is a monorepo for running AI coding agents (Claude Code, OpenCode) in isolated Docker containers. Each agent gets its own image built on a shared base, with persistent state directories mounted from the host.

## Build Commands

All builds use the top-level Makefile from the project root:

```sh
make base          # Build the shared base image (agent-base)
make opencode      # Build OpenCode image (depends on base)
make claudecode    # Build Claude Code image (depends on base)
```

Always rebuild `base` first if you change `base/Dockerfile`, since both agent images inherit from `agent-base`.

## Running Agents

Each agent has a `run.sh` script that generates and executes the `docker run` command:

```sh
./claudecode/run.sh /path/to/project          # Run Claude Code against a project
./opencode/run.sh /path/to/project            # Run OpenCode against a project
CLAUDECODE_HOME_DIR=/custom/dir ./claudecode/run.sh /path/to/project  # Custom state dir
OPENCODE_HOME_DIR=/custom/dir ./opencode/run.sh /path/to/project
```

Containers run with `--memory=4g --cpus=2` limits, as `node` user (non-root, no sudo).

## Architecture

- **`base/`** - Shared Dockerfile: Node.js 23-slim + system tools + Rust toolchain. All agent images extend this.
- **`claudecode/`** - Claude Code agent. Dockerfile installs `@anthropic-ai/claude-code` globally. Persistent state lives in `claudecode/node/.claude/` (mounted to `/home/node/.claude` in container).
- **`opencode/`** - OpenCode agent. Dockerfile installs `opencode-ai` globally. Persistent state split across `.local/share/opencode`, `.local/state/opencode`, and `.config/opencode` (all under `opencode/node/`).
- **`audio/`** - Linux audio debugging toolkit: `collect_diagnostics.sh` gathers MIDI/PipeWire/JACK state on the host for analysis inside a container.

## Key Constraints

- Only `/home/node/app/` is shared with the host; everything else in the container is ephemeral.
- To add a system tool: modify `base/Dockerfile` (shared) or the agent-specific Dockerfile, then rebuild.
- Agent config/state directories (e.g., `claudecode/node/.claude/`, `opencode/node/.config/opencode/`) are committed to the repo for persistence across container runs.
