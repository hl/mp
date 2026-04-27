---
name: brainstorm-approach
description: Question cadence for structured discovery. Load when a brief is ambiguous and a spec needs to be written.
---

# Brainstorm Approach

Used by the `spec` agent when the brief is fuzzy and a spec cannot be written without more
context. Defines the question order, the conversation rules, and the threshold for "enough
information to write a spec."

Without this, discovery degrades in predictable ways: too many questions at once, questions
about the solution before the problem is understood, or moving to spec writing while open
questions still exist.

---

## Question order

Ask in this order. Each question is asked only after the previous answer is clear.

1. **What is the problem being solved?** Not the solution. Not the feature. The situation or
   pain that motivates the work.
2. **Who encounters this problem and when?** The actor and the trigger. A problem nobody hits
   does not need solving.
3. **What does success look like from their perspective?** Observable outcomes from the actor's
   point of view. Not implementation milestones.
4. **What are the constraints?** Technical, time, scope. What must be true. What cannot change.
5. **What are the edge cases or failure modes worth anticipating?** Not exhaustive — the ones
   the user already knows about or is worried about.

---

## Rules for the conversation

- **Ask one question at a time.** Batching questions forces the user to context-switch and
  produces shallower answers. One question, one answer, then the next.
- **Do not suggest solutions during discovery.** The goal is to understand the problem fully.
  Solutions during discovery anchor the conversation to whatever was suggested first, even
  when the suggestion is poor.
- **Do not proceed to spec writing until all five areas have a clear answer.** A clear answer
  means the user has stated the answer themselves — not nodded along to your interpretation.
- **If a later answer reveals an earlier one needs revisiting, do so before continuing.**
  Discovery is not strictly linear. A constraint discovered at step 4 can change what success
  means at step 3. Loop back, confirm the revision, then continue.

---

## Threshold for "enough information"

All four conditions must hold before writing the spec:

1. **The problem is clearly stated and the user has confirmed your statement of it.**
2. **Success is defined in observable terms** — not "it should work well" but "the user can
   do X without Y."
3. **At least the primary constraints are known** — the ones that would shape the solution
   space, not every minor preference.
4. **No open question remains that would force a major assumption during implementation.**

If any condition fails, ask the next question. Do not paper over a gap with an assumption —
record it as an open question in the spec instead, and decide with the user whether to
resolve it now or defer.
