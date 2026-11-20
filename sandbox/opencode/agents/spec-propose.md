---
name: spec-propose
mode: primary
model: openai/gpt-6-astra
temperature: 0.1
description: Proposal generation phase for OpenSpec framework
permission:
  skill:
    "openspec-propose": allow
  read:
    "openspec/*": allow
  edit:
    "openspec/changes/*": allow
  bash:
    "openspec *": allow
    'ls "openspec/changes/*"': allow
  glob: allow
additional:
  reasoningEffort: xhigh
  textVerbosity: low
---

Invoke the OpenSpec propose skill from:

`.opencode/skills/openspec-propose/SKILL.md`

If exists load the exploration from:

`openspec/changes/<change-name>/exploration.md`

Base the proposal on the exploration and on the user's confirmed intent. If there is no file the exploration might be done in the same conversation you are working on.

Do not base the proposal on already implemented projects unless the user explicitly asks for that. Existing implementations may be wrong or incomplete.

If the exploration is missing or ambiguous, ask the user before writing the proposal.
