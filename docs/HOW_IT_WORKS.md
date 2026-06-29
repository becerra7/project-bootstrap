# How it works — the full mental model

Read this to understand the kit end to end. It's written so any LLM can ingest it
and then improve any part with full context. Pair it with `docs/DECISIONS.md`
(why) and `docs/ARCHITECTURE.md` (where).

## Purpose

Turn an idea into a shipped product with minimal human configuration. The kit is
a portable set of **skills** (knowledge + procedures), **subagents** (pipeline
roles), **commands** (entry points), **behaviors** (tone presets), **MCP config**
(so the agent executes, not just writes), and **docs/rules** — all tool-agnostic.

## The pipeline

```
ideate ─▶ architect ─▶ scaffold ─▶ design ─▶ data+auth ─▶ [worker] ─▶ [payments]
   │          │            │          │          │                          │
product-   product-     scaffolder  design-   supabase-   cloudflare-   stripe-
ideation   architect                engineer  backend     deploy        payments
                                       │
                              design-bridge (manifest ↔ Stitch/Claude)
   │
   └─▶ CI/CD (github-cicd) ─▶ mobile (firebase-distribution) ─▶ ship ─▶ iterate
                                                                          │
                                                              feature-lifecycle
                                          (state tracked throughout by project-docs)
```

`project-bootstrap` is the orchestrator that runs this. `/new-project` kicks it
off; day-to-day you use `/ideate`, `/design`, `/design-brief`, `/add-feature`,
`/iterate-feature`, `/status`, `/onboard`, `/setup-infra`, `/ship`, `/mode`,
`/improve-kit`, `/update-kit`.

## Three big ideas

### 1. The design manifest (not a design tool lock-in)
`design/` in the repo is the **source of truth**: `DESIGN.md` (system, Stitch open
format) + `tokens.json` (W3C) + `screens/<id>.md` (per-screen spec) + `CATALOG.md`
+ `screen-map.json`. Visual tools are viewers:
- **Stitch** (programmatic, via MCP): fluid loop — agent renders, you review the
  PNG in chat, iterate, agent maps to Compose. Per-screen native.
- **Claude Design** (manual canvas): agent writes the prompt pack, you design,
  export a handoff bundle; the agent applies **only the changed screen** by
  matching the screen-ID title and diffing fingerprints (so a bundle containing
  all screens doesn't cause drift).
- **none**: agent-only.
Chosen in `design/config.yml`. This keeps the "see designs / iterate visually"
benefit, avoids burning the *coding agent's* tokens on design, and never forces a
framework switch (tokens are portable).

### 2. State as compressed memory
`project-docs` keeps `docs/STATE.md` (dashboard) + `docs/features/*.md` + a
changelog current as part of every change. Agents read state instead of
re-deriving it (cheap), and `/status` answers "what's the current state" anytime.

### 3. Execute via MCP, configured by scope
The agent acts through MCP servers (`mcp` skill). **User-scope** servers (GitHub,
Cloudflare, Stitch, Playwright, Context7, Firebase) are set once per machine and
shared across all projects in parallel; **project-scope** (Supabase, pinned to a
`project_ref`) lives in each repo. This is what makes the setup reusable across
many parallel projects.

## Tool-agnosticism

Canonical content lives in `.agents/` (neutral). `bin/link.sh <cursor|claude|codex>`
symlinks it into each tool's expected location. `AGENTS.md` is the universal
instruction file (read by most tools). Standards used are portable: `DESIGN.md`,
W3C tokens, MCP JSON, the `SKILL.md` format. There is no single universal
directory standard yet — the symlink adapter is the deliberate bridge.

## Secrets

One home per secret: gitignored local mirror (readable source) → GitHub Actions
(canonical CI store, write-only) via `bin/secrets-sync.sh`; committed manifest =
names-only index. See `secrets-manager`.

## Self-improvement

The kit maintains itself via `kit-maintenance` + `/improve-kit`: any change runs a
per-type checklist (update cross-references), then records what (CHANGELOG) and why
(DECISIONS). So the repo never drifts and history is always continuable.

## Using vs. building the kit
- **Using it on a product**: install into the product repo (`bin/install.sh` /
  `link.sh`), then drive with the commands.
- **Improving the kit itself**: open this repo, use `/improve-kit`.
