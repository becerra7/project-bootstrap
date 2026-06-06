---
name: kit-maintenance
description: >-
  How to safely change and extend THIS kit itself. Use whenever the user asks to
  improve, add to, fix, refactor, or document the agentic-delivery-kit (a new
  skill, command, subagent, MCP server, stack option, behavior preset, or a
  change to the design/secrets/CI model). Tells you what to check, what to update
  across the repo for consistency, and how to track every change so the next
  agent can continue. This is the self-improvement engine.
paths:
  - ".agents/**"
  - "docs/**"
  - "mcp/**"
  - "bin/**"
  - "AGENTS.md"
  - "CHANGELOG.md"
---

# Kit maintenance — change the kit without breaking it

When the request is "improve X / add Y to the kit", follow this. The goal: every
change is consistent across the repo and fully tracked, so any LLM can open the
repo later and continue.

## Step 0 — orient
Read `docs/HOW_IT_WORKS.md` (mental model), `docs/ARCHITECTURE.md` (file map),
`docs/DECISIONS.md` (why things are the way they are), and `CHANGELOG.md` (recent
changes). Don't contradict a recorded decision without adding a new one that
supersedes it.

## Step 1 — classify the change, then update the right places

Use the matching checklist. **A change is not done until every box that applies is
updated** (this is what prevents drift).

### Add / change a SKILL (`.agents/skills/<name>/SKILL.md`)
- [ ] Folder name == frontmatter `name` (lowercase-hyphen).
- [ ] `description` clearly states *when* to use it (that's how it's auto-selected).
- [ ] Cross-link from `project-bootstrap` (the orchestrator's skill table) if it's
      part of the pipeline.
- [ ] Reference it from any related skills/subagents/commands.
- [ ] If it ships templates, put them in the skill's `assets/`.
- [ ] Update `README.md` (skills list) and `docs/ARCHITECTURE.md` (file map).

### Add / change a COMMAND (`.agents/commands/<name>.md`)
- [ ] Plain markdown, no frontmatter; filename == command name.
- [ ] It should delegate to a skill/subagent, not re-specify logic.
- [ ] Add to `README.md` (commands list) and the orchestrator's command list.

### Add / change a SUBAGENT (`.agents/subagents/<name>.md`)
- [ ] Frontmatter `name`/`description`/`model`; body is the system prompt.
- [ ] Reference it from the skills/commands that delegate to it and from
      `parallel-agents` if it's part of orchestration.

### Add a BEHAVIOR preset (`.agents/behaviors/<name>.md`)
- [ ] Add it to the `/mode` command's list and note it never overrides guardrails.

### Add / change an MCP server (`mcp/*.json`)
- [ ] Choose scope (user vs project) per the `mcp` skill; put it in the right file.
- [ ] Use `${env:VAR}`; add the var to `secrets-manager`'s manifest template.
- [ ] Update the routing table in the `mcp` skill and `bin/link.sh` if needed.

### Add a STACK option (new frontend/backend/host/etc.)
- [ ] New or extended skill with templates; update `project-bootstrap` interview
      + defaults; note trade-offs in `docs/DECISIONS.md`.

### Change the DESIGN, SECRETS, or CI model
- [ ] Update the owning skill (`design-bridge` / `secrets-manager` / `github-cicd`)
      AND `AGENTS.md` (the philosophy/sections) AND `docs/DECISIONS.md`.

## Step 2 — verify consistency (run these checks)
- Every skill folder has a `SKILL.md` whose `name` matches the folder.
- Every command/subagent referenced somewhere actually exists (and vice-versa for
  things meant to be discoverable).
- `mcp/*.json` is valid JSON; templates with placeholders are documented.
- `bin/link.sh` covers any new top-level directory.
- No dangling references to renamed/removed items (search the repo).

## Step 3 — track the change (mandatory)
- Append a dated entry to **`CHANGELOG.md`**: what changed + which files.
- Add a **`docs/DECISIONS.md`** entry when the change reflects a *decision*
  (a why/trade-off), so future agents understand intent, not just diff.
- Keep commits small and logical; one concern per commit/PR. Update `README.md`
  if user-facing.

## Step 4 — leave a clean trail
End with a one-paragraph summary: what changed, what to check, and the obvious
next steps — so the next agent (or you) can continue without re-deriving context.

> Honesty rule: if you discover the docs and the code disagree, the code wins —
> fix the docs immediately and note it in the changelog.
