#!/usr/bin/env bash
set -euo pipefail

NAME="${1:?Usage: check.sh <session-name>}"
DIR="/tmp/oi/${NAME}"
INBOX="${DIR}/inbox.jsonl"

if [ ! -d "${DIR}" ]; then
  echo "Error: session '${NAME}' is not registered." >&2
  exit 1
fi

date -u +%Y-%m-%dT%H:%M:%SZ > "${DIR}/.heartbeat"

if [ ! -s "${INBOX}" ]; then
  echo "No new messages."
  exit 0
fi

echo "--- Messages for ${NAME} ---"
while IFS= read -r line; do
  FROM="$(echo "${line}" | sed -n 's/.*"from":"\([^"]*\)".*/\1/p')"
  MSG="$(echo "${line}" | sed -n 's/.*"msg":"\([^"]*\)".*/\1/p')"
  TS="$(echo "${line}" | sed -n 's/.*"ts":"\([^"]*\)".*/\1/p')"
  echo "[${TS}] ${FROM}: ${MSG}"
done < "${INBOX}"
echo "---"

: > "${INBOX}"
