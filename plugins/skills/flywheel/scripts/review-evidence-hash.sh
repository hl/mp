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
#   4. for each untracked file (locale-stable sort): a header line,
#      Git-relevant metadata, and file contents or symlink target.
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
  git ls-files --others --exclude-standard -z | LC_ALL=C sort -z | while IFS= read -r -d '' f; do
    printf '\n--- untracked: %s ---\n' "$f"
    if [ -L "$f" ]; then
      printf 'mode: 120000\n'
      printf 'link: %s\n' "$(readlink "$f")"
    elif [ -f "$f" ]; then
      if [ -x "$f" ]; then
        printf 'mode: 100755\n'
      else
        printf 'mode: 100644\n'
      fi
      printf 'content:\n'
      cat "$f"
    else
      printf 'mode: other\n'
    fi
  done
} | shasum -a 256 | awk '{print $1}'
