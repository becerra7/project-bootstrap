# Propose improvements

Turn the detected features + audit findings into a prioritised, sequenced roadmap
where every item routes to the command that executes it.

Use the `improvement-planning` skill:

1. Read `docs/STATE.md` (features/stack/infra) and `docs/AUDIT.md` (findings). If
   either is missing, run `/adopt-project` or `/audit` first — don't plan on
   guesses. Take the user's goal if given; else optimise risk-down then leverage-up.
2. For each candidate, capture what & why, type (`fix`/`cleanup`/`iterate`/
   `feature`/`infra`), value vs effort, risk/dependencies, the agent-does vs
   human-must-do split, and the **route** (`/cleanup`, `/iterate-feature`,
   `/add-feature`, `/onboard`/`/setup-infra`, or a `product-architect` scoping pass).
3. Prioritise: P0/P1 fixes first, then cheap high-leverage cleanups, then
   feature/iteration work by value ÷ effort, with nice-to-haves explicitly parked.
4. Write `docs/ROADMAP.md`: a focused **Now** slice (ordered, with its human-only
   checklist), **Next**, and **Later/parked** — each item runnable by its route.
   Link it from `docs/STATE.md`; re-plan after a slice ships.

The text after the command name optionally sets the goal or theme to optimise for
(e.g. "harden security", "ship the next feature").
