# Changelog

All notable changes to the kit. Newest first. Every change to the kit must add an
entry here (see `kit-maintenance`). Format: date — summary (files/areas).

## 2026-06-29 — Zero-paste sessions + versioned kit distribution (v0.2)
- Added **zero-setup session bootstrap**: `CLAUDE.md` (auto-loaded orientation)
  + `.claude/settings.json` SessionStart hook that runs `bin/link.sh claude` to
  wire skills/commands/subagents + `.mcp.json` — a fresh session needs no paste,
  just `/new-project <idea>` (D18).
- Added **versioned kit distribution**: `KIT_VERSION` pin + `bin/update-kit.sh`
  + `/update-kit` command. Template/vendored copies pull updates deliberately;
  update syncs only kit-owned paths and never product code/state/secrets (D17).
- `/status` now reports `KIT_VERSION` and flags when a newer kit exists.
- Fixed `bin/link.sh`: split a same-line `local tool=… dir=…$tool` that failed
  under `set -u` ("tool: unbound variable"), which had silently broken wiring.
- Cross-refs updated: `AGENTS.md` (Distribution & updates), `README.md`
  (template + update flow + commands), `docs/ARCHITECTURE.md` (file map +
  kit-owned vs project-owned), `project-bootstrap` + `kit-maintenance` skills,
  `.gitignore` (ignore regenerated tool symlinks, keep `.claude/settings.json`).

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
