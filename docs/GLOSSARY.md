# Glossary

- **Skill** — a `SKILL.md` (frontmatter `name`/`description` + markdown body) that
  the agent loads on demand by relevance. Knowledge + procedure.
- **Subagent** — a specialized agent (`.agents/subagents/*.md`) for a pipeline
  role (architect, scaffolder, design-engineer, release-engineer).
- **Command** — a plain-markdown entry point (`.agents/commands/*.md`); filename =
  the `/command`.
- **Behavior preset** — a tone/working-style mode (`.agents/behaviors/*.md`)
  selected with `/mode`. Never overrides guardrails.
- **Design manifest** — the repo-owned source of truth for design: `DESIGN.md` +
  `tokens.json` + `screens/<id>.md` + `CATALOG.md` + `screen-map.json`.
- **Screen ID** — stable key for a screen, used in the spec, the Compose screen,
  the screen-map, and the artifact title in Stitch/Claude Design.
- **Fingerprint** — hash of a screen's spec; lets the agent detect which screens
  changed in a handoff.
- **Handoff bundle** — Claude Design's export (component tree + tokens + specs)
  passed to a coding agent.
- **DESIGN.md** — Google Stitch's open, vendor-neutral design-system format.
- **W3C tokens** — the Design Tokens Community Group JSON format (`tokens.json`).
- **MCP** — Model Context Protocol; servers that let the agent execute actions
  (DB, deploy, PRs, design, browser, docs).
- **User scope / project scope** — where MCP config lives: once-per-machine
  (shared) vs per-repo (e.g. Supabase pinned to a `project_ref`).
- **Secrets mirror** — gitignored local file with secret values (the readable
  source); synced to GitHub Actions (canonical CI store, write-only).
- **Tramo** (domain term inherited from the reference stack) — a time-aware value
  `{ fechaInicio, valor }`; read the active value at a date.
