For your setup, I’d implement a small OpenCode plugin that automatically reviews harness edits. A skill alone still depends on the agent remembering to invoke it.

How it would work
Agent edits harness files
↓
Before the next model call, plugin detects changed content
↓
Read-only reviewer checks it against related harness files
↓
Findings are supplied to the agent before it continues

OpenCode V2 provides the necessary APIs:

- ctx.session.hook("context", ...): runs before agent model calls, including after tools.
- ctx.generate.text(...): performs a separate review without tools or another session.

Implementation structure
.opencode/plugins/harness-review/
index.ts # Detection, review call, findings
review.txt # Review criteria only

Detection

- Watch AGENTS.md, skill documents, and instruction references—including extensionless references.
- Compare content hashes between calls; review only when something changes.
- Compare changed files against related, unchanged documents too. Otherwise cross-file duplication goes unnoticed.

Review
Load your existing context-efficiency instruction as the standard rather than copying it into another policy. Ask the reviewer to return:
Finding: duplicated publication procedure
Locations: AGENTS.md:12 and skills/stage-test/SKILL.md:20
Suggested owner: skills/stage-test/SKILL.md
Suggested correction: remove the procedure from AGENTS.md
Require cited passages. Ordinary links to the owning document should not count as duplication.

Delivery
Inject findings into the next agent request. Start report-only: no automatic deletion or blocking. Cache results by content hash to avoid repeated calls and cost. Report reviewer failures as “review unavailable,” never “passed.”
Important limitation
This makes running the check automatic, not fixing every finding guaranteed. Semantic review can still miss duplication. A required CI check would provide stronger enforcement at merge time, but wouldn’t stop the initial edit.
I’d start with this plugin because it catches the problem during our conversation, before committing.
