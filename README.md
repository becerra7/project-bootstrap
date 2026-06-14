# Agentic Delivery Kit

An **agentic, end-to-end software-delivery setup**: take an idea and ship a
product — frontend, backend, auth, payments, design, CI/CD, deploys — with the
**least possible configuration from you**. It's a portable set of skills,
subagents, commands, behaviors, and MCP config that any AI coding agent (Cursor,
Claude Code, Codex, …) can use, plus a self-improvement system so the kit keeps
getting better and stays continuable by any LLM.

> New here? Read `AGENTS.md` (the constitution), then `docs/HOW_IT_WORKS.md`.
> Improving the kit? Use `/improve-kit` (the `kit-maintenance` skill).

## What it gives you

- **One command to start (new):** `/new-project <idea>` scaffolds the whole stack,
  builds a thin end-to-end slice, writes living docs, and hands you a short
  "your turn" checklist.
- **One command to adopt (existing):** `/adopt-project` detects an existing repo's
  stack + features, reverse-documents them into the kit's living docs, then
  `/audit` → `/cleanup` → `/propose-improvements` review it, tidy it, and plan
  what's next — so the kit works on code you already have, not just from zero.
- **A real pipeline:** ideation → architecture → scaffold → design → data+auth →
  (worker) → (payments) → CI/CD → mobile → ship → iterate.
- **Design without drift or lock-in:** a repo-owned design manifest bridged to
  Stitch (fluid, via MCP) or Claude Design (manual), your choice per project.
- **The agent runs things** via MCP (GitHub, Supabase, Cloudflare, Stitch,
  Playwright, Context7, Firebase) — reusable across parallel projects.
- **Living, queryable state** (`/status`) and **safe iteration** (`/iterate-feature`).
- **Tone & efficiency controls:** `/mode`, token-efficiency + multi-agent rules.

## Default stack

KMP + Compose Multiplatform (Android + adaptive web; web-only & React escape
hatch) · Supabase (Postgres + Auth + RLS, Google sign-in) · Cloudflare Pages +
optional Worker (staging + production) · Firebase App Distribution · optional
Stripe · GitHub Actions.

## Install into a project

```bash
# from this kit directory
bin/install.sh --target /path/to/your/project --tool cursor   # or claude | codex | all
# then, inside that project:
#   /onboard        set up MCP + secrets + provision what's automatable
#   /new-project    scaffold a product from an idea (greenfield)
#   /adopt-project  bring an EXISTING codebase into the kit (brownfield)
```

`bin/link.sh <tool>` symlinks the neutral `.agents/` content into `.cursor/`,
`.claude/`, or `.codex/`. Project-level config always overrides the global copy.

## Commands

**Start:** `/new-project` (from an idea) · `/adopt-project` (existing repo)

**Existing-project workflow:** `/adopt-project` · `/audit` · `/cleanup` ·
`/propose-improvements`

**Day-to-day:** `/ideate` · `/design` · `/design-brief` · `/add-feature` ·
`/iterate-feature` · `/add-screen` · `/status` · `/onboard` · `/setup-infra` ·
`/ship` · `/mode` · `/improve-kit`

**Across many repos:** `/across-repos` — one agent surveys (and, when asked, acts
on) a set of your GitHub repos at once, via the user-scope GitHub MCP server.

## Adopt an existing project

The kit isn't only for greenfield. Point it at a repo you already have:

```text
/adopt-project          detect stack + features, reverse-document into docs/STATE.md
                        + docs/features/*, reconcile infra/secrets, hand back a report
/audit                  severity-ranked findings → docs/AUDIT.md (read-only)
/cleanup                safe, behaviour-preserving fixes from the audit
/propose-improvements   prioritised roadmap → docs/ROADMAP.md, each item routed
```

After adoption the existing project uses the same day-to-day commands
(`/status`, `/add-feature`, `/iterate-feature`, …) as a bootstrapped one.

## How design works (the part that usually rots)

The repo's **design manifest** (`design/DESIGN.md` + `tokens.json` + per-screen
specs keyed by screen ID + `CATALOG.md` + `screen-map.json`) is the source of
truth. Visual tools are viewers:

- **Stitch** (`tool: stitch`): the agent renders/updates screens via MCP, shows
  you the image in chat, iterates, then maps to Compose — fully in-conversation.
- **Claude Design** (`tool: claude`): the agent writes the prompt pack and, on
  handoff, applies **only the changed screen** (matched by screen-ID title +
  fingerprint diff), so a bundle with all screens never causes drift.
- **none**: agent-only.

This keeps the "see and iterate on designs" benefit, doesn't burn the coding
agent's tokens on rendering, and never forces a framework switch.

## Secrets

One home per secret: a gitignored local mirror (`secrets/secrets.local.env`,
readable) → pushed to **GitHub Actions** (canonical CI store) via
`bin/secrets-sync.sh`; a committed names-only manifest is the index. Nothing
secret is committed.

## Make it its own GitHub repo

This kit currently lives inside a host repo. To extract it into a standalone repo
**with history**:

```bash
bin/publish-as-new-repo.sh agentic-delivery-kit <your-github-owner>
```

(Uses `git subtree split` + `gh`. A cloud agent can't create the repo for you, so
run this once locally.)

## Repo layout

See `docs/ARCHITECTURE.md` for the full file map. Canonical content is in
`.agents/`; knowledge is in `docs/`; MCP config in `mcp/`; scripts in `bin/`.

## License

MIT — see `LICENSE`.
