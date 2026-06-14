---
name: code-audit
description: >-
  Review an existing codebase and produce a prioritised, severity-ranked findings
  report. Use when the user asks to review, audit, assess, or "find what's wrong
  with" code — correctness/bugs, security, architecture-fit, dependency health,
  tests, and performance. Stack-aware: reviews against the project's actual
  conventions (and the kit `conventions` skill only where the stack matches).
  Read-only: it diagnoses and writes docs/AUDIT.md; it does not change code (that
  is codebase-cleanup / feature-lifecycle).
paths:
  - "docs/**"
---

# Code audit — find what matters, ranked, with evidence

Produce an honest, prioritised picture of a codebase's health that a human can
act on in an afternoon. **Read-only:** the deliverable is `docs/AUDIT.md`, not a
diff. Fixes happen in `/cleanup` (safe/mechanical) and `/iterate-feature` or
`/propose-improvements` (behaviour-changing). Every finding cites evidence
(`file:line`) — no vague "could be better".

## Before reviewing: know the project

Read `docs/STATE.md` (from `project-adoption`) for the detected stack and the
project's own conventions. If it doesn't exist, do a quick detection pass first —
never review a stack you haven't identified. Review against **the project's**
conventions; apply the kit `conventions` skill (clean-arch, design tokens, git)
only where the stack actually matches (KMP/Compose).

## What to review (the lenses)

Cover these; skip a lens explicitly (and say so) rather than pretending you did it.

1. **Correctness & bugs** — logic errors, unhandled errors/edge cases, races,
   resource leaks, broken invariants, obvious null/`undefined` hazards.
2. **Security** — secrets in the repo/history, injection, authz/authn gaps,
   unsafe deserialization, vulnerable/abandoned deps, missing input validation,
   over-broad permissions/RLS. Flag, don't exploit.
3. **Architecture & maintainability** — layering violations, tight coupling, god
   files, duplication, dead code, leaky boundaries. For KMP/Compose, check the
   `conventions` rules; for other stacks, the project's stated structure.
4. **Dependencies** — outdated/EOL/duplicated/unused packages; license risks;
   lockfile drift.
5. **Tests & CI** — coverage of critical paths (not a % fetish), flakiness,
   whether CI actually gates merges, missing build/test on a target.
6. **Performance** (only where it bites) — N+1s, obvious hot-path waste,
   oversized bundles/assets. Don't speculate-optimise.

## Severity & prioritisation

Rank every finding so the user knows what to do first:

- **P0 — critical:** security holes, data loss/corruption, broken builds.
- **P1 — high:** real bugs hitting users, missing tests on critical paths.
- **P2 — medium:** maintainability/architecture debt that slows changes.
- **P3 — low / nits:** style, minor cleanups (most feed `/cleanup`).

Order by `severity × blast-radius`, not by how easy it was to find. For each
finding give: title, severity, evidence (`file:line`), why it matters in one
line, and a concrete fix direction (with the route: `/cleanup` for safe/mechanical,
`/iterate-feature` for behaviour change, `/propose-improvements` for larger work).

## Run, don't just read

Where the project's tooling exists, **run it** and fold the output into findings:
the build, the test suite, the linter/formatter, the type checker, dependency-audit
(`npm audit`, `pip-audit`, `osv-scanner`, …), and secret scanning. Attribute each
finding to "observed" vs "inferred". Use MCP/CLI per the `mcp` skill. Don't claim
a check passed unless you saw it pass.

## Scale with the codebase

For large repos, fan out **read-only** `code-auditor` subagents by area (one lens
or one module each) with non-overlapping ownership, then merge their findings and
de-duplicate (`parallel-agents`). Keep the main context lean; pick the cheapest
model that fits each slice (`token-efficiency`).

## Output: `docs/AUDIT.md`

Write a dated report:

- **Summary:** overall health in 3–5 lines + counts per severity.
- **Findings** grouped P0→P3, each with evidence + fix direction + route.
- **What I ran** (and results) vs **what I only read**.
- **Suggested order of attack**, handing the P0/P1 cleanups to `/cleanup` and the
  larger items to `/propose-improvements`.

An audit isn't done until `docs/AUDIT.md` exists and `docs/STATE.md` links it.

## Guardrails

- **Read-only.** Don't fix during an audit — findings must be reviewable first.
- Cite evidence for every finding; no unfalsifiable claims.
- Don't drown the report — cap nits, group duplicates, lead with what matters.

Pairs with: `codebase-cleanup` (acts on the safe findings), `improvement-planning`
(acts on the larger ones), `project-adoption` (runs this as a recommended step),
`conventions`, `parallel-agents`, `token-efficiency`.
