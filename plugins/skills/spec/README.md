# spec

Spec-driven development for Claude Code. Collaboratively write testable specifications, review them for gaps and contradictions, then implement them with tests-first incremental builds.

## Skills

### write-spec

Collaboratively draft a technical specification for a component or feature. Asks clarifying questions, identifies gaps, and produces a structured spec file in `docs/specs/`.

The skill enforces single-responsibility specs — if a request spans multiple independent concerns, it splits them into separate spec files. When a research doc exists in `docs/research/`, it uses that as the foundation instead of re-exploring the codebase.

```
> write a spec for the notification system
> spec out the CSV export feature
> update the user-registration spec with the new validation rules
```

### implement-spec

Autonomously implements a spec from `docs/specs/`. Works tests-first: writes a failing test for each requirement, then implements until it passes, committing atomically along the way.

Before writing code, it establishes a test baseline, checks dependency specs are implemented, and familiarises itself with the surrounding codebase. Decisions made during implementation are recorded back into the spec's Decisions section.

```
> implement the spec in docs/specs/notification-system.md
> implement-spec user-registration
```

### review-spec

Reviews all specs in `docs/specs/` for missing schemas, contradictions between files, and internal inconsistencies. Runs dual parallel reviews (Claude sub-agents + Codex), consolidates findings, and applies fixes autonomously for up to 4 rounds.

Only surfaces issues that would block or break implementation — no style nits, hypothetical edge cases, or feature suggestions.

```
> review the specs
> review specs in docs/specs/
```

## Spec Lifecycle

1. **Draft** — Use `write-spec` to define what needs to be built.
2. **Approved** — User reviews and approves the spec.
3. **Implementing** — `implement-spec` builds it, tests-first.
4. **Done** — All acceptance criteria pass, spec status updated.

Use `review-spec` at any point to catch cross-spec issues before implementation.
