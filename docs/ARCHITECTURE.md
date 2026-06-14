# Architecture — file map of the kit

Where everything lives, so you can find the right file to change. Pair with
`HOW_IT_WORKS.md` (mental model) and `kit-maintenance` (what to update on change).

```
agentic-delivery-kit/
├── AGENTS.md                  # universal constitution (read first)
├── README.md                  # what it is + how to use/install
├── CHANGELOG.md               # dated log of every change
├── LICENSE
├── .gitignore                 # ignores secrets mirror, build junk
├── docs/
│   ├── HOW_IT_WORKS.md        # full mental model
│   ├── DECISIONS.md           # ADR-style rationale/history
│   ├── ARCHITECTURE.md        # this file
│   └── GLOSSARY.md            # terms
├── .agents/                   # CANONICAL, tool-neutral content
│   ├── skills/                # knowledge + procedures (load on demand)
│   │   ├── project-bootstrap/ #   orchestrator — greenfield (new project from idea)
│   │   ├── project-adoption/  #   orchestrator — brownfield (adopt an existing repo)
│   │   ├── code-audit/        #   review existing code → severity-ranked docs/AUDIT.md
│   │   ├── codebase-cleanup/  #   safe, behaviour-preserving cleanups from the audit
│   │   ├── improvement-planning/ # findings+features → routed docs/ROADMAP.md
│   │   ├── multi-repo-ops/    #   survey/act across MANY GitHub repos (user-scope MCP)
│   │   ├── scaffold-frontend/ #   KMP/Compose (or web) skeleton (+assets, references)
│   │   ├── design-bridge/     #   design manifest ↔ Stitch/Claude (+assets)
│   │   ├── supabase-backend/  #   schema, RLS, Google auth (+assets)
│   │   ├── cloudflare-deploy/ #   Pages + Worker, 2 envs (+assets)
│   │   ├── github-cicd/       #   branches, workflows, SECRETS (+assets)
│   │   ├── firebase-distribution/
│   │   ├── stripe-payments/
│   │   ├── feature-lifecycle/ #   iterate/refactor/deprecate
│   │   ├── project-docs/      #   living STATE + feature docs (+assets)
│   │   ├── product-ideation/  #   use-case generation (internal+external)
│   │   ├── mcp/               #   MCP setup/scopes/routing (+assets: playwright auth)
│   │   ├── secrets-manager/   #   one-home-per-secret (+assets)
│   │   ├── conventions/       #   clean-arch + tokens + git guardrails
│   │   ├── token-efficiency/  #   cost best-practices
│   │   ├── parallel-agents/   #   multi-agent orchestration
│   │   └── kit-maintenance/   #   how to change THIS kit (self-improvement)
│   ├── subagents/             # product-architect, scaffolder, design-engineer,
│   │                          #   release-engineer, code-auditor (read-only review)
│   ├── commands/              # new-project, adopt-project, audit, cleanup,
│   │                          #   propose-improvements, across-repos, ideate, design,
│   │                          #   design-brief, add-feature, iterate-feature, add-screen,
│   │                          #   status, onboard, setup-infra, ship, mode, improve-kit
│   └── behaviors/             # terse, explain, ship-fast, careful-review, architect
├── mcp/
│   ├── mcp.user.json          # user-scope servers (shared across projects)
│   └── mcp.project.json       # project-scope (Supabase)
└── bin/
    ├── link.sh                # symlink .agents into .cursor/.claude/.codex of a target
    ├── install.sh             # install the kit into a target project
    ├── publish-as-new-repo.sh # extract this dir into its own GitHub repo (history-preserving)
    ├── secrets-sync.sh        # push CI secrets from local mirror to GitHub Actions
    └── secrets-check.sh       # report present/missing secrets
```

## Conventions
- Skill folder name == `SKILL.md` `name`. Commands are plain markdown (filename =
  command). Subagents have frontmatter + system-prompt body.
- Templates live in each skill's `assets/`; longer references in `references/`.
- Placeholders in templates use `{{NAME}}`.
- Adding any top-level dir → update `bin/link.sh` and this map.

## What a NEW project gets (when the kit is used)
The skills generate, in the product repo: the app skeleton, `design/` manifest,
`supabase/migrations`, `.github/workflows`, `wrangler*.toml`, `docs/STATE.md` +
feature docs, `secrets/secrets.manifest.md`, and the MCP config — i.e. the kit
produces the project; it is not the project.

## What an EXISTING project gets (when adopted)
`project-adoption` writes only *derived* state into the existing repo —
`docs/STATE.md` + `docs/features/*` (reverse-documented from the real code),
`docs/AUDIT.md` (`code-audit`), `docs/ROADMAP.md` (`improvement-planning`), and an
opt-in `design/` manifest / MCP / secrets manifest — without touching the app's
own code. Cleanups and changes are separate, reviewable steps (`/cleanup`,
`/iterate-feature`).
