# Architecture — file map of the kit

Where everything lives, so you can find the right file to change. Pair with
`HOW_IT_WORKS.md` (mental model) and `kit-maintenance` (what to update on change).

```
agentic-delivery-kit/
├── AGENTS.md                  # universal constitution (read first)
├── CLAUDE.md                  # auto-loaded orientation for Claude Code (no paste needed)
├── KIT_VERSION                # semver pin of the kit a project is on (/update-kit, /status)
├── README.md                  # what it is + how to use/install
├── CHANGELOG.md               # dated log of every change
├── LICENSE
├── .gitignore                 # ignores secrets mirror, build junk, regenerated tool symlinks
├── .claude/
│   └── settings.json          # SessionStart hook → bin/link.sh claude (auto-wires the kit)
├── docs/
│   ├── HOW_IT_WORKS.md        # full mental model
│   ├── DECISIONS.md           # ADR-style rationale/history
│   ├── ARCHITECTURE.md        # this file
│   └── GLOSSARY.md            # terms
├── .agents/                   # CANONICAL, tool-neutral content
│   ├── skills/                # knowledge + procedures (load on demand)
│   │   ├── project-bootstrap/ #   orchestrator (start here)
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
│   ├── subagents/             # product-architect, scaffolder, design-engineer, release-engineer
│   ├── commands/              # new-project, ideate, design, design-brief, add-feature,
│   │                          #   iterate-feature, add-screen, status, onboard, setup-infra,
│   │                          #   ship, mode, improve-kit
│   └── behaviors/             # terse, explain, ship-fast, careful-review, architect
├── mcp/
│   ├── mcp.user.json          # user-scope servers (shared across projects)
│   └── mcp.project.json       # project-scope (Supabase)
└── bin/
    ├── link.sh                # symlink .agents into .cursor/.claude/.codex of a target
    ├── install.sh             # install the kit into a target project
    ├── update-kit.sh          # sync kit-owned paths into a project from the kit remote (/update-kit)
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

## Distribution & updates (kit-owned vs project-owned)
A product gets the kit by **vendoring** it (GitHub "Use this template" on this
repo, or `bin/install.sh`). A template is a point-in-time copy — it does not stay
linked — so updates are pulled deliberately with `bin/update-kit.sh` (`/update-kit`),
which overwrites only the **kit-owned** paths and records the new `KIT_VERSION`:

- **Kit-owned** (overwritten on update): `.agents/`, `bin/`, `mcp/`, `AGENTS.md`,
  `CLAUDE.md`, `KIT_VERSION`, `.claude/settings.json`, and the kit `docs/*`
  (HOW_IT_WORKS, DECISIONS, ARCHITECTURE, GLOSSARY).
- **Project-owned** (never touched by an update): `README.md`, `docs/STATE.md`,
  `docs/features/`, `docs/CHANGELOG.md`, `design/`, `supabase/`, `.github/`, app
  code, and `secrets/`.

A fresh Claude Code session needs no setup paste: `CLAUDE.md` is auto-loaded and
the `.claude/settings.json` SessionStart hook runs `bin/link.sh claude` to expose
skills/commands/subagents and write `.mcp.json`.
