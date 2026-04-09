# Oi

Inter-session messaging for Claude Code. Send and receive messages between independent sessions using filesystem mailboxes.

## Usage

```
/oi register <name>       Register this session
/oi send <target> <msg>   Send a message to another session
/oi check                 Read and clear your inbox
/oi who                   List all registered sessions
```

## Example

**Session A:**
```
/oi register alpha
```

**Session B:**
```
/oi register bravo
/oi send alpha oi mate, auth module is done
```

**Session A:**
```
/oi check
# => [2026-04-09T14:34:27Z] bravo: oi mate, auth module is done
```

## How it works

Each session gets a mailbox directory at `/tmp/oi/<name>/` with a `inbox.jsonl` file and a `.heartbeat` timestamp. Messages are JSON lines appended to the target's inbox. Reading clears the inbox.

Mailboxes live in `/tmp` — they're ephemeral by design and cleared on reboot.
