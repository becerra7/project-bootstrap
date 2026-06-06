# Iterate feature

Change/improve/extend an EXISTING feature (not a new one). Use the
`feature-lifecycle` skill.

Steps:
1. Load current state first: read `docs/features/<feature>.md` and `docs/STATE.md`.
   If the feature has no doc, reverse-document it before changing anything.
2. State the change in one sentence; confirm what stays the same.
3. If the UI changes, run `/design` and get the new look approved before
   editing Compose.
4. Change in dependency order (domain → use case → repo/datasource + new
   migration if schema changes → mapper → ViewModel/UiState → Composable),
   preserving behaviour you're not intentionally changing.
5. Build both targets; keep the tree green; one feature per branch/PR.
6. Update the record: feature doc (status, what changed, code map, preview link,
   data model) + `docs/STATE.md` row + `docs/CHANGELOG.md` entry. Not done until
   the docs match.

The text after the command name names the feature and the desired change.
