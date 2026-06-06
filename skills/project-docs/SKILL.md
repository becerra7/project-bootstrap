---
name: project-docs
description: >-
  Maintains living, queryable documentation of the project and every feature so
  you can always get the CURRENT state. Use when asked "what's the current
  state", "what features exist", "what's the status of X", to onboard onto a
  codebase, or whenever a feature is created/iterated/deprecated (the docs must
  be updated as part of that work). Keeps a single docs/STATE.md dashboard plus
  one doc per feature, and a changelog — all in git, always reflecting reality.
paths:
  - "docs/**"
---

# Project docs — the always-current source of truth

The point: at any moment you can ask "what's the state of the project / this
feature?" and get an accurate answer, because the docs are updated *as part of*
building and iterating — not as an afterthought.

## Layout

```
docs/
  STATE.md                 # the dashboard: project status + feature index
  ARCHITECTURE.md          # stable design (from product-architect; rarely changes)
  features/
    <feature>.md           # one living doc per feature (status, code map, decisions)
  CHANGELOG.md             # dated, human-readable log of notable changes
```

- `STATE.md` is the **first thing to read** to understand the project now. It is
  short and links out to feature docs.
- `features/<feature>.md` is the **first thing to read before iterating** a
  feature (see `feature-lifecycle`). It records where the code lives, the rules,
  the data model, the approved design preview, and the change history.
- `ARCHITECTURE.md` holds the slow-moving design; don't duplicate it elsewhere.

## The update contract (non-negotiable)

Docs are part of "done". Specifically:

- **Create a feature** (`/add-feature`): create `features/<feature>.md` from
  `assets/feature.md.tmpl`, add a row to `STATE.md`'s feature index, add a
  `CHANGELOG.md` entry.
- **Iterate a feature** (`/iterate-feature`): update the feature doc's status,
  "What changed", code map, design preview link, and data model if touched; add
  a `CHANGELOG.md` entry; refresh the `STATE.md` row.
- **Deprecate/remove**: set the feature doc status + date + reason; update
  `STATE.md`; changelog entry.
- **Infra/schema change**: note it in the relevant feature doc and, if broad, in
  `STATE.md`'s "Infrastructure" section.

A PR that changes behaviour but not the docs is incomplete.

## Querying state (how to answer "what's the current state?")

1. Read `docs/STATE.md` for the dashboard + feature index.
2. For a specific feature, open `docs/features/<feature>.md`.
3. For recent movement, read the top of `docs/CHANGELOG.md`.
4. If the docs and code disagree, the code wins — **fix the docs immediately**
   (reverse-document), then proceed. Flag the drift to the user.

This is also how a fresh agent/subagent or a future you gets up to speed fast:
STATE.md → relevant feature doc → code. The `/status` command automates the
read; the `feature-lifecycle` skill automates the write.

## Keeping it lightweight

- Keep entries terse and factual; link to code paths and the design preview file
  rather than re-explaining them.
- Generate/refresh from the templates (`assets/STATE.md.tmpl`,
  `assets/feature.md.tmpl`) so structure stays consistent and queryable.
- Don't let it become a wiki — STATE.md should fit on one screen; detail lives in
  feature docs.
