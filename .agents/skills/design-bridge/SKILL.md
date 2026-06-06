---
name: design-bridge
description: >-
  The design backbone. Maintains a repo-owned design manifest (design system +
  per-screen registry, keyed by stable screen IDs) as the single source of
  truth, and bridges it to external visual tools — Google Stitch (programmatic,
  via MCP) or Claude Design (manual canvas) — chosen per project. Use for any
  design work: defining the visual system, adding or modifying a screen,
  reviewing a look before implementation, integrating a design-tool handoff, or
  keeping the UI consistent as it grows. The agent authors the exact prompts to
  paste into the design tool and tells you precisely what to hand back, and
  targets a single screen even when a handoff contains all of them.
paths:
  - "design/**"
  - "**/theme/**"
  - "**/*Screen.kt"
  - "**/components/**"
---

# Design bridge — the manifest is the source of truth; tools are viewers

The recurring failure of AI-kick-started design is that the visual tool emits
finished screens with inlined values, and the system rots as it grows. We invert
that: **the repo owns a design manifest**; visual tools (Stitch / Claude Design)
read from and write back to it. The coding agent never re-designs from scratch —
it diffs against the manifest and maps approved results to code.

## The manifest (single source of truth, keyed by screen ID)

```
design/
  config.yml             # which tool + options (see assets/config.yml.tmpl)
  DESIGN.md              # the design SYSTEM in Stitch's open, portable format
  tokens.json           # the same tokens in W3C Design Tokens format (machine)
  CATALOG.md            # component library: variants, states, tokens used
  screen-map.json       # maps tool-screen-title  <->  repo screen-id
  prompts/              # reusable, agent-authored prompt templates per task
  screens/
    <screen-id>.md      # per-screen spec: purpose, layout tree, components,
                        #   states, data bindings, fingerprint, last render link
  renders/<screen-id>.png   # latest rendered image (from the tool)
```

- **Screen ID** is the stable key (`dashboard`, `transactions`, …). It is used in
  the screen spec, the Compose screen, the `screen-map.json`, and the title you
  give the artifact in the design tool. Everything is addressable by it.
- Each screen spec stores a **fingerprint** (a hash of its structural spec) so
  the agent can detect exactly which screens changed on a handoff.
- `tokens.json` (W3C) generates the Compose theme; `DESIGN.md` is what Stitch /
  Claude Design ingest. They are kept in sync (one is generated from the other).

## Choosing the tool (at project setup, changeable later)

`design/config.yml` sets `tool: stitch | claude | none`. `/new-project` asks for
it. Read it first and follow the matching flow below. Always keep the objective
in mind: **see/approve the design, change one screen at a time, never drift.**

## Flow A — Stitch (programmatic, fluid)  [`tool: stitch`]

Requires the Stitch MCP (see `mcp` skill). Fully agent-driven, in-conversation:

1. You: "add/modify screen X." The agent updates `design/screens/X.md` +
   `DESIGN.md`/tokens as needed.
2. Agent calls Stitch MCP (`generate_screen_from_text`/update) referencing
   `DESIGN.md`, then `fetch_screen_image` and shows you the PNG inline.
3. You request changes; agent re-calls Stitch and re-shows. Repeat until approved.
4. On approval: `fetch_screen_code`, map to Compose (semantic tokens + catalog
   components), update the screen spec + fingerprint + `screen-map.json`, build.

Per-screen by nature — adding screen #7 later is one call that inherits `DESIGN.md`.

## Flow B — Claude Design (manual canvas, agent-guided)  [`tool: claude`]

Claude Design has no API/round-trip, so the agent makes the manual loop clean and
**per-screen targeted**. For any task, the agent outputs a **prompt pack**:

1. **The prompt to paste** (drafted by the agent, refined with you, saved under
   `design/prompts/`): tells Claude Design to read the repo, the exact screen ID
   to create/modify (and to **title the artifact with that ID**), the relevant
   tokens/components, constraints, and acceptance criteria.
2. **What to do in the tool**: design/tweak on the canvas.
3. **What to hand back**: "Export → Hand off to Claude Code (or download the
   bundle) and bring it here."

### Targeting one screen when the handoff contains all of them

This is the key mechanism. On ingest, the agent does NOT blindly re-apply
everything:

1. **Intent**: you said which screen you changed → the agent looks for that
   screen ID/title first.
2. **Map**: `screen-map.json` resolves tool titles ↔ repo screen IDs. If a title
   is new/ambiguous, the agent asks you to confirm the mapping once, then stores
   it.
3. **Diff**: the agent fingerprints every screen in the bundle and compares to
   the manifest. It applies **only** the screens whose fingerprint changed and
   reports, e.g., "applied `transactions`; 6 screens unchanged, skipped."

So the agent always knows what to look at: **stated intent + screen-ID title +
diff against the manifest**. No drift on untouched screens, no full re-handoff.

## Flow C — agent-only  [`tool: none`]

No visual tool: the agent edits the manifest and implements Compose directly,
describing the layout in text. Useful for small changes or when you don't need a
picture. The optional `assets/preview.html.tmpl` can render a cheap, all-screens
HTML gallery from existing component code for a quick combined look (low cost) —
this is a fallback, not the primary review path.

## Authoring prompts is a first-class output

For Stitch or Claude Design, the agent always produces the **exact prompt** plus
**what to hand back**, tailored to the task (new screen, modify screen, restyle,
new component). Prompts are saved to `design/prompts/<task>.md` so they are
reusable and improve over time. You can ask the agent to "design the prompt"
before you ever open the tool.

## Anti-drift rules (enforced — see also the `conventions` skill)

- Screens use only **semantic tokens + catalog components** — never raw hex,
  magic spacing/radius, or per-screen typography.
- A new value → add a token to `tokens.json`/`DESIGN.md`, regenerate, then use it.
- A new repeated pattern → add a component to `CATALOG.md`, implement once.
- Every screen change updates: the screen spec, its fingerprint, `screen-map.json`
  (if titles changed), the render link, and (via `project-docs`) the feature doc.
- Verify light + dark and Compact (~360dp) + Expanded.

## Standards used (tool-agnostic by design)

- **`DESIGN.md`** — Google Stitch's open, vendor-neutral design-system format
  (also readable by Claude Design and any agent).
- **`tokens.json`** — W3C Design Tokens Community Group format.

Both are portable, so the visual identity survives a tool switch and a framework
switch. Pairs with: `mcp` (Stitch server), `project-docs`, `feature-lifecycle`,
`design-engineer` subagent.
