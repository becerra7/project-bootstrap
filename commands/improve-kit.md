# Improve kit

Change or extend THIS kit (the agentic-delivery-kit) safely and traceably. Use
the `kit-maintenance` skill.

1. Orient: read `docs/HOW_IT_WORKS.md`, `docs/ARCHITECTURE.md`,
   `docs/DECISIONS.md`, and `CHANGELOG.md`. Don't silently contradict a recorded
   decision.
2. Classify the change (skill / command / subagent / behavior / MCP / stack /
   design-secrets-CI model) and follow that checklist in `kit-maintenance` —
   updating every cross-reference so nothing drifts.
3. Verify consistency (skill name == folder, references resolve, JSON valid,
   `bin/link.sh` covers new dirs).
4. Track it: append to `CHANGELOG.md`, add a `docs/DECISIONS.md` entry if it's a
   decision, keep commits small and logical, update `README.md` if user-facing.
5. End with a short trail: what changed, what to check, next steps.

The text after the command describes the improvement.
