---
name: oi
description: >
  INVOKE THIS SKILL when the user asks to "oi", "send message to another session",
  "check messages", "register session", "who is online", "inter-session messaging",
  or wants to communicate between Claude Code sessions.
argument-hint: "<register|send|check|who> [args]"
---

# Oi — Inter-Session Messaging

Send and receive messages between independent Claude Code sessions using filesystem mailboxes.

## Commands

Parse the user's input to determine which subcommand to run. The scripts are located at `${CLAUDE_PLUGIN_ROOT}/skills/oi/scripts/`.

### register <name>

Register this session with a name. Run:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/oi/scripts/register.sh" "<name>"
```

After registering, remember your session name for all future `send` and `check` calls. You MUST register before sending or checking messages.

### send <target> <message>

Send a message to another session. You must be registered first. Run:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/oi/scripts/send.sh" "<your-name>" "<target>" "<message>"
```

### check

Check your inbox for new messages. Run:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/oi/scripts/check.sh" "<your-name>"
```

Messages are cleared after reading. Report each message to the user with the sender and timestamp.

### who

List all registered sessions and their status. Run:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/oi/scripts/who.sh"
```

## Behavior

- If the user says `/oi` with no arguments, show a brief usage summary.
- If the user hasn't registered yet and tries to send or check, remind them to register first.
- Keep your registered session name in memory for the duration of the conversation.
