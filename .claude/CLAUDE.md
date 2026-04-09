# Marketplace — Project Conventions

This is a Claude Code plugin marketplace. Each plugin is a self-contained directory under `plugins/agents/` or `plugins/skills/`.

---

## Plugin Structure

Every plugin must have:

```
plugins/<type>/<plugin-name>/
  .claude-plugin/plugin.json      # plugin manifest
  agents/<name>.md                # agent definition (agents only)
  skills/<name>/SKILL.md          # skill definition (skills only)
```

The directory name, `plugin.json` `name` field, and frontmatter `name` field must all match exactly (kebab-case).

---

## plugin.json

Required fields — all must be present:

```json
{
  "name": "plugin-name",
  "description": "One or two sentence description. What it does and when to use it.",
  "version": "1.0.0",
  "author": { "name": "sona-is" }
}
```

- `version` uses semver. Increment on every published change.
- `description` must match the corresponding entry in `.claude-plugin/marketplace.json`.

---

## Agent Frontmatter

Required fields for every agent `.md` file:

```yaml
---
name: plugin-name
description: >
  One paragraph. What the agent does, when it triggers, what it produces.

  Trigger phrases:
  - "phrase one"
  - "phrase two"

  <example>
  Context: ...
  user: "..."
  assistant: "..."
  <commentary>...</commentary>
  </example>

model: opus          # or inherit
color: blue          # any supported colour
tools: ["Bash", "Read", "Grep", "Glob"]   # minimum necessary — no extras
---
```

- Include at least 2–3 `<example>` blocks covering distinct trigger scenarios.
- `tools` list must be the minimum required — do not include tools the agent doesn't use.
- `model: opus` for agents doing multi-step reasoning or code changes. `model: inherit` for lightweight read-only agents.

---

## Skill Frontmatter

Required fields for every skill `SKILL.md` file:

```yaml
---
name: skill-name
description: One sentence. Trigger context and what it does.
---
```

---

## Agent System Prompt Conventions

### Shell discipline

Each `Bash` tool call is a separate shell process — variables do not persist between calls. Every bash block must re-derive any variables it needs within that block.

For data passed between phases, use session-scoped temp file paths (not fixed `/tmp/shared_name.txt`). Derive a stable, unique path from available context:

```bash
# In PR mode — use PR number
DIFF_FILE="/tmp/review_pr${PR_NUMBER}_diff.txt"

# In local mode — use branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null | tr '/' '-' | tr -cd 'a-zA-Z0-9-')
DIFF_FILE="/tmp/review_${BRANCH}_diff.txt"
```

### Phase structure

Complex agents use numbered phases (Phase 0, Phase 1, …). Each phase is self-contained — it re-derives context from git or environment rather than relying on variables from previous phases.

### Confidence scoring

When agents produce findings or assessments, use a 0–100 confidence scale. Only surface findings at ≥ 80. Discard the rest — quality over quantity.

---

## Marketplace Registration

Every plugin must have a matching entry in `.claude-plugin/marketplace.json` under `plugins[]`. The `name`, `source`, `description`, `version`, and `author` fields must match `plugin.json`.

---

## What We Don't Do

- No backwards-compatibility shims, removed-code comments, or re-exports for deleted items.
- No features added beyond what was explicitly requested.
- No auto-commits — only commit when explicitly asked.
- No force-pushes to main.
