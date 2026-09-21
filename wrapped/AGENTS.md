# Global Agent Instructions

- Prefer simple solutions
- Tell me something I need to know even if I don't want to hear it
- When using customize-opencode skill also look at official documentation to ensure the answer using provided context7 mcp
- Every time you don't have permissions tell me which permissions configuration is needed to add to the opencode.jsonc in order to have the permission to perform the action. Be as granular as possible. I want to avoid wildcarded permissions.

## Sanboxed environment

You are running in a sandboxed environment. Sandboxed environment is created via ./run.sh

### Constraints

- If a folder you need is not binded in the sandboxed environment, do not attempt to access it. Instead, propose adding and I will consider.
- If a tool you need is not binded in the sandboxed environment, do not attempt to install it. Instead, propose installing it and I will consider.
