# Global Agent Instructions

You are running inside an isolated Docker container. Key constraints:

- **Ephemeral**: only `/home/node/app/` is shared with the host. Everything outside that directory is lost when the container exits.
- **Non-root**: you run as the `node` user. `sudo` is not available.
- **Available tools**: `git`, `curl`, `nano`, `make`, `zip`, `unzip`, `less`, `gh`, `jq`, Node.js/npm, and the Rust toolchain (`cargo`, `rustup`, `clippy`, `rustfmt`, `rust-analyzer`).
- **Missing tools**: if a tool you need is not in the list above, do not attempt to install it at runtime — it will not persist. Instead, propose adding it to `base/Dockerfile` (for shared tools) or the agent-specific `Dockerfile`, and ask the user to confirm and rebuild the image before continuing.
