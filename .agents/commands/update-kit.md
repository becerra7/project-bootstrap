# Update kit

Pull newer Agentic Delivery Kit improvements into THIS project, safely. Use the
`kit-maintenance` skill for context on what the kit owns vs. what the project owns.

Steps:
1. Run `bin/update-kit.sh [ref]` (default ref `main`; pass a tag/branch/sha to
   pin a known version). It syncs only kit-owned paths — `.agents/`, `bin/`,
   `mcp/`, `AGENTS.md`, `CLAUDE.md`, `KIT_VERSION`, `.claude/settings.json`, and
   the kit `docs/*` (HOW_IT_WORKS, DECISIONS, ARCHITECTURE, GLOSSARY) — and never
   touches product code, `docs/STATE.md`, feature docs, `docs/CHANGELOG.md`,
   `design/`, `supabase/`, `.github/`, or `secrets/`.
2. Review `git diff` and summarise what changed for me — especially anything in
   `mcp/`, `bin/`, or CI/secrets-related skills that affects how the project
   builds or deploys.
3. If the project relied on kit behaviour that changed, reconcile it so the tree
   stays green.
4. Commit with `chore: update kit to <version>`.

The default source remote is the kit's repo; override with `KIT_REMOTE=<git-url>`
(e.g. once the kit is published as its own standalone repo). Anything after the
command name is the ref to update to.
