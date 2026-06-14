# Cleanup

Apply safe, behaviour-preserving cleanups driven by the audit. The invariant:
behaviour identical, code cleaner. Anything that changes behaviour is out — route
it to `/iterate-feature` or `/propose-improvements`.

Use the `codebase-cleanup` skill:

1. Read `docs/AUDIT.md` (the work) and `docs/STATE.md` (stack + conventions).
   Confirm a green build/tests as a safety net; work on a `feature/<slug>` branch.
2. Do the safe, mechanical work — dead code, formatting/lint autofixes, unused
   imports/deps, local renames/structure toward the project's conventions — **one
   concern at a time**.
3. Build + run tests after each batch; if a "safe" change goes red it wasn't safe
   — revert and reclassify it as a roadmap item.
4. Commit per concern with clear imperative subjects; tick the resolved findings
   in `docs/AUDIT.md` and update `docs/STATE.md`/`CHANGELOG.md` via `project-docs`
   if structure changed. Open one focused PR per concern (`conventions`).

Out of scope: logic/API/schema changes, major dependency bumps, perf rewrites,
new features. The text after the command name optionally scopes cleanup to an area.
