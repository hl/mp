---
description: Refresh stale entries in docs/solutions/. Checks references, patterns, and overlap against the current codebase. Requires a scope argument (category, module, tag, or file path).
argument-hint: scope — category name, module name, tag, or path to a specific solution doc
---

Use the Agent tool with `subagent_type: "refresh"` to handle this request. Pass the user's full request to the agent as its prompt.

User request: $ARGUMENTS
