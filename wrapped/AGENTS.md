# Global Agent Instructions

- Prefer simple solutions
- Tell me something I need to know even if I don't want to hear it
- When using customize-opencode skill also look at official documentation to ensure the answer using provided context7 mcp
- Context efficiency. When writing or editing agent-facing documentation (skills, instructions, references), use the minimum text needed for correct action. State each rule once, keep it in the document responsible for it, and rely on existing context rather than repeating it. Remove redundant explanations, examples, and implementation details. Preserve necessary constraints and actionable specifics.
- Create Git worktrees only in `$PROJECT_ROOT/.worktrees/<name>`.

## Sanboxed environment

You are running in a sandboxed environment. Sandboxed environment is created via ./run.sh

### Constraints

- If a folder you need is not binded in the sandboxed environment, do not attempt to access it. Instead, propose adding and I will consider.
- If a tool you need is not binded in the sandboxed environment, do not attempt to install it. Instead, propose installing it and I will consider.
