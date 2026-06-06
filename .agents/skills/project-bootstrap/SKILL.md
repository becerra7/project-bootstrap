---
name: project-bootstrap
description: >-
  Master orchestrator for spinning up a brand-new product from scratch with
  minimal input from the user. Use whenever the user wants to start a new
  project / app / repo, "create a project from zero", scaffold a greenfield
  codebase, or set up the full delivery pipeline (frontend + backend + auth +
  payments + CI/CD + deploys). Runs a short interview, locks in sensible
  defaults, then delegates to the specialised scaffolding, design-bridge,
  backend, and release skills/agents. Optimised so the user only does the few
  actions a human MUST do (creating accounts, pasting secrets).
metadata:
  stack: "KMP Compose Multiplatform | Web (wasmJs) | Supabase | Cloudflare | Firebase | Stripe"
  owner: "Albert"
---

# Project Bootstrap — the delivery pipeline, end to end

You are acting as a **senior software architect**. Your job is to take a rough
idea and turn it into a running, deployable product with the **least possible
configuration effort from the user**. Decide everything you reasonably can from
the defaults below; only ask the user about things that genuinely change the
shape of the product, and only ask them to *do* things that a human must do.

This skill is the entry point. It does not do all the work itself — it
**orchestrates** the focused skills and agents listed at the bottom.

## The golden rule: minimise human toil

Split every task into two buckets and keep them visible to the user:

- **Agent does** — code, config, schema, migrations, workflows, branches, PRs,
  tokens generation files, local builds, tests.
- **Human must do** (cannot be automated, needs a browser / a credential / an
  org decision) — these go into `SECRETS.md` (see `github-cicd` skill). Examples:
  create the Supabase project, create the Cloudflare account + API token,
  register the Firebase app + service account, paste secrets into the GitHub
  repo, approve the Google OAuth consent screen, add a Stripe account.

Always produce a single, ordered **"Your turn" checklist** of the human-only
steps. Never bury a manual step inside prose.

## Step 1 — Short interview (max ~6 questions, batch them)

Ask all of these at once, pre-filled with the recommended default in
parentheses. If the user already answered something in their request, do not
re-ask it.

1. **Product name + one-line pitch?** (used for repo name, app id, project ids)
2. **Frontend shape?**
   - `kmp` → Android app + adaptive Web (Compose Multiplatform / wasmJs) — **default**
   - `web` → Web only, adaptive for mobile+desktop (Compose wasmJs)
   - `web-react` → only if the user explicitly wants a JS/React stack
3. **Backend needed beyond Supabase?** (default: `worker-if-needed` — add a
   Cloudflare Worker only when there is server-side logic: webhooks, secrets,
   LLM calls, cron. Pure CRUD stays client → Supabase.)
4. **Auth?** (default: Supabase Auth with **Google** sign-in)
5. **Payments / Stripe?** (default: `no`; if yes → Checkout + webhook → Supabase ledger)
6. **Design tool?** (default: `stitch` — fluid, agent-driven via MCP; `claude` —
   Claude Design canvas, manual handoff; `none` — agent-only. Stored in
   `design/config.yml`; see `design-bridge`.)
7. **Deploy targets confirmed?** (default: Cloudflare Pages for web with
   `staging` + `production`, Firebase App Distribution for the Android APK)

If the user says "you decide" / "minimal questions", take **all defaults** and
proceed. Do not block on questions you can answer yourself.

## Step 2 — Lock the architecture (write it down first)

Before scaffolding, hand off to the **product-architect** subagent (or do it
inline) to produce a concise `docs/ARCHITECTURE.md` containing:

- One-paragraph product description + the 3–5 core user stories.
- The chosen stack + module map (mirror the layout in `scaffold-frontend`).
- The data model (entities → Supabase tables) and the auth model.
- The environment matrix: `local`, `staging`, `production` and what differs.
- The list of external services and **exactly which secret each needs**.

Keep it short. This is the contract the rest of the pipeline builds against.

## Step 3 — Scaffold in dependency order

Run these in order. Each is a separate skill — read it before executing it.

