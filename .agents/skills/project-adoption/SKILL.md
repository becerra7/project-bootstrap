---
name: project-adoption
description: >-
  Master orchestrator for adopting an EXISTING codebase into the kit (the
  brownfield mirror of project-bootstrap). Use whenever the user points the kit
  at a repo that already has code — "onboard this existing project", "adopt this
  repo", "make the kit work on my current codebase", "understand/document what's
  here". Detects the real stack and features, reverse-documents them into the
  kit's living docs + design manifest, reconciles infra/MCP/secrets with what
  already exists, then routes to code-audit, codebase-cleanup, and
  improvement-planning. Stack-aware: respects the project's actual stack and
  conventions instead of assuming the kit defaults.
metadata:
  stack: "stack-agnostic detection; maps to kit docs/conventions where the stack matches"
  owner: "Albert"
---

# Project Adoption — bring an existing codebase into the kit

You are acting as a **senior engineer doing a fast, honest takeover** of a
codebase you didn't write. The goal is to make an existing repo as continuable
and queryable as a kit-bootstrapped one — **without rewriting it**. Where
`project-bootstrap` creates state from an idea, this skill *recovers* state from
code. The code is the source of truth; docs are derived from it.

This skill is an entry point. It **orchestrates** detection, reverse-documentation,
and the focused review/cleanup/planning skills listed at the bottom — it does not
do all the work inline.

## Prime directive (unchanged): minimise human toil, never lie about state

- Everything the agent can read, infer, or run, it does. The human list is only
  the truly human-only items (account access, a credential to paste, a decision
  about direction).
- **Honesty rule:** if the docs you generate and the code disagree, the code
  wins. Never invent features, tests, or guarantees that aren't in the repo.
  Mark anything uncertain as `inferred` so the next agent knows to verify.

## Don't assume the kit defaults

The kit's defaults (KMP/Compose + Supabase + Cloudflare + Firebase) describe
*new* projects. An existing repo can be anything. So:

- **Detect, don't assume** the language, framework, build system, backend, host,
  auth, and CI that are *actually* present.
- Apply the `conventions` skill's rules **only where the stack matches** (they
  are KMP/Compose-specific). For other stacks, record the project's *own*
  conventions in `docs/STATE.md` and review against those.
- Offer the kit's managed infra (Supabase/Cloudflare/Firebase, design manifest,
  secrets model) as **opt-in adoption**, never a forced migration. Recommend;
  let the user choose. Capture each choice in `docs/DECISIONS.md` (project-local).

## Phase 1 — Detect (what is this?)

Build a factual map of the repo before writing anything.

1. **Stack & shape:** identify languages, frameworks, package/build manifests
   (`package.json`, `*.gradle*`, `pyproject.toml`, `go.mod`, `Cargo.toml`, …),
   the module/dir layout, and the entry points. Note monorepo vs single app.
2. **Runtime & infra:** backend(s), database + how schema/migrations are managed,
   auth, hosting/deploy targets, CI config (`.github/workflows`, etc.), and any
   IaC. Record what's wired vs aspirational.
3. **Build/run/test reality:** find how to build, run, and test it; note whether
   tests exist and pass. Don't claim green if you didn't see it green.
4. **Health signals (cheap pass):** obvious dead code, TODO/FIXME density,
   secrets-in-repo risks, dependency staleness, missing CI. These seed the audit.
5. **Docs & history:** read any existing README/docs and recent commit history to
   understand intent and active areas. Don't re-derive what's already written.

Prefer reading manifests and a few key files over scanning everything; fan out
read-only explorers for breadth (`parallel-agents`) and keep the main context lean.

## Phase 2 — Detect features (reverse-engineer the product)

Recover the feature set from the code, not from guesses.

- Derive features from **routes/navigation, screens/pages, API endpoints,
  domain modules, and DB tables** — wherever the app expresses user-facing
  capability. Cluster related code into one feature per capability.
