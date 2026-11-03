---
description: Build independent alternatives with different models
agent: build
---

Arguments: $ARGUMENTS

Usage: /alternatives <plan-name> <model-1> <model-2> ...

The plan name may be quoted and may include the `.md` suffix. Models use provider/model or
provider/model#variant format. Create one alternative per model argument.

## Preparation

- Identify the Git repository root as `PROJECT_ROOT`, current branch, and exact
  starting commit as `START_COMMIT`.
  Stop if there is no Git repository.
- Accept only a plan name, not a path: reject names containing `/` or `\`,
  and names equal to `.` or `..`.
- Append `.md` unless already present, and resolve the filename directly under
  `$PROJECT_ROOT/plans/`, independent of the current directory.
  Reject any resolved path outside that folder, including symlink targets.
- If the plan is missing, list available Markdown plan names in that folder
  and ask for correction; report if the folder is missing or has no plans.
- Read the resolved plan as the approved scope.
- Validate all model IDs against the available model catalog.
  Ask for correction if arguments are missing or invalid; never substitute models.
- If uncommitted changes exist, ask whether to proceed without them.
  Do not commit, stash, or discard them.

## Execution

1. Create one branch and worktree per alternative,
   all from the exact starting commit, under `$PROJECT_ROOT/.worktrees/`.
   Set `NAME` to `<plan-stem>-<model>`, using the plan filename without `.md`
   and the full requested model reference, including any variant. Replace
   characters outside `[A-Za-z0-9._-]` with `-` so the name is a single path
   component and valid Git branch name. Use this same name for the branch and
   worktree directory; add no date, prefix, suffix, or other words.
   If names collide, or a branch or directory already exists, stop and ask;
   do not reuse, overwrite, or add a uniqueness suffix.
   ```sh
   git -C "$PROJECT_ROOT" worktree add \
     "$PROJECT_ROOT/.worktrees/$NAME" \
     -b "$NAME" "$START_COMMIT"
   ```
   Preserve existing branches and worktrees; do not use the OpenCode worktree
   creation tool, which chooses its own location.
2. Verify every worktree starts at that commit.
3. Launch the general subagent once per alternative, in parallel
   background sessions, passing each requested model through the
   subagent tool's explicit model parameter.
   Record each returned session ID with its requested model and worktree.
4. Give each child the complete plan, assigned model, starting commit,
   branch name, absolute worktree path, and these instructions:
   - Set your session's working directory to the assigned worktree before editing.
   - Follow AGENTS.md. Use this worktree; do not create another.
   - Implement the complete plan independently, within its approved scope.
   - Do not inspect or modify other candidates.
   - Do not merge, push, or remove worktrees.
   - Report your approach, changes, tests and results, and limitations.
5. Keep the coordinator in the original directory.
6. If child delegation, model overrides, or worktree isolation cannot
   be established, report the blocker. Do not silently use a fallback.

## Handoff

Wait for all children to finish, then validate each child's recorded model use:

- Resolve the database path with `opencode debug paths db`. Use Python's
  `sqlite3` to open it with `mode=ro` and `PRAGMA query_only=ON`, then use
  SQLite's backup API to create a consistent, uniquely named snapshot under
  `/tmp/opencode`. Never modify the source or use `immutable=1` on the live database.
- Open the snapshot read-only and inspect its schema; SQLite storage is an
  internal, version-dependent API. Require `session_v2` and `session_message`
  with the columns used below; do not guess a fallback for incompatible schemas.
- Confirm each child exists in `session_v2`. Retrieve every assistant message
  using a bound session-ID parameter:
  ```sql
  SELECT id, data FROM session_message
  WHERE session_id = ? AND type = 'assistant' ORDER BY seq;
  ```
  Parse each `data` value as JSON. Do not limit results or use compacted context.
- Require at least one assistant message. Compare every message's
  `model.providerID` and `model.id` with the requested provider/model; when a
  `#variant` was requested, also require matching `model.variant`.
  Report observed variants even when none was explicitly requested.
- Mark validation FAIL for any mismatch, or UNVERIFIED if metadata is missing,
  unreadable, or incomplete, the child is absent, or database access/schema
  validation fails. Report PASS only when all messages match and none are
  unverified; a known mismatch takes precedence over UNVERIFIED.
  Do not treat the child's self-report or the session's
  current model setting as proof of past model use. Do not silently rerun.

### Usage report

Use the same read-only snapshot to report usage for each alternative:

- Inspect the schema and message metadata for session parent relationships,
  token counts, and recorded cost; do not guess version-dependent fields.
- Include the recorded child session and all its descendants, each session and
  assistant message exactly once. Exclude the coordinator and unrelated sessions.
  If descendants are still running, wait before taking the final snapshot.
- Sum input, output, reasoning, cache-read and cache-write tokens, and recorded
  cost from assistant messages. Keep token categories separate; do not assume
  reasoning or cache tokens are additive to input/output.
- Show one row per alternative with requested model, child session ID, included
  session count, each token category, recorded cost, and completeness status.
  Add combined totals across alternatives without double-counting shared sessions.
- Treat missing, malformed, or unreadable usage or descendant metadata as
  unavailable or partial, never zero. Identify affected metrics and sessions;
  label combined totals partial if any contribution is incomplete.
- Label cost as recorded cost, not actual billing; zero recorded cost does not
  establish free usage. Do not infer prices from model names.
- `opencode-usage` currently reports aggregate usage without a session filter.
  Do not use its project/model totals or before/after differences to attribute
  usage to alternatives, since unrelated concurrent activity may be included.

### Comparison

Compare:

- Requested and observed models/variants, validation status, child session ID,
  branch, and worktree path. Include assistant-message counts, mismatched message
  IDs or verification blockers, and that verification used SQLite metadata,
  not independent evidence of the model actually served by the provider.
- Implementation approach.
- Tests and results.
- Limitations, deviations, or failures.

Leave every alternative available for human review.
Do not choose a winner, merge, push, or delete worktrees.
