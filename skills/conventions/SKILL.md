---
name: conventions
description: >-
  The engineering guardrails every change must respect: clean-architecture
  layering (KMP/Compose), design-token discipline, and git/branch/PR conventions.
  Use when writing or reviewing code, structuring features, or committing. These
  are always-on rules; the AGENTS.md constitution references them.
paths:
  - "**/*.kt"
  - "**/*Screen.kt"
  - "**/theme/**"
---

# Conventions — the always-on guardrails

## Clean architecture (KMP / Compose)

- **ViewModels** call **use cases** only — never repositories or data sources.
- **Use cases** call **repository interfaces** only — never `*Impl`.
- **Domain models** are platform-free: no `@Serializable`, no `androidx.*`, no
  serialization/Compose imports.
- **Supabase JSON** → `@Serializable` DTOs in `data/remote/dto/`, mapped to domain
  before crossing the boundary.
- **Composables** never import from `shared/data/**`.
- Feature order: domain model → repo interface → use case → DTO → mapper →
  datasource → repo impl → DI → UiState → ViewModel → Composable → navigation.
- Reject: `composeApp` importing `shared/data/**`; a `usecase` importing a
  `*Impl`; a `domain/model` with platform annotations; logic in a Composable or
  data source.

## Design tokens (no drift)

- Screens use only **semantic tokens + catalog components** — no raw hex, no magic
  spacing/radius/elevation, no per-screen typography.
- Missing value → add a token to `design/tokens.json`/`DESIGN.md`, regenerate the
  theme, then use it. Missing pattern → add a `CATALOG.md` component, implement
  once. (See `design-bridge`.)
- The generated theme files are artifacts — change tokens, not the generated code.

## Git / branches / PRs

- `main` = production (protected); `staging` = integration (protected); work on
  short-lived `feature/<slug>` (or your tool's convention) branches → PR.
- One logical change per commit; clear imperative subjects; never commit secrets.
- PRs small and focused; keep the tree building (both targets) and CI green;
  squash-merge; delete the branch after.
- Don't force-push or amend shared history unless asked. Don't leave the tree red.

These mirror what used to be enforced as editor-specific rules, kept here so they
apply in any tool.
