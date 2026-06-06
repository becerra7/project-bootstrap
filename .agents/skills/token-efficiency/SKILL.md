---
name: token-efficiency
description: >-
  Best practices for spending the fewest model tokens for the most output, across
  any LLM tool. Use when a task is large, context is getting long, or you want to
  work cost-effectively. Covers context hygiene, skills/docs as compressed memory,
  using MCP/CLI instead of re-reading, subagent isolation, and model selection.
---

# Token efficiency — maximum output per token

Token cost is a first-class constraint. Apply these by default.

## Context hygiene
- **Read once.** Don't re-read files you've already seen; rely on notes and on
  `docs/STATE.md` / feature docs as compressed memory of project state.
- **Read narrowly.** Open the specific file/section you need (search first), not
  whole trees. Prefer `STATE.md` → the one relevant feature doc → the few code
  files it names.
- **Don't paste large blobs** into the conversation; reference paths.

## Use skills + docs as compressed knowledge
- Skills load **on demand** by description — keep the always-on context small and
  let the agent pull a skill only when relevant. Don't stuff everything into one
  giant instruction file.
- Keep `docs/STATE.md` and feature docs current so the agent never re-derives the
  project state from scratch (the `project-docs` contract pays for itself here).

## Prefer execution over reading
- Use **MCP/CLI to fetch facts** (DB schema via Supabase MCP, CI status via GitHub
  MCP, current APIs via Context7) instead of reading large files or guessing.
- Use **Context7** before writing integration code to avoid wrong-API rework.

## Isolate big subtasks in subagents
- Hand large or noisy subtasks (wide search, a self-contained feature, a refactor)
  to a **subagent** so its intermediate context doesn't bloat the main thread; the
  main agent gets back only the result. (See `parallel-agents`.)

## Design where it's cheap
- Do visual design in Stitch/Claude Design (their token budgets), not by having
  the coding agent generate screen HTML. The agent consumes the result. (See
  `design-bridge`.)

## Model selection
- Use a **cheaper/faster model** for mechanical work (renames, boilerplate,
  formatting, simple edits) and a **stronger model** for architecture, design,
  and tricky debugging. Match the model to the task, per subagent.

## Output discipline
- Small diffs and commits; don't regenerate whole files for a one-line change
  (use targeted edits). Summarize concisely.

Pairs with: `parallel-agents`, `project-docs`, `mcp`, `design-bridge`, and the
behavior presets (`terse` mode).
