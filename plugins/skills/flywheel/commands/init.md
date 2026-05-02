---
description: One-time setup. Creates docs/specs/ and docs/solutions/, and teaches CLAUDE.md (or AGENTS.md) about the spec-driven workflow so future agents know to use it. Idempotent.
---

Use the Agent tool with `subagent_type: "fw-init"` to handle this request. Pass the user's full request to the agent as its prompt.

User request: $ARGUMENTS
