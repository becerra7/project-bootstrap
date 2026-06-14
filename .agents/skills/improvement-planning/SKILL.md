---
name: improvement-planning
description: >-
  Turn detected features + audit findings into a prioritised, sequenced
  improvement roadmap for an existing project. Use when the user asks "what
  should we improve / fix / build next", wants a roadmap or backlog, or wants to
  prioritise tech-debt vs features. Produces docs/ROADMAP.md where each item is
  sized (agent-does vs human-must-do) and routed to the command that executes it
  (/cleanup, /iterate-feature, /add-feature, /onboard, /setup-infra).
paths:
  - "docs/**"
---

# Improvement planning — from findings to an ordered, executable roadmap

Convert what's *true about the code now* (detected features + audit findings)
into what to do next, in order, with each item ready to hand to a command. The
output isn't a wish list — it's a sequenced plan where every line maps to a
concrete next action and is honest about who has to do it.

## Inputs (read first, don't re-derive)

1. `docs/STATE.md` — features, stack, infra (from `project-adoption`).
2. `docs/AUDIT.md` — severity-ranked findings (from `code-audit`).
3. The user's goal, if any ("ship faster", "harden security", "reduce churn").
   Absent a goal, optimise for **risk-down then leverage-up**: stop the bleeding,
   then enable speed.

If an input is missing, run that step first (`/adopt-project` or `/audit`) rather
than planning on guesses.

## Build the roadmap

For each candidate improvement, capture:

- **What & why** — one line of outcome, not implementation.
- **Type** — `fix` (P0/P1 from audit) · `cleanup` (safe debt) · `iterate`
  (change an existing feature) · `feature` (new capability) · `infra` (CI, envs,
  secrets, managed-service adoption).
- **Value vs effort** — rough size (S/M/L) and the impact, so trade-offs are
  visible.
- **Risk / dependencies** — what must come first; what it might break.
- **Agent-does vs human-must-do** — split per the prime directive; surface the
  human steps as their own ordered checklist, never buried.
- **Route** — the command that executes it: `/cleanup`, `/iterate-feature`,
  `/add-feature`, `/onboard`/`/setup-infra`, or a `product-architect` scoping pass
  for anything L/architectural.

## Prioritise (and be opinionated)

Order by **risk reduction first, then value/effort leverage**:

1. **P0/P1 audit findings** (security, data-loss, broken build) — non-negotiable,
   first.
2. **Cheap high-leverage cleanups** that unblock everything else (green CI,
   formatter, dead-code removal).
3. **Feature/iteration work** ranked by value ÷ effort against the stated goal.
4. **Nice-to-haves** explicitly parked, so the line between now and later is clear.

Recommend a focused **next 1–2 weeks** slice rather than an undifferentiated
backlog. Don't pad the list — a short, sequenced plan beats an exhaustive one.

## Output: `docs/ROADMAP.md`

A dated, ordered plan:

- **Now (this slice):** the ordered items with type, size, route, and the
  human-only checklist for the slice.
- **Next:** the following wave, lighter detail.
- **Later / parked:** named but deferred, with the reason.
- **Dependencies & risks** noted inline.

Each "Now" item should be runnable by stating its route command. Keep
`docs/STATE.md` linking the roadmap, and re-plan after a slice ships (the roadmap
is living, like the rest of the docs — `project-docs`).

## Guardrails

- Plan against the **recorded** state, not assumptions; if code and docs disagree,
  fix the docs first (`code wins`).
- Every item must route to a command/owner — no orphan "we should..." lines.
- Separate agent-does from human-must-do on every item; keep the human list short
  and ordered.

Pairs with: `code-audit` (findings in), `codebase-cleanup` + `feature-lifecycle`
(execution out), `project-adoption` (runs this as the final recommended step),
`product-architect` (scopes large items), `project-docs`, `conventions`.
