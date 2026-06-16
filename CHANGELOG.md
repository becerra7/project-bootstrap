# Changelog

All notable changes to the kit. Newest first. Every change to the kit must add an
entry here (see `kit-maintenance`). Format: date — summary (files/areas).

## 2026-06-16 — Fix: install.sh/link.sh failed under `set -u`
- `bin/link.sh` errored with `tool: unbound variable` because a single `local
  tool="$1" dir="$TARGET/.$tool"` expands `$tool` before it's assigned (nounset).
  Split into two `local` statements. Verified `bin/install.sh --target … --tool
  claude` now vendors the kit + links `.claude/` (skills, commands, agents) +
  `.mcp.json` into a target repo without touching the project's own files.

## 2026-06-14 — Cross-repo ops + brownfield onboarding polish (D18)
- Added **`multi-repo-ops`** skill + **`/across-repos`** command — one agent surveys
  (and, when asked, acts on) a set of GitHub repos via the user-scope github MCP:
  resolve an explicit allowlist → fan out one read-only worker per repo → aggregate
  → act per-repo via branch+PR. Read-only by default; writes opt-in + confirmed.
  (`.agents/skills/multi-repo-ops/SKILL.md`, `.agents/commands/across-repos.md`)
- Made onboarding brownfield-safe: `/onboard` now **reconciles** existing MCP/
  secrets/CI instead of clobbering; `bin/install.sh` next-steps cover existing
  repos (`/adopt-project` path), not just `/new-project`. (`.agents/commands/
  onboard.md`, `bin/install.sh`)
- `/add-feature` notes it follows the **adopted project's own architecture** (per
  `docs/STATE.md`) when the stack isn't the kit's KMP default. (`.agents/commands/
  add-feature.md`)
- Cross-references: `README.md` (across-repos), `docs/ARCHITECTURE.md` (file map),
  `docs/DECISIONS.md` (D18), `mcp` skill (user-scope github spans all repos),
  `parallel-agents` (per-repo fan-out).

## 2026-06-14 — Brownfield path: adopt & improve existing projects (D17)
- Added **`project-adoption`** orchestrator skill + **`/adopt-project`** command —
  the brownfield mirror of `project-bootstrap`: detect the real stack, reverse-
  engineer features, reverse-document into `docs/STATE.md` + `docs/features/*`
  (via `project-docs`), and reconcile infra/MCP/secrets. Stack-aware; read-only
  (makes no code changes). (`.agents/skills/project-adoption/SKILL.md`,
  `.agents/commands/adopt-project.md`)
- Added **`code-audit`** skill + **`/audit`** command + **`code-auditor`** read-only
  subagent — severity-ranked findings (P0→P3) with evidence into `docs/AUDIT.md`,
  fan-out by area/lens for large repos. (`.agents/skills/code-audit/SKILL.md`,
  `.agents/commands/audit.md`, `.agents/subagents/code-auditor.md`)
- Added **`codebase-cleanup`** skill + **`/cleanup`** command — safe, behaviour-
  preserving fixes from the audit, one concern per commit. (`.agents/skills/
  codebase-cleanup/SKILL.md`, `.agents/commands/cleanup.md`)
- Added **`improvement-planning`** skill + **`/propose-improvements`** command —
  detected features + audit → prioritised, routed `docs/ROADMAP.md`. (`.agents/
  skills/improvement-planning/SKILL.md`, `.agents/commands/propose-improvements.md`)
- Cross-references: `README.md` (new "Adopt an existing project" section + command
  groups), `AGENTS.md` (two entry paths; detect-don't-assume for adopted stacks),
  `docs/HOW_IT_WORKS.md` (brownfield entry diagram), `docs/ARCHITECTURE.md` (file
  map + "what an existing project gets"), `docs/DECISIONS.md` (D17),
  `project-bootstrap` (greenfield cross-link), `parallel-agents` (`code-auditor` role).

## 2026-06-06 — Standalone, tool-agnostic, self-improving kit (v0.1)
- Restructured into a standalone repo with neutral `.agents/` source + `AGENTS.md`
  constitution + `bin/link.sh` adapters for Cursor/Claude/Codex (D14, D15).
- Replaced `design-system`/`design-preview` with **`design-bridge`**: repo design
  manifest (DESIGN.md + W3C tokens + per-screen specs + screen-map + fingerprints),
  config-driven Stitch (MCP, fluid) / Claude Design (manual, per-screen via ID +
  diff) / none, agent-authored prompt packs (D4, D5, D6, D7).
- Reworked **MCP** into user-scope (GitHub, Cloudflare, Stitch, Playwright,
  Context7, Firebase) vs project-scope (Supabase) for parallel multi-project reuse;
  added the meta procedure to add new servers; firebase/gcloud notes (D10, D11, D12).
- Added **secrets-manager** (one-home-per-secret: gitignored local mirror →
  GitHub Actions canonical; names-only manifest) + `secrets-sync.sh`/`check.sh` +
  Playwright auth template (D13).
- Added **product-ideation** + `/ideate` (internal + external) and `/design-brief`
  (generic) (D16).
- Added the constitution layer: `AGENTS.md`, behavior presets + `/mode`,
  `token-efficiency` + `parallel-agents` skills, `conventions` skill (folds the
  former editor-specific rules) (D16).
- Added **kit-maintenance** skill + `/improve-kit` (self-improvement engine) and
  the knowledge docs (HOW_IT_WORKS, DECISIONS, ARCHITECTURE, GLOSSARY) (D15).
- Carried over the proven skills/templates: scaffold-frontend, supabase-backend,
  cloudflare-deploy, github-cicd, firebase-distribution, stripe-payments,
  feature-lifecycle, project-docs, project-bootstrap (orchestrator).

## Earlier (in-repo prototype)
- Initial kit prototyped under `.cursor/` inside the myFinance repo, then migrated
  here and made tool-agnostic.
