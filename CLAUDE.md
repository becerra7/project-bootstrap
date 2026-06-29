# CLAUDE.md — auto-loaded orientation

This repository uses the **Agentic Delivery Kit**. The full operating
constitution is in `AGENTS.md` — read it first. Mental model:
`docs/HOW_IT_WORKS.md`.

The kit wires itself into Claude Code automatically via a **SessionStart hook**
(`.claude/settings.json` → `bin/link.sh claude`), which exposes the kit's
skills, commands, and subagents and writes the project `.mcp.json`. You should
not need to paste any setup message — just say what you want.

## What to do, by situation
- **Start a new product from this template** → `/new-project <your idea>`
  (run `/onboard` first if infra/secrets aren't set up yet).
- **Work on an existing product** (a `docs/STATE.md` exists) → `/status` for the
  current state, then `/add-feature` / `/iterate-feature`.
- **Improve the kit itself** → `/improve-kit` (see `kit-maintenance`).
- **Pull newer kit improvements into this project** → `/update-kit`.

If a slash command isn't registered yet in this session, the commands are plain
markdown in `.agents/commands/` — read the relevant one and follow it directly.

Kit version is in `KIT_VERSION`. Human-only steps (account creation, pasting
secrets, Google OAuth consent) are always surfaced as one ordered checklist —
never buried in prose.
