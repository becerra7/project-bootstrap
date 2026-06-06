---
name: product-ideation
description: >-
  Generates and prioritizes product use cases and user stories from the project's
  own context (definition, existing features, data model) and, when asked, from
  external/market signal. Use when ideating new features, exploring "what should
  we build next", turning a vague idea into concrete use cases, or pressure-
  testing scope. Produces grounded, buildable specs that feed /add-feature and
  /design-brief — it proposes, you choose.
---

# Product ideation — grounded use cases, you decide

Read-only thinking partner for the front of the pipeline. It never builds; it
proposes options anchored in what already exists, so ideas are realistic and
reuse the current architecture instead of ballooning scope.

## Inputs (read these first)

- `docs/ARCHITECTURE.md`, `docs/STATE.md`, `docs/features/*.md` — what the product
  is and what exists.
- The design manifest (`design/screens/*`) — current screens/IA.
- The data model (Supabase tables) — what data is available to build on.
- **External signal — only when the user asks**: competitors, market trends,
  category conventions (via web search). Default is internal-only.

## Output

For each ideation request, produce:
1. **Candidate use cases / user stories** — "As a {user}, I can {action} so that
   {value}", grounded in existing features/data.
2. **Fit analysis** — for each: what it reuses (screens/tables/use cases) vs. what
   is new; dependencies; risks.
3. **Prioritization** — rough impact × effort (and confidence), with a
   recommended next 1–3.
4. For chosen items, a **buildable spec** ready for `/add-feature` (domain model,
   data, screens) or `/design-brief` (to hand to a design tool).

## Principles

- Anchor every idea in current context; flag when an idea needs new
  infrastructure (new table, Worker, payment) so cost is visible.
- Prefer the smallest slice that delivers the value; note what to defer.
- Keep external research clearly separated from internal-grounded ideas, and cite
  sources when you used the web.
- Hand the picked use case to `product-architect` (spec) → `/add-feature` (build),
  or to `design-bridge`/`/design-brief` (design first).

Pairs with: `product-architect` subagent, `project-docs`, `design-bridge`,
commands `/ideate` and `/design-brief`.
