# AGENTS.md

Guidance for coding agents working in `/home/node/app`.

## Repository Purpose
`Parranda` hosts Dockerized agent environments. It builds isolated images for agent CLIs and provides wrapper scripts that mount a target project into `/home/node/app` inside the container.
Current top-level structure:
- `base/`: shared `agent-base` image
- `claudecode/`: Claude Code image and launcher
- `opencode/`: OpenCode image and launcher
- `audio/`: diagnostics and skill assets
- `README.md`: high-level usage

## Source Of Truth
When behavior differs, prefer these files in order:
1. `Makefile`
2. `base/Dockerfile`
3. `claudecode/Dockerfile`
4. `opencode/Dockerfile`
5. `claudecode/run.sh`
6. `opencode/run.sh`
7. `README.md`

If you change runtime behavior, update this file too.

## Build Commands
Run from the repository root:
```sh
make base
make claudecode
make opencode
```
Equivalent direct commands:
```sh
docker build --progress=plain -t agent-base -f base/Dockerfile base
docker build --progress=plain -t claudecode -f claudecode/Dockerfile claudecode
docker build --build-arg CACHE_BUST=$(date +%s) --progress=plain -t opencode -f opencode/Dockerfile opencode
```
Notes:
- `make claudecode` and `make opencode` both depend on `make base`.
- `opencode` intentionally busts cache so `opencode-ai@latest` refreshes.
- Docker is the build system; there is no repo-level package manager workflow.

## Run Commands
Use the wrapper scripts to start an agent against another project:
```sh
./claudecode/run.sh /path/to/project
./opencode/run.sh /path/to/project
```
Optional host-side state overrides:
- `CLAUDECODE_HOME_DIR`
- `OPENCODE_HOME_DIR`

Both scripts validate the target path, resolve it with `realpath`, create required state locations, and run `docker run -it --rm` with the target mounted at `/home/node/app/`.

## Lint, Format, And Validation
There is no canonical repo-level lint command today.
There is also no checked-in formatter config, shell linter config, or Docker linter config.
That means:
- there is no `make lint`
- there is no `npm test`, `pytest`, `cargo test`, or `go test` workflow
- agents should not invent project commands that are not defined in the repo

Use the narrowest validation that matches the file you changed:
```sh
bash -n claudecode/run.sh
bash -n opencode/run.sh
docker build --progress=plain -t agent-base -f base/Dockerfile base
docker build --progress=plain -t claudecode -f claudecode/Dockerfile claudecode
docker build --build-arg CACHE_BUST=$(date +%s) --progress=plain -t opencode -f opencode/Dockerfile opencode
```

## Test Commands
There is no automated test suite checked into this repository right now.
Validation is build-oriented and smoke-test oriented.
Recommended verification after edits:
- `base/Dockerfile`: rebuild `agent-base`
- `claudecode/Dockerfile`: rebuild `agent-base`, then `claudecode`
- `opencode/Dockerfile`: rebuild `agent-base`, then `opencode`
- `run.sh` changes: run `bash -n`; if practical, invoke the script with a disposable test path
- docs-only changes: no build required

### Single Test Guidance
There is no single-test command because there are no tracked unit or integration tests.
If tests are added later, update this file with the full-suite command, single-test command, required env vars, and fixture/container setup.

## Code Style Guidelines
The repo is mostly Dockerfiles, shell scripts, and Markdown. Follow existing patterns instead of introducing a new style.

### General Style
- Prefer small, explicit changes.
- Keep files easy to scan.
- Preserve the current directory structure and naming.
- Default to ASCII.
- Avoid adding dependencies unless they are required.
- Update docs whenever behavior changes.

### Naming Conventions
- Use lowercase directory names like `base`, `claudecode`, and `opencode`.
- Use descriptive uppercase shell variables for environment-like values: `SCRIPT_DIR`, `IMAGE_NAME`, `CONFIG_DIR`.
- Keep Make targets short and concrete.
- Keep Docker image tags predictable unless there is a strong reason not to.

### Shell Script Style
- Use `#!/bin/bash`.
- Quote variable expansions unless unquoted behavior is intentional.
- Use `$(...)` instead of backticks.
- Validate required arguments early with a short usage message and `exit 1`.
- Use multiline `docker run` commands for readability.
- Group related directory creation in a single `mkdir -p` block.
- Prefer `exec` for the final long-running process.
- Keep env defaults explicit with `${VAR:-default}`.

### Error Handling
- Fail fast on missing required inputs.
- Print short, actionable errors.
- Avoid broad fallback behavior that hides mistakes.
- Prefer simple conditionals over clever one-liners.
- Add dependency checks for tools like `docker` or `realpath` only when they materially improve failure clarity.

### Dockerfile Style
- Keep images minimal; current Dockerfiles are single-stage.
- Put shared tools only in `base/Dockerfile`.
- Keep agent-specific installs in the agent Dockerfile.
- Use `ARG` only for build-time values.
- Use `ENV` for persistent runtime paths.
- Preserve the non-root `node` user model.
- Remove apt lists after package installation to limit image bloat.

### Imports, Dependencies, And Types
There are no language-level imports or typed application modules in the repo root sources today.
Dependency guidance is therefore Docker- and shell-oriented:
- add shared CLI tools to `base/Dockerfile`
- keep agent-specific npm packages in the relevant agent Dockerfile
- do not install ad hoc tools at runtime in scripts
- do not duplicate dependencies across `base/` and agent images without a reason

### Formatting And Comments
- Preserve existing indentation by file type.
- Keep Markdown headings straightforward and factual.
- Keep comments short and focused on non-obvious intent.
- Prefer documenting why over what.
- Align multiline `docker run` and `mkdir -p` blocks for readability.

## Repository-Specific Notes
- `base/Dockerfile` installs shared local tools and the Rust toolchain.
- `claudecode/Dockerfile` installs `@anthropic-ai/claude-code` globally.
- `opencode/Dockerfile` installs `opencode-ai` globally and supports `OPENCODE_VERSION`.
- Both run scripts mount the target app into `/home/node/app/`.
- Both run scripts constrain containers with `--memory=4g --cpus=2`.

## Existing Editor Rules
Checked for additional editor-specific instructions:
- `.cursor/rules/`: not present
- `.cursorrules`: not present
- `.github/copilot-instructions.md`: not present

There is a local Claude settings file at `.claude/settings.local.json` that allows `WebSearch`, but it is not a Cursor or Copilot rules file.

## When Updating This File
Revise `AGENTS.md` whenever you change build commands, runtime mounts, installed tools, image names or tags, resource limits, validation workflow, or newly added lint/test commands.
