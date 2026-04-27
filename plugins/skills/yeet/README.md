# Yeet

Spec-driven workflow plugin for Claude Code. Brainstorm, write specs, review
implementations, and compound learnings — all designed for full agent autonomy.

Built on the Compound Engineering principle: **each unit of work should make the next one
easier, not harder.** The first three steps produce a feature; the fourth produces a system
that builds features better next time.

## Quick start

```
First time on a project:   /yeet:init           # bootstrap (idempotent)
Per feature (the loop):    /yeet:spec → /yeet:spec-review → /plan → /yeet:review → /yeet:compound
Maintenance, occasional:   /yeet:refresh <scope>
```

## Flow

The per-feature loop with status transitions:

```
/yeet:spec          → docs/specs/<feature>.md                              (status: draft)
/yeet:spec-review   → validates the spec                                   (status: ready)
/plan               → Claude native (plans + executes)
/yeet:review        → checks implementation vs spec, findings → /plan      (status: in-progress)
/yeet:compound      → docs/solutions/<category>/<feature>-<date>.md        (status: done)
```

The `/plan ↔ /yeet:review` cycle repeats until `/yeet:review` returns no outstanding
findings, then `/yeet:compound` writes the learning.

## Commands

| Command | What it does |
|---|---|
| `/yeet:init` | One-time setup. Creates `docs/specs/` and `docs/solutions/`, teaches `CLAUDE.md` about the workflow. Idempotent. |
| `/yeet:spec` | Brainstorms (if fuzzy) and writes a spec. Skips if the work doesn't warrant one. |
| `/yeet:spec-review` | Validates a spec for falsifiable criteria, scope, and open questions. |
| `/yeet:review` | Checks the current implementation against the spec. Returns findings. |
| `/yeet:compound` | Captures, makes findable, updates the system, verifies the learning. Writes to `docs/solutions/<category>/`. |
| `/yeet:refresh` | Maintenance. Reviews stale entries in `docs/solutions/` against the current codebase and proposes targeted updates. Requires a scope. |

## Structure

```
yeet/
├── .claude-plugin/plugin.json
├── skills/
│   ├── spec-template/SKILL.md       # canonical spec format
│   └── brainstorm-approach/SKILL.md # discovery question cadence
├── agents/
│   ├── init.md                      # one-time project bootstrap
│   ├── spec.md                      # decides + writes specs
│   ├── spec-review.md               # validates specs
│   ├── review.md                    # checks implementation vs spec
│   ├── compound.md                  # extracts reusable insight
│   └── refresh.md                   # maintains the knowledge store
└── commands/
    ├── init.md
    ├── spec.md
    ├── spec-review.md
    ├── review.md
    ├── compound.md
    └── refresh.md
```

Commands are thin wrappers — they delegate to the matching agent via the Agent tool.

## Project layout this plugin assumes

```
your-project/
├── CLAUDE.md                                # /yeet:compound updates this for discoverability
└── docs/
    ├── specs/                                # one spec per feature, written by /yeet:spec
    └── solutions/
        ├── architecture-patterns/
        ├── design-patterns/
        ├── conventions/
        ├── tooling-decisions/
        ├── workflow-issues/
        ├── best-practices/
        ├── runtime-errors/
        ├── performance-issues/
        └── ... (other category dirs)
```

Directories are created on demand. Solution docs are classified into a knowledge track
(features, patterns, conventions) or bug track (defects, root-cause fixes), and filed under
the matching category.

## How `/yeet:compound` works

Compound is the fourth move of the per-feature loop and runs four internal moves:

1. **Capture** (parallel) — dispatches three `Explore` sub-agents in parallel: a journey
   extractor (spec + spec history + branch commits), a code extractor (changed files,
   patterns, decisions), and an overlap scanner (existing docs in `docs/solutions/`).
   Compound assembles the results, then classifies the track and category. Pulls from
   the *journey*, not just the final state: requirements added mid-flight, review-driven
   revisions, rejected alternatives.
2. **Make findable** — writes to `docs/solutions/<category>/<slug>-<date>.md` with
   frontmatter (`title`, `date`, `track`, `category`, `tags`, `spec`, optional `module`).
   Detects overlap with existing docs (high → updates the existing doc with
   `last_updated:`; moderate → notes the overlap; low → creates fresh).
3. **Update the system** — if `CLAUDE.md`/`AGENTS.md` doesn't surface `docs/solutions/`,
   adds a single-line mention. If the work revealed a project-level convention, proposes
   it to the user (no auto-apply on this one).
4. **Verify** — articulates the queries a future agent would run when hitting this
   problem and confirms the doc's tags and title would surface for those queries.

## How `/yeet:refresh` works

Refresh is maintenance, not part of the feature loop. Always runs against a narrow scope
(category, module, tag, or a single doc path). Refuses to scan the whole knowledge store
at once.

- **Single-doc scope** runs serially — four staleness checks (file references, code
  patterns, supersession, convention drift) on the one doc.
- **Multi-doc scope** dispatches one `Explore` sub-agent per doc in parallel; each runs
  the four checks on its assigned doc and returns findings.
- The orchestrator collects all findings, presents proposals (update / supersede /
  consolidate / no action) for approval, then applies approved changes sequentially —
  parallel writes are unsafe.

Run when you suspect docs in a particular area have drifted (after a refactor, a
dependency upgrade, or a convention change).

## Design principles

- **Optimise for the next agent session.** Every output should leave the codebase in a state
  that makes the next agent run easier.
- **Complement strong specs.** Agents assume a well-formed spec exists; they don't compensate
  for a weak one.
- **Minimal surface area.** Every agent and skill must pass the test: would an agent do
  something meaningfully worse without it?

## Installation

```
/plugin install yeet@hl-mp
```
