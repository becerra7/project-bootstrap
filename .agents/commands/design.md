# Design

Design or change a screen via the repo design manifest + the configured tool.
Use the `design-bridge` skill and the `design-engineer` subagent.

1. Read `design/config.yml` for the chosen tool (`stitch` | `claude` | `none`).
2. Update the manifest for the target screen ID (`design/screens/<id>.md`,
   `DESIGN.md`/`tokens.json` if new tokens/components are needed; reuse first).
3. Follow the flow for the chosen tool:
   - **stitch**: render via the Stitch MCP, show me the image inline, iterate to
     approval, then fetch code and map to Compose.
   - **claude**: give me a prompt pack (exact prompt to paste, what to do, what to
     hand back), titling the artifact with the screen ID. On handoff, apply ONLY
     that screen — match by title via `screen-map.json` and verify by diff;
     report which screens changed vs. skipped.
   - **none**: edit the manifest and implement Compose directly (optional cheap
     all-screens HTML gallery for a combined look).
4. Use only semantic tokens + catalog components. Update the screen spec +
   fingerprint + render link + the feature doc. Verify light/dark + compact/expanded.

Text after the command names the screen and the change.
