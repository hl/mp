# Plugin Schema Reference

Complete reference for `.claude-plugin/plugin.json`.

## Schema

All plugins use the same `plugin.json` schema:

```json
{
  "name": "plugin-name",
  "description": "What the plugin does",
  "version": "1.0.0",
  "author": {
    "name": "Author Name"
  }
}
```

## Field Reference

### `name` (required)
- Unique identifier for the plugin
- Lowercase letters, numbers, and hyphens only
- Must match the directory name

### `description` (required)
- Brief description of functionality

### `version` (required)
- Semantic version (MAJOR.MINOR.PATCH)
- Follow [semver](https://semver.org/) conventions

### `author` (required)
- `name`: Author's name or organization
