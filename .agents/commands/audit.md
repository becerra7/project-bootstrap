# Audit

Review the codebase and produce a prioritised, severity-ranked findings report.
Read-only — it diagnoses, it doesn't change code.

Use the `code-audit` skill:

1. Read `docs/STATE.md` for the stack + the project's own conventions (or do a
   quick detection pass if it's not adopted yet). Review against the project's
   conventions; apply the kit `conventions` rules only where the stack matches.
2. Review across the lenses — correctness/bugs, security, architecture &
   maintainability, dependencies, tests/CI, performance-where-it-bites. **Run**
   the project's build/tests/linter/dependency-audit/secret-scan where they exist
   and fold the results in (observed vs inferred).
3. For a large repo, fan out read-only `code-auditor` subagents by area/lens with
   non-overlapping ownership, then merge and de-duplicate (`parallel-agents`).
4. Write `docs/AUDIT.md`: summary + counts, findings grouped P0→P3 (each with
   evidence `file:line`, why it matters, and a fix route), what you ran vs read,
   and a suggested order of attack. Link it from `docs/STATE.md`.

Hand the safe/mechanical findings to `/cleanup` and the larger ones to
`/propose-improvements`. The text after the command name optionally scopes the
audit to an area or a single lens.
