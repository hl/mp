#!/usr/bin/env bash
# Compute the review evidence hash used by /fw:review and /fw:compound.
#
# Usage: review-evidence-hash.sh <BASE>
# Output: sha256 hex digest on stdout, followed by a newline.
#
# Inputs hashed, in this order:
#   1. git diff <BASE>...HEAD
#   2. git diff --cached
#   3. git diff
#   4. for each untracked file (locale-stable sort): a header line
#      followed by file contents.
#
# The byte-exact format is part of the contract — both /fw:review and
# /fw:compound invoke this script so the digests are directly comparable.

set -euo pipefail

BASE="${1:?usage: review-evidence-hash.sh <BASE>}"

cd "$(git rev-parse --show-toplevel)"

{
  git diff "$BASE"...HEAD
  git diff --cached
  git diff
  git ls-files --others --exclude-standard | LC_ALL=C sort | while IFS= read -r f; do
    printf '\n--- untracked: %s ---\n' "$f"
    if [ -f "$f" ]; then
      cat "$f"
    fi
  done
} | shasum -a 256 | awk '{print $1}'