- For each feature capture: a one-line purpose, the **code map** (the files
  across layers that implement it), its data/storage touchpoints, and obvious
  behaviour/rules you can read off the code. Mark anything you inferred.
- Produce a feature index ranked by centrality (what the product is *for* first).

## Phase 3 — Reverse-document into the kit's living state

Make the repo speak the kit's state model so every later command works.

1. **`docs/STATE.md`** (via `project-docs`): current stage, the detected stack +
   the project's own conventions, the environment/infra map, and the feature
   index. Mark inferred items.
2. **`docs/features/<feature>.md`** per detected feature (from the `project-docs`
   template): purpose, code map, behaviour/rules, data, and `status: adopted`
   (vs `planned`). These are the contract `/iterate-feature` reads later.
3. **Design manifest (only if the user opts in):** if there's an existing UI and
   the user wants the design loop, seed `design/` from the real screens via
   `design-bridge` (catalog + tokens reverse-derived, screens keyed by ID). If
   not, skip it — don't fabricate a design system.
4. **Changelog:** open `docs/CHANGELOG.md` with an "adopted by the kit" entry.

Keep docs short and skimmable. They are compressed memory, not a re-paste of code.

## Phase 4 — Reconcile infra, MCP & secrets (adopt, don't overwrite)

- **MCP:** wire only the servers this project actually uses (`mcp` skill); don't
  add Supabase/Cloudflare config for a project that uses neither.
- **Secrets:** inventory existing secrets/config; map them into the
  `secrets-manager` model (names-only manifest + local mirror) **without moving
  anything that already works** unless the user asks. Flag any secret committed
  in history as a finding for the audit.
- **CI/CD:** note what exists; propose gaps (e.g. no CI, no staging) as roadmap
  items rather than silently adding pipelines.

## Phase 5 — Hand back: report + your-turn + next steps

End with a concise **adoption report**:

- **What this is:** stack, shape, infra, and the feature index (with inferred
  flags) — pointing at `docs/STATE.md`.
- **Health snapshot:** the top risks/smells found in the cheap pass.
- **Your turn:** the ordered human-only list (account access, decisions on which
  managed infra to adopt, secrets to paste).
- **Recommended next steps**, in order:
  1. `/audit` → full review into `docs/AUDIT.md` (`code-audit`).
  2. `/cleanup` → safe, behaviour-preserving fixes (`codebase-cleanup`).
  3. `/propose-improvements` → prioritised `docs/ROADMAP.md` (`improvement-planning`),
     which then feeds `/add-feature` and `/iterate-feature`.

After adoption, the existing project uses the **same** day-to-day commands as a
bootstrapped one (`/status`, `/add-feature`, `/iterate-feature`, `/design`,
`/ship`, `/mode`). Adoption is the on-ramp; the rest of the kit is unchanged.

## Guardrails

- Read-and-document first; **make no code changes in adoption itself** — cleanups
  and improvements are separate, reviewable steps (`/cleanup`, `/propose-improvements`).
- One concern per commit/PR (`conventions`). Don't smuggle refactors into the
  reverse-documentation commit.
- Never claim a capability (tests pass, feature works, secret rotated) you didn't
  verify. Inferred ≠ confirmed.

## Related skills & agents

- Skills: `code-audit`, `codebase-cleanup`, `improvement-planning`,
  `project-docs`, `design-bridge`, `mcp`, `secrets-manager`, `conventions`,
  `feature-lifecycle`, `token-efficiency`, `parallel-agents`.
- Subagents: `code-auditor` (read-only review), `product-architect` (for
  scoping large proposed work).
- Commands: `/adopt-project`, `/audit`, `/cleanup`, `/propose-improvements`,
  then the day-to-day `/status`, `/add-feature`, `/iterate-feature`.
- Sibling orchestrator: `project-bootstrap` (the greenfield mirror).
