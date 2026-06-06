# Design brief

Produce a self-contained, tool-neutral snapshot to hand to an external design
agent (Stitch, Claude Design, or any LLM). Use `design-bridge` + `project-docs`.

Generate a single markdown brief containing:
1. Product + target users + the specific use case / change being requested.
2. Existing screens and their purpose, current IA/navigation (from the design
   manifest `design/screens/*` + `screen-map.json`).
3. The design system: `design/DESIGN.md` + `design/tokens.json` + `CATALOG.md`
   components, and brand constraints.
4. Explicit "what is fixed vs. open to redesign", and acceptance criteria.
5. The exact screen ID(s) involved (so a handoff can be targeted per-screen).

Tailor the output to the target:
- generic markdown (default) — paste into any tool/agent;
- Stitch — also offer to push via the Stitch MCP and/or refresh `DESIGN.md`;
- Claude Design — phrase as a paste-ready prompt that points at the repo and
  titles each artifact with its screen ID, plus what to hand back.

Save the brief under `design/prompts/` so it's reusable. Text after the command
describes the use case/change and (optionally) the target tool.
