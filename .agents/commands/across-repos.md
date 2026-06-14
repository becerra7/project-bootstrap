# Across repos

Run one agent across several of my GitHub repos — survey their state and, when I
ask, apply the same change to each. Uses the user-scope GitHub MCP server (one
account-wide token, no per-repo setup).

Use the `multi-repo-ops` skill:

1. **Resolve the target set** of repos (an owner/org, a list I give, or a filter),
   show me the concrete list, and treat it as the allowlist for the run.
2. **Fan out one read-only worker per repo** (`parallel-agents`) for the requested
   check — CI/PR status, a missing file/workflow, a `code-audit` pass, dependency
   or leaked-secret scan, stack/version drift — keeping each worker to its own repo.
3. **Aggregate** into a single per-repo table: status, findings, recommended
   action. This survey is the default deliverable.
4. **Act only if I ask**, per repo, on a `feature/<slug>` branch + one focused PR,
   respecting each repo's own conventions. Confirm the batch before any writes and
   report the PR links.

Default is read-only/report; writes are opt-in, allowlisted, and one PR per repo.
The text after the command name is the task + which repos (e.g. "audit all repos
in <org> for leaked secrets", "open a PR adding CI to my repos missing it").
