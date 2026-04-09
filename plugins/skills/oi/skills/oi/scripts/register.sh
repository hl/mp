#!/usr/bin/env bash
set -euo pipefail

NAME="${1:?Usage: register.sh <session-name>}"
DIR="/tmp/oi/${NAME}"

mkdir -p "${DIR}"
touch "${DIR}/inbox.jsonl"
date -u +%Y-%m-%dT%H:%M:%SZ > "${DIR}/.heartbeat"

echo "Registered as '${NAME}'. Mailbox ready at ${DIR}/"
