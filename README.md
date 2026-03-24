# Parranda

`Parranda` is a repository that hosts various agents and agent-related tools, such as skills.
The core philosophy of this project is to run agents in **isolation mode** to ensure safety and reproducibility.

This approach was inspired by community discussions on running OpenCode in isolated environments:
[Reddit Comment](https://www.reddit.com/r/opencodeCLI/comments/1qbtyql/comment/nzd7mmt/)

Inspired by the Canary Islands tradition of people gathering to create music together. This repository is a parranda of AI agents and tools collaborating toward shared tasks.

## opencode

Dockerized environment for `opencode` with persistent state for Opencode and related tools that it needs (like Rust)

### Build
Run from the project root:
```sh
# Build image
docker build -t opencode opencode
# Update opencode (force rebuild)
docker build --build-arg CACHE_BUST=$(date +%s) -t opencode opencode
```

### Run

Use the helper script to generate the `docker run` command with necessary volume mounts.

**Arguments**:
- `path/to/project`: The project directory to work on.
- `OPENCODE_HOME_DIR` (Optional): Host directory for persistent state (defaults to `./opencode/node`).

**Examples**:

```sh
# Generate command
./opencode/print_docker_run.sh /path/to/project
# Run directly
$(./opencode/print_docker_run.sh /path/to/project)
# Run with custom state directory
OPENCODE_HOME_DIR=/tmp/state ./opencode/print_docker_run.sh /path/to/project
```
