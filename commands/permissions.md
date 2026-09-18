---
description: Generate or update the OpenCode permissions inventory
agent: build
model: openai/gpt-5.6-terra
subtask: false
---

1. Run `opencode agent list` and use its output as the source of truth.
2. Create or replace `.opencode/.permissions.md`. Do not modify any configuration or agent definition files.
3. Include every listed agent, including internal agents.
4. At the beginning of the document, add an index listing every agent with an anchor link to that agent's permissions section.
5. For each agent, preserve the rules exactly in the order received and number them starting from `#01`.
6. OpenCode evaluates rules in order and uses the LAST rule whose permission and pattern both match the concrete input.
7. Resolve precedence using wildcard match-set overlap, not pattern equality or assumed specificity:
   - `*` matches zero or more characters.
   - `?` matches exactly one character.
   - A later rule can override all or only part of an earlier rule's matching inputs.
   - Do not assume two different patterns are disjoint. Determine whether their possible matching inputs overlap.
8. In `Applies`, show:
   - `Full` when the rule is the winning rule for every input matched by its permission and pattern.
   - `Partial` when the rule wins for some matching inputs, but one or more later rules win for other matching inputs.
   - `No` when later rules collectively win for every input the rule could match.
   - These values describe which rule wins, even when overlapping rules have the same `allow`, `ask`, or `deny` action.
9. Strike through an `Action` only when `Applies` is `No`. Do not strike through `Partial` rules.
10. In `Rule`, display `allow`, `ask`, or `deny`.
11. In `Overrides`, reference every earlier rule whose permission and pattern overlap with the current rule, whether the overlap is partial or complete. Use compact ranges where possible, for example `#01–#15`.
12. In `Overridden by`, reference every later rule whose permission and pattern overlap with the current rule, whether the overlap is partial or complete, for example `#16`.
13. Leave override cells empty when there is no overlap relationship.
14. For example, given these ordered rules:
    - `read: *` with `allow`
    - `read: *.env` with `ask`
    - `read: *.env.*` with `ask`
    - `read: *.env.example` with `allow`

    `read: *` is `Partial`, because it still wins for ordinary paths but later rules win for matching environment-file paths. `read: *.env.*` is also `Partial`, because `read: *.env.example` wins for that narrower subset. Evaluate all other overlap relationships using the same wildcard semantics.

15. Add one section per agent showing its mode, followed by this table:

|   # | Applies | Action | Rule | Overrides | Overridden by |
| --: | :-----: | ------ | :--: | --------- | ------------- |

16. In `Action`, show the permission and its pattern, for example `` `bash: git diff *` `` or `` `*: *` ``. Do not include `allow`, `ask`, or `deny` in this column.
17. Keep the document concise: do not copy the original JSON or add explanations beyond the title, agent index, section headings, modes, and tables.
18. Write the entire generated document in English.

Restrictions:

- Use only the output of `opencode agent list` as the source of truth.
- Do not search for, read, or inspect other permission-related files.
- Do not access `.opencode/` except to create or replace the permitted output files.
- Only create or replace `.opencode/.permissions` and `.opencode/.permissions.md`.
