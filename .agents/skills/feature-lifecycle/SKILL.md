---
name: feature-lifecycle
description: >-
  Manages the full life of a feature — not just creating it, but ITERATING on
  existing ones, refactoring, fixing, and deprecating. Use when changing,
  improving, extending, redesigning, or removing a feature that already exists
  (as opposed to building a brand-new one). Reads the living docs to understand
  the current state first, makes a focused change, and updates the docs + design
  previews so the feature's record stays accurate.
paths:
  - "shared/**"
  - "composeApp/**"
  - "docs/**"
---

# Feature lifecycle — create, then keep iterating

Most of the work on a product is **iteration**, not greenfield features. This
skill makes iterating safe and fast by always starting from the recorded current
state and ending with the record updated.

A feature moves through: **propose → build → iterate → refactor → deprecate**.
`/add-feature` handles "build" (the first vertical slice). This skill owns
everything after that.

## Before touching code: load the current state

1. Read the feature's doc: `docs/features/<feature>.md` (see `project-docs`).
   If it doesn't exist, create it from the template first by reverse-documenting
   what's there — never iterate on an undocumented feature.
2. Read `docs/STATE.md` to see how this feature relates to the rest.
3. Map the touch points across layers (domain → data → presentation) using the
   feature doc's "Code map" section so you know exactly what changes.

## Iterating (the common case)

1. **Clarify the change** in one sentence and confirm scope (what stays the same
   matters as much as what changes).
2. **Design first if UI changes** — run the `design-bridge` flow (`/design`) and get the new
   look approved before editing Compose.
3. **Change in dependency order**, smallest surface that works:
   domain model → use case → repo/datasource (+ migration if the schema changes;
   write a *new* numbered migration, never edit an applied one) → mapper/DTO →
   ViewModel/UiState → Composable. Keep each layer's contract stable unless the
   change requires breaking it.
4. **Preserve behaviour you're not changing** — check the feature doc's
   "Behaviour / rules" section and any regression baseline before and after.
5. **Build both targets**, keep the tree green.
6. **Update the record** (mandatory): bump the feature doc (status, what changed,
   new screens/previews, new tokens) and `docs/STATE.md` + add a changelog entry.
   See `project-docs`. An iteration isn't done until the docs reflect it.

## Refactoring (no behaviour change)

- State the invariant: "behaviour identical, structure better." Lean on the
  `conventions` skill. Update the feature doc's "Code map" if files
  move. No design preview needed.

## Schema/data migrations during iteration

- Additive first (new nullable column / new table) so old clients keep working;
  backfill; only then make non-null/required. Always a new migration file.
  Note the migration + any RLS change in the feature doc.

## Deprecating / removing

1. Confirm nothing else depends on it (search usages; check `docs/STATE.md`).
2. Remove UI → ViewModel → use cases → repo/datasource, in reverse dependency
   order. Decide explicitly whether to drop the table/data (write the migration)
   or keep it for history.
3. Mark the feature doc `status: deprecated`/`removed` with the date and reason;
   update `docs/STATE.md`.

## Guardrails

- One feature change per branch/PR (`conventions`). Don't smuggle unrelated
  changes into an iteration.
- Never edit a migration that's already been applied; add a new one.
- If a change would violate clean-architecture layering, stop and refactor first.

Pairs with: `project-docs` (state + records), `design-bridge` (UI changes),
`design-engineer`, `supabase-backend` (migrations), `conventions` skill.
