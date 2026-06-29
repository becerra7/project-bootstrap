# AGENTS.md — operating constitution

> Universal instructions for any AI agent working **with** this kit or **on** this
> kit. Tool-agnostic (Cursor, Claude Code, Codex, …). Read this first, then load
> skills on demand. If you are improving the kit itself, also read the
> `kit-maintenance` skill.

## What this kit is

An agentic, end-to-end software-delivery setup: take an idea → ship a product,
with the **least possible configuration from the user**. It encodes a standard
stack and pipeline as portable skills, subagents, commands, behaviors, and MCP
config. Canonical source lives in `.agents/`; `bin/link.sh` exposes it to each
tool. Full mental model: `docs/HOW_IT_WORKS.md`. Rationale/history:
`docs/DECISIONS.md`.

## Prime directive: minimize human toil

Split every task into **agent does** (code, config, schema, migrations,
workflows, branches, PRs, provisioning via CLI/MCP) vs **human must do** (own an
account, paste a credential, approve a consent screen). Surface the human list as
one ordered checklist; never bury a manual step in prose. Decide everything you
reasonably can from defaults; ask only when it changes the product's shape.

## How to communicate

- Be concise and result-first. No filler, no flattery, no restating the request.
- Lead with what changed / what you'll do; keep explanation proportional to the
  task. The user can set tone with `/mode` (terse/explain/ship-fast/careful-
  review/architect) — honor the active preset.
- Reference file paths, don't paste large blobs. Use backticks for code/paths.
- Surface assumptions and human-only steps explicitly.

## How to operate

- **Skills load on demand** by relevance — don't stuff everything into context.
  The orchestrator is `project-bootstrap`; it routes to focused skills.
- **State lives in docs.** Read `docs/STATE.md` + the relevant feature doc before
  acting; update them as part of every change (`project-docs`). State is the
  compressed memory that keeps work cheap.
- **Run things, don't just write them.** Use MCP/CLI (Supabase, GitHub,
  Cloudflare, Stitch, Playwright, Context7, firebase/gcloud) per the `mcp` skill.
- **Token efficiency is a constraint**, not an afterthought (`token-efficiency`).
- **Parallelize only genuinely independent work** with clean hand-offs
  (`parallel-agents`); pick the cheapest model that fits each subtask.
- **Respect the guardrails** in `conventions` (clean architecture, design tokens,
  git/PR) on every change. Keep the tree green.

## The stack (defaults, override only when needed)

Frontend: Kotlin Multiplatform + Compose Multiplatform (Android + adaptive
Web/wasmJs); web-only and a React/Vite escape hatch supported. Backend: Supabase
(Postgres + Auth + RLS, Google sign-in); optional Cloudflare Worker (staging +
production) only for server logic/secrets. Hosting: Cloudflare Pages (staging +
production). Mobile: Firebase App Distribution. Payments: optional Stripe. CI/CD:
GitHub Actions. Design: repo design manifest bridged to Stitch (programmatic) or
Claude Design (manual), chosen per project (`design-bridge`).

## Design philosophy (don't regress this)

The repo **design manifest** (`design/`) is the source of truth; visual tools are
viewers. Never re-design from scratch in the coding agent (it burns tokens and
drifts). Everything is keyed by stable **screen IDs**; handoffs are applied
per-screen via title-mapping + fingerprint diff. See `design-bridge`.

## Secrets

One home per secret. GitHub Actions = canonical CI/runtime store (write-only).
Gitignored local mirror = the readable source. Committed manifest = the index
(names only). Never commit values. See `secrets-manager`.

## Distribution & updates

A product **vendors** the kit (GitHub "Use this template", or `bin/install.sh`) —
a point-in-time copy, not a live link. Pull later kit improvements deliberately
with `/update-kit` (`bin/update-kit.sh`), which overwrites only kit-owned paths
(`.agents/`, `bin/`, `mcp/`, `AGENTS.md`, `CLAUDE.md`, `KIT_VERSION`,
`.claude/settings.json`, kit `docs/*`) and never product code, state, design,
migrations, CI, or secrets. The kit version is pinned in `KIT_VERSION`. A fresh
Claude Code session needs no setup paste: `CLAUDE.md` is auto-loaded and a
SessionStart hook runs `bin/link.sh` to wire skills/commands/subagents + `.mcp.json`.

## Self-improvement (when changing THIS kit)

Every change to the kit must: follow `kit-maintenance` (update the right
cross-references), append to `CHANGELOG.md`, and record the rationale in
`docs/DECISIONS.md`. Keep skill `name` == folder, commands/subagents referenced,
and `bin/link.sh` aware of any new top-level dirs. Everything that changes is
tracked so anyone can pick up where the last agent left off.
