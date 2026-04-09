# Plugin Types

## Skills

Skills are markdown files that give Claude specialized instructions for specific tasks. Claude auto-invokes skills when the user's request matches the skill's description, or users can invoke them manually with a slash command.

### Structure

```
plugins/skills/your-skill/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── your-skill/
        └── SKILL.md
```

### SKILL.md Format

```markdown
---
name: your-skill
description: >
  When to invoke this skill. Claude uses this description to decide
  whether to auto-invoke the skill based on the user's request.
---

# Skill Name

Brief description of what this skill does.

## Instructions

Detailed instructions for Claude on how to behave when this skill is invoked.
Include:
- What the skill should accomplish
- How to interact with the user
- Any constraints or guidelines
```

### Installation

```
/plugin install your-skill@hl-mp
```

---

## MCP Servers

MCP (Model Context Protocol) servers extend Claude's capabilities by providing custom tools and resources. They communicate with Claude Code via stdio using the MCP protocol.

### Structure

```
plugins/mcp-servers/your-mcp/
├── .claude-plugin/
│   └── plugin.json
├── package.json
└── src/
    └── index.ts
```

### Basic MCP Server

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "your-mcp",
  version: "1.0.0",
});

// Register a tool
server.tool(
  "tool_name",
  "Tool description",
  {
    param: {
      type: "string",
      description: "Parameter description",
    },
  },
  async ({ param }) => {
    return {
      content: [{ type: "text", text: `Result: ${param}` }],
    };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
```

### Installation

```
/plugin install your-mcp@hl-mp
```

---

## Hooks

Hooks are scripts that run in response to Claude Code events. They can observe, log, or modify behavior.

### Structure

```
plugins/hooks/your-hook/
├── .claude-plugin/
│   └── plugin.json
└── hook.sh
```

### Hook Events

| Event | Description | Input Schema |
|-------|-------------|--------------|
| `PreToolUse` | Before tool execution | `{ tool_name: string, tool_input: object }` |
| `PostToolUse` | After tool execution | `{ tool_name: string, tool_input: object, tool_output: string }` |
| `Notification` | On notifications | `{ message: string, level: string }` |
| `Stop` | Session end | `{ reason: string }` |

### Hook Script

Hooks receive JSON on stdin. They can:
- Exit 0 to allow the action
- Exit non-zero to block (for Pre* events)
- Output JSON to stdout to modify behavior

```bash
#!/bin/bash
# Read input
INPUT=$(cat)

# Process
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
echo "Tool used: $TOOL" >> ~/.claude/hook.log

# Exit 0 to allow
exit 0
```

### Installation

```
/plugin install your-hook@hl-mp
```
