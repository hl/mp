# Contributing

## Adding a New Plugin

### 1. Choose the Plugin Type

| Type | Directory | Use Case |
|------|-----------|----------|
| skill | `plugins/skills/` | Slash commands that provide Claude with specialized instructions |
| mcp-server | `plugins/mcp-servers/` | Custom tools and resources via Model Context Protocol |
| hook | `plugins/hooks/` | Scripts that run on Claude Code events |

### 2. Create the Plugin Directory

```bash
mkdir -p plugins/<type>/<your-plugin-name>
```

### 3. Add `.claude-plugin/plugin.json`

Every plugin requires a `.claude-plugin/plugin.json`:

```json
{
  "name": "your-plugin-name",
  "description": "Brief description of what the plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

### 4. Add Plugin Files

#### For Skills

```
plugins/skills/your-skill/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── your-skill/
        └── SKILL.md
```

The `SKILL.md` should contain:
- YAML frontmatter with `name` and `description` (description drives auto-invocation)
- Instructions for Claude on how to behave when the skill is invoked
- Examples of usage

#### For MCP Servers

```
plugins/mcp-servers/your-mcp/
├── .claude-plugin/
│   └── plugin.json
├── package.json
├── tsconfig.json (optional)
└── src/
    └── index.ts
```

#### For Hooks

```
plugins/hooks/your-hook/
├── .claude-plugin/
│   └── plugin.json
└── hook.sh (or any executable)
```

### 5. Update the Registry

```bash
npm run build:registry
```

### 6. Test Your Plugin

- For skills: Copy skill directory to `~/.claude/skills/` and verify auto-invocation
- For MCP servers: Add to settings and verify tools appear
- For hooks: Add to settings and verify the hook fires

### 7. Submit a Pull Request

Include:
- Description of what the plugin does
- Any dependencies or requirements
- Testing steps

## Plugin Schema

### `plugin.json` Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Unique identifier (lowercase, hyphens only) |
| `description` | yes | Brief description of functionality |
| `version` | yes | Semver version (MAJOR.MINOR.PATCH) |
| `author` | yes | Object with `name` field |
| `author.name` | yes | Author name or organization |

## Hook Events

| Event | Description | Input |
|-------|-------------|-------|
| `PreToolUse` | Before a tool is executed | `{ tool_name, tool_input }` |
| `PostToolUse` | After a tool is executed | `{ tool_name, tool_input, tool_output }` |
| `Notification` | On notifications | `{ message, level }` |
| `Stop` | When Claude stops | `{ reason }` |

Hooks receive JSON on stdin and can output JSON to stdout.

## Guidelines

- Use clear, descriptive names
- Keep descriptions concise but informative
- Follow semantic versioning
- Test before submitting
- Include any necessary documentation in the plugin directory
