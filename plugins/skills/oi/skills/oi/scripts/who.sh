#!/usr/bin/env bash
set -euo pipefail

OI_DIR="/tmp/oi"

if [ ! -d "${OI_DIR}" ] || [ -z "$(ls -A "${OI_DIR}" 2>/dev/null)" ]; then
  echo "No sessions registered."
  exit 0
fi

NOW="$(date -u +%s)"

echo "--- Registered Sessions ---"
for dir in "${OI_DIR}"/*/; do
  [ -d "${dir}" ] || continue
  NAME="$(basename "${dir}")"
  HB_FILE="${dir}.heartbeat"

  if [ -f "${HB_FILE}" ]; then
    HB="$(cat "${HB_FILE}")"
    HB_EPOCH="$(date -u -j -f '%Y-%m-%dT%H:%M:%SZ' "${HB}" '+%s' 2>/dev/null || echo 0)"
    AGE=$(( NOW - HB_EPOCH ))

    if [ "${AGE}" -gt 300 ]; then
      STATUS="stale (${AGE}s ago)"
    else
      STATUS="active (${AGE}s ago)"
    fi
  else
    STATUS="unknown"
  fi

  INBOX="${dir}inbox.jsonl"
  if [ -s "${INBOX}" ]; then
    COUNT="$(wc -l < "${INBOX}" | tr -d ' ')"
    echo "  ${NAME}  — ${STATUS}, ${COUNT} pending message(s)"
  else
    echo "  ${NAME}  — ${STATUS}"
  fi
done
echo "---"
