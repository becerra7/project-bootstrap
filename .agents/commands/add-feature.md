# Add feature

Implement a new feature end-to-end following the clean-architecture layering.

Use the feature recipe from `scaffold-frontend` (and the
`conventions` skill), in this exact order:

1. Domain model (platform-free, no `@Serializable`).
2. Repository interface.
3. Use case(s) — one responsibility each.
4. DTO (`@Serializable`, mirrors the Supabase row) + a migration if a new table
   is needed (use the `supabase-backend` migration template + RLS).
5. Mapper (DTO ⇄ domain).
6. DataSource (Supabase) + Repository impl.
7. DI wiring (impl in `dataModule`, use cases in `domainModule`, VM in `appModule`).
8. UiState + ViewModel (StateFlow, events → use cases).
9. Screen built from design-bridge tokens/components only (delegate UI to the
   `design-engineer` subagent; obey the `design-tokens` rule).
10. Navigation entry.

Then build both targets and keep the tree green. Work on a `feature/<slug>`
branch and open a PR per the `conventions` skill.

The layering recipe above is the kit's KMP/Compose default. In an **adopted**
project on a different stack, follow the project's own architecture as recorded in
`docs/STATE.md` (and mirror the feature into the existing layers and test style)
instead of forcing this exact order — same principle, the project's shape.

The text after the command name is the feature description.
