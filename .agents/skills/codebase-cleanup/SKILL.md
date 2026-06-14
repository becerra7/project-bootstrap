---
name: codebase-cleanup
description: >-
  Apply safe, behaviour-preserving cleanups to an existing codebase — dead code,
  formatting/lint, dependency hygiene, and structural tidy-ups toward the
  project's conventions. Use when the user asks to clean up, tidy, de-lint,
  remove dead code, or pay down mechanical debt. Driven by code-audit findings;
  changes behaviour-preserving and incremental, one concern per commit. For
  behaviour changes use feature-lifecycle/iterate-feature instead.
paths:
  - "**"
---

# Codebase cleanup — leave it tidier, never different

Turn the safe findings from `code-audit` into small, reviewable, **behaviour-
preserving** changes. The invariant for everything here: *behaviour identical,
code cleaner.* Anything that changes what the program does is **not** cleanup —
route it to `/iterate-feature` (`feature-lifecycle`) or `/propose-improvements`.

## Before changing anything

1. Read `docs/AUDIT.md` (the source of work) and `docs/STATE.md` (stack + the
   project's own conventions). If there's no audit, do a quick pass first — don't
   clean blind.
2. Confirm a **safety net**: a building tree and, ideally, passing tests. If
   tests don't exist for an area you're cleaning, prefer the lowest-risk changes
   (formatting, provably-unused code) and say so. Never start from a red tree.
3. Make sure the working tree is clean and you're on a `feature/<slug>` branch
   (`conventions`).

## What's in scope (safe, mechanical)

- **Dead code:** provably-unused exports, files, branches, feature flags, and
  commented-out blocks (verify no dynamic/reflective use first).
- **Formatting & lint:** run the project's formatter/linter; apply autofixes;
  resolve remaining lint with minimal, local edits.
- **Imports & deps:** drop unused imports/dependencies; de-duplicate; align
  versions/lockfile. Upgrades that change behaviour are **out** (→ roadmap).
- **Naming & structure (local):** rename for clarity, split a god file, move a
  misplaced file toward the project's layout — only when it's mechanical and
  references update cleanly.
- **Trivial bug-adjacent tidy:** add an obviously-missing null/error guard *only*
  when it can't change a passing test's outcome; otherwise it's a behaviour change.

## What's explicitly out of scope

- Logic/behaviour changes, API/schema changes, dependency major-version bumps,
  perf rewrites, new features. These go to `/iterate-feature` or `/propose-improvements`.
- Editing an already-applied migration (write a new one — `supabase-backend`).
- "While I'm here" scope creep. One concern per commit; resist bundling.

## How to work (small, verifiable batches)

1. Take **one finding / one concern** at a time. Make the change as small as it
   can be.
2. **Build + run the tests after each batch.** Keep the tree green at every step;
   if a "safe" change goes red, it wasn't behaviour-preserving — revert and
   reclassify it as a roadmap item.
3. Prefer automated transforms (formatter, codemod, IDE rename) over hand edits
   for breadth; review the diff before committing.
4. **Commit per concern** with a clear imperative subject (e.g. `Remove unused
   AuthLegacy datasource`). Don't mix a rename commit with a dependency commit.
5. For a big surface, isolate noisy sweeps in a separate worktree/subagent so they
   don't bloat the main context (`parallel-agents`, `token-efficiency`).

## When done

- Update `docs/AUDIT.md`: tick the findings now resolved (leave behaviour-changing
  ones for the roadmap). Update `docs/STATE.md` / `docs/CHANGELOG.md` via
  `project-docs` if structure or conventions changed.
- Summarise: what was cleaned, what was deliberately left (and why it's not
  "safe"), and the green build/test result. Open one focused PR per concern (or a
  tightly-scoped cleanup PR) per `conventions`.

## Guardrails

- **Behaviour-preserving or it's not cleanup.** When in doubt, route it out.
- Never clean on a red tree or without a way to tell you broke something.
- Don't delete code you only *think* is unused — confirm no dynamic references.

Pairs with: `code-audit` (supplies the findings), `feature-lifecycle` (behaviour
changes/refactors with intent), `conventions`, `project-docs`, `parallel-agents`.