| Order | Concern | Skill | Notes |
| ----- | ------- | ----- | ----- |
| 0 | Onboard infra + MCP + secrets | `mcp`, `secrets-manager` | `/onboard`: provision what's automatable, verify the rest |
| 1 | Repo + frontend skeleton | `scaffold-frontend` | Clean-arch modules, DI, nav, theme hook |
| 2 | Design backbone | `design-bridge` | Manifest (tokens + screens) FIRST; Stitch/Claude per config |
| 3 | Database + auth | `supabase-backend` | Migrations, RLS, Google OAuth wiring |
| 4 | Server logic (if needed) | `cloudflare-deploy` | Worker w/ `staging` + `production` envs |
| 5 | Payments (if needed) | `stripe-payments` | Checkout → webhook → Supabase ledger |
| 6 | Git + CI/CD | `github-cicd` | Branch model, deploy workflows, `SECRETS.md` |
| 7 | Mobile delivery | `firebase-distribution` | Android APK → testers |

Cross-cutting (apply throughout, not a single step):

- **`design-bridge`** — for any UI, work the design manifest and (per
  `design/config.yml`) render via Stitch/Claude Design so you see/approve the
  screen before it's implemented. Per-screen, drift-safe.
- **`project-docs`** — keep `docs/STATE.md` + per-feature docs current as you go;
  this is how the project's state stays queryable.
- **`mcp`** — use the configured MCP servers to actually run things: inspect
  Supabase, deploy via Cloudflare, manage PRs/CI on GitHub, render designs via
  Stitch, screenshot via Playwright, check current docs via Context7.
- **`token-efficiency`** + **`parallel-agents`** — work cost-effectively and fan
  out independent tracks with clean hand-offs.

After each step, the project must still build. Never leave it red.

## Step 4 — First feature + first deploy

- Implement one thin end-to-end vertical slice (one screen + one table + auth)
  so the pipeline is proven on real code, not a hello-world.
- **Design the UI first** (`design-bridge`, `/design`) and get it approved before coding.
- Use the `/add-feature` command's loop and the `conventions` skill (clean arch).
- Write the feature into `docs/` (`project-docs`): create `docs/STATE.md` +
  `docs/features/<feature>.md`.
- Trigger the first `staging` deploy (or document the exact button to press if
  it needs human-held secrets).

## Step 5 — Hand back the "Your turn" checklist

End with: what is live, what is left, the current `docs/STATE.md` summary, and
the ordered list of human-only steps from `SECRETS.md` (including the MCP env
vars from `secrets-manager`), each with a direct link to where the user performs it.

## Iterating later (not just creating)

Most work after launch is iteration. Use `feature-lifecycle` (`/iterate-feature`)
to change/refactor/deprecate existing features — it reads `docs/` for the current
state first and updates it after. Use `/status` to query the project state any
time.

## Defaults baked in (so the user doesn't re-decide)

- **Language/UI:** Kotlin + Compose Multiplatform; adaptive layout via
  `WindowSizeClass` (phone / tablet / desktop breakpoints).
- **DI:** Koin. **Serialization:** kotlinx.serialization. **Async:** coroutines/Flow.
- **Architecture:** clean layering — ViewModel → UseCase → Repository interface
  → DataSource (Supabase). Domain models are platform-free. See the
  `conventions` skill.
- **Backend:** Supabase (Postgres + Auth + RLS). Worker only for server secrets.
- **Hosting:** Cloudflare Pages (web), Cloudflare Workers (api), two envs.
- **Mobile dist:** Firebase App Distribution (debug/internal), GitHub Actions.
- **Git:** trunk = `main` (prod), long-lived `staging`, short-lived
  `feature/<slug>` branches → PR. See `conventions` skill.
- **Secrets:** one home per secret — local mirror → GitHub Actions (canonical),
  names-only manifest. Never committed. See `secrets-manager`.

## Related skills & agents

- Skills: `scaffold-frontend`, `design-bridge`, `supabase-backend`,
  `cloudflare-deploy`, `github-cicd`, `firebase-distribution`, `stripe-payments`,
  `feature-lifecycle`, `project-docs`, `product-ideation`, `mcp`,
  `secrets-manager`, `conventions`, `token-efficiency`, `parallel-agents`,
  `kit-maintenance`.
- Subagents: `product-architect`, `scaffolder`, `design-engineer`, `release-engineer`.
- Commands: `/new-project`, `/onboard`, `/ideate`, `/design`, `/design-brief`,
  `/add-feature`, `/iterate-feature`, `/add-screen`, `/status`, `/setup-infra`,
  `/ship`, `/mode`, `/improve-kit`.
