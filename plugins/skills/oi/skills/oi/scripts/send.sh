#!/usr/bin/env bash
set -euo pipefail

FROM="${1:?Usage: send.sh <from> <to> <message>}"
TO="${2:?Usage: send.sh <from> <to> <message>}"
MSG="${3:?Usage: send.sh <from> <to> <message>}"

TARGET_DIR="/tmp/oi/${TO}"
SENDER_DIR="/tmp/oi/${FROM}"

if [ ! -d "${TARGET_DIR}" ]; then
  echo "Error: session '${TO}' is not registered. Ask them to run: /oi register ${TO}" >&2
  exit 1
fi

TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf '{"from":"%s","to":"%s","msg":"%s","ts":"%s"}\n' "${FROM}" "${TO}" "${MSG}" "${TS}" >> "${TARGET_DIR}/inbox.jsonl"

date -u +%Y-%m-%dT%H:%M:%SZ > "${SENDER_DIR}/.heartbeat"

echo "Message sent to '${TO}'."
