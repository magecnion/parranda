# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Parranda builds and runs isolated Docker environments for AI agent CLIs. The core philosophy is **isolation mode**: agents run inside containers where only `/home/node/app/` is mounted from the host, ensuring safety and reproducibility.

Image hierarchy:
```
node:23-slim → agent-base (base/Dockerfile) → claudecode or opencode
```

## Build Commands

Run from the repository root. Build `base` first — both agent images depend on it.

```sh
make base
make claudecode
make opencode
```

- `opencode` always busts cache to pull `opencode-ai@latest`.
- There is no repo-level package manager workflow; Docker is the only build system.

## Run Commands

```sh
./claudecode/run.sh /path/to/project
./opencode/run.sh /path/to/project
```

Both scripts resolve the target path with `realpath`, create required host-side state directories, then run `docker run -it --rm` with the project mounted at `/home/node/app/` and limits of `--memory=4g --cpus=2`.

Persistent state defaults:
- Claude Code: `claudecode/node/.claude/` and `claudecode/node/.claude.json`
- OpenCode: `opencode/node/.local/` and `opencode/node/.config/opencode/`

Override with `CLAUDECODE_HOME_DIR` or `OPENCODE_HOME_DIR`.

## Validation

There is no automated test suite, linter, or formatter config in this repo. Validate changes with the narrowest applicable check:

```sh
bash -n claudecode/run.sh        # shell syntax check
bash -n opencode/run.sh
docker build --progress=plain -t agent-base -f base/Dockerfile base
docker build --progress=plain -t claudecode -f claudecode/Dockerfile claudecode
docker build --build-arg CACHE_BUST=$(date +%s) --progress=plain -t opencode -f opencode/Dockerfile opencode
```

Do not invent `make lint` or test commands that don't exist.

## Code Conventions

**Shell scripts**: `#!/bin/bash`, quote variable expansions, use `$(...)` not backticks, validate required args early with `exit 1`, use `exec` for the final long-running process, keep env defaults explicit with `${VAR:-default}`.

**Dockerfiles**: single-stage, minimal. Shared tools go only in `base/Dockerfile`; agent-specific installs go in the agent's Dockerfile. Always remove apt lists after install. Preserve the non-root `node` user.

**Dependencies**: add new CLI tools to `base/Dockerfile`; add agent-specific npm packages to the relevant agent Dockerfile. Do not install tools at runtime inside scripts.
