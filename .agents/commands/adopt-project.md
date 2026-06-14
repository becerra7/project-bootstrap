# Adopt project

Bring an existing codebase into the kit — the brownfield counterpart to
`/new-project`. Detect what's here, reverse-document it into the kit's living
state, and hand back a report with next steps. Makes no code changes.

Follow the `project-adoption` skill end to end:

1. **Detect** the real stack, infra, build/run/test reality, and health signals —
   don't assume the kit defaults.
2. **Detect features** by reverse-engineering routes/screens/endpoints/tables into
   a ranked feature index (mark inferred items).
3. **Reverse-document** into `docs/STATE.md` + `docs/features/<feature>.md` (via
   `project-docs`), open `docs/CHANGELOG.md`, and — only if the user opts in and a
   UI exists — seed the `design/` manifest via `design-bridge`.
4. **Reconcile** MCP, secrets, and CI with what already exists (`mcp`,
   `secrets-manager`) — adopt, don't overwrite; flag committed secrets as findings.
5. **Hand back** the adoption report: what this is, a health snapshot, the ordered
   "your turn" human-only list, and the recommended next steps —
   `/audit` → `/cleanup` → `/propose-improvements`.

Honesty rule: the code is the source of truth; never document a feature, test, or
guarantee that isn't really there. After adoption the project uses the same
day-to-day commands as a bootstrapped one.

Anything after the command name is the repo path (default: the current repo)
and/or what the user already knows about it — use it to skip detection you don't
need to redo.
