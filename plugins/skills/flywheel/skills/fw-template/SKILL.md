---
name: fw-template
description: Canonical spec format for agent-driven development. Load when writing or reading a spec.
---

# Spec Template

Defines the canonical spec format used across the spec-driven workflow. Every spec produced
by the `fw-draft` agent uses this structure. Every spec read by `fw-validate`,
`fw-review`, and `fw-compound` relies on it.

The reader of every spec is an LLM agent. Precision over readability.

---

## Filename

`docs/specs/<kebab-case-feature-name>.md`

The slug must describe the feature, not the change type. Use `csv-export-invoices`, not
`add-csv-export` or `feature-export`.

---

## Required fields

A spec has two parts: **YAML frontmatter** at the top (between `---` lines), holding
`title` and `status`; and **body sections** below it, holding `context`, `goals`,
`acceptance criteria`, `out of scope`, and `open questions`.

Every spec contains all of these. Omit nothing — if a body section has no content, say so
explicitly (e.g. "Out of scope: none.") so a reader knows the omission was deliberate.

### `title` (frontmatter)

The feature name. Matches the slug, expanded for human reading.

### `status` (frontmatter)

One of:
- `draft` — written, not yet validated
- `ready` — passed `fw-validate`, ready for implementation
- `in-progress` — implementation underway
- `done` — all acceptance criteria satisfied; `fw-compound` has been run

Lifecycle setters:
- `fw-draft` sets this to `draft` on creation.
- `fw-validate` advances `draft → ready` when checks pass.
- `fw-review` advances `ready → in-progress` on its first run, signalling that
  implementation has started.
- `fw-compound` advances `in-progress → done` (or `ready → done` if `fw-compound` runs
  without a prior `fw-review`).

`in-progress` is also how `fw-review` and `fw-compound` find the active spec when the
branch name does not match a spec slug.

### Agent-managed review metadata (frontmatter)

`fw-review` writes the following keys after each run. They are how `fw-compound` decides
whether the implementation has changed since the last clean review. Treat them as
agent-managed: do not hand-edit, and preserve them when editing other parts of the
frontmatter.

- `last_review_status` — `clean` or `findings`.
- `last_reviewed_at` — `YYYY-MM-DD` of the last review run.
- `last_review_base` — the merge-base commit-ish used as the diff range origin.
- `last_review_head` — the HEAD SHA at review time.
- `last_review_worktree` — `clean` or `dirty` at review time.
- `last_review_diff_hash` — SHA-256 of the canonical evidence inputs (committed, staged,
  unstaged, and untracked content), produced by `scripts/review-evidence-hash.sh`.

`fw-compound` reads these and refuses to compound when they are absent or when the recorded
hash no longer matches the current worktree.

### `context`

What exists today, what problem this solves, what the boundaries are. Written so an agent with
no prior knowledge of this feature understands why it exists. One to three short paragraphs.

Do not restate the request. Do not describe the solution. Describe the situation that makes
the work worth doing.

### `goals`

What success looks like, expressed as observable outcomes. Not implementation choices. Not
internal mechanics. The reader of `goals` should be able to tell whether the feature is useful
without reading any code.

### `acceptance criteria`

A numbered list of specific, verifiable conditions an agent can check.

Rules — every criterion must satisfy all of these:
- **Falsifiable.** A criterion that cannot be falsified is not a criterion.
- **Observable.** Written from the perspective of behaviour visible at the system boundary —
  what a user, caller, or test sees. Not internal state.
- **Single outcome.** One criterion, one verifiable thing. Split compound criteria.
- **Implementation-agnostic.** A reader must not need to read the implementation to know
  whether a criterion is satisfied.

Forbidden words in criteria: `handles`, `supports`, `manages`, `properly`, `correctly`,
`appropriately`. These hide the actual condition. Replace with the specific observable thing
that proves the behaviour.

Bad: "The system handles invalid input."
Good: "Submitting a request with a missing `email` field returns HTTP 400 with body
`{ "error": "email required" }`."

Bad: "The export supports large datasets."
Good: "Exporting a 100k-row dataset completes in under 30 seconds and produces a single CSV
file containing every row."

### `out of scope`

An explicit list of things this spec does not cover. Anything an agent might reasonably
include but should not. Prevents scope creep during implementation.

If nothing is plausibly in-scope-adjacent, write: "Out of scope: none."

### `open questions`

Anything unresolved that could force an assumption during implementation.

If empty, write: "Open questions: none."

`fw-validate` will not promote the spec to `ready` while open questions remain unless
the user explicitly overrides.

---

## Where constraints go

The spec has no dedicated `constraints` section. Constraints distribute across the existing
sections based on shape:

- **Testable / quantitative** (e.g. "completes in under 30 seconds", "no new dependencies",
  "returns 403 for non-admins") → an **acceptance criterion**. If you can write a check for
  it, it belongs there.
- **Negative / boundary** (e.g. "no Excel export", "no scheduled jobs") → **out of scope**.
- **Descriptive / situational** (e.g. "must integrate with existing auth middleware",
  "must work with the current Postgres schema without migrations") → **context**, framed as
  what already exists that the work has to fit into.

If a constraint won't fit any of these, it's usually too vague to be useful — sharpen it
into a falsifiable statement and it becomes an acceptance criterion.

---

## Example

```markdown
---
title: CSV export for invoices
status: draft
---

## Context

The invoice list view in the admin panel currently has no export. Finance has been screen-scraping
the table into spreadsheets, which breaks every time the columns change. They need a stable export
they can drop into their existing reporting workflow.

The data already exists in the `invoices` table; nothing new needs to be modelled.

## Goals

- Finance can export the current invoice list as a CSV file from the admin UI without engineering
  involvement.
- The export reflects the same filters and sort order the user has applied in the UI.
- The export file is stable enough to be referenced from finance's downstream spreadsheets — column
  order and names do not change without an explicit version bump.

## Acceptance criteria

1. The invoice list view displays an "Export CSV" button visible only to authenticated admins.
2. Clicking the button while the list shows N filtered invoices produces a CSV file containing
   exactly those N rows, in the same order shown in the UI.
3. The CSV includes a header row with these exact column names, in this order:
   `id, issued_at, customer_email, amount_cents, currency, status`.
4. Exporting a result set of 100,000 invoices completes in under 30 seconds on the production
   database and produces a single CSV file.
5. A non-admin user accessing the export endpoint directly receives HTTP 403.
6. No new dependencies are added to `package.json`.

## Out of scope

- Excel (.xlsx) export.
- Scheduled or recurring exports.
- Customising the column set per user.

## Open questions

- None.
```

---

## What does not go in a spec

- Implementation details — function names, file paths, library choices.
- Restatements of the request.
- Justification for why the work matters beyond the `context` section.
- Anything an agent can correctly infer from existing docs or conventions.
