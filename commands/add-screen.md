# Add screen

Add or redesign a screen WITHOUT causing design drift. Use the `design-engineer`
subagent and the `design-bridge` skill.

Steps:
1. Check `design/CATALOG.md` first — reuse existing components; prefer a new
   variant over a near-duplicate.
2. Compose the screen from semantic tokens + catalog components only. No raw
   hex, no magic spacing/radius, no per-screen typography.
3. If something genuinely new is needed:
   - new value → add a semantic token (and primitive if needed) to
     `design/tokens.json`, regenerate the theme, then use it;
   - new pattern → add a component to the catalog, implement once under
     `components/`, document it, and render it in the Style Gallery.
4. If I paste a Claude Design mock, extract its decisions into tokens/catalog
   entries (reuse existing tokens where possible) rather than copying inlined
   values.
5. Verify in the Style Gallery and at Compact + Expanded sizes, light + dark.
6. Run the anti-drift checklist.

The text after the command name describes the screen.
