---
name: github-cicd
description: >-
  Establishes the git branching model and GitHub Actions CI/CD for a project:
  the main/staging branch strategy, short-lived feature branches and PRs, web
  deploy to Cloudflare Pages (staging + production), and the secrets checklist
  the human must fill in. Use when setting up version control conventions,
  CI/CD pipelines, deploy workflows, environments, or documenting required
  repository secrets. Pairs with cloudflare-deploy and firebase-distribution.
paths:
  - ".github/**"
  - "SECRETS.md"
---

# Git + GitHub Actions CI/CD

## Branching model

- **`main`** — production. Protected. Deploys to the production environment.
- **`staging`** — long-lived integration branch → staging environment.
- **`feature/<slug>`** — short-lived feature/fix branches. Open a PR into
  `staging` (or `main` for hotfixes). Squash-merge. Delete after merge.

See the `conventions` skill for commit message + PR conventions.

## Workflows (manual-dispatch by default)

The proven, low-surprise default is **`workflow_dispatch`** with an environment
picker — builds run when you ask, not on every push (saves CI minutes and avoids
half-finished branches deploying). Promote to push-triggered later if desired.

Generate from the asset templates:

- `assets/deploy-web.yml.tmpl` — build the web bundle and deploy to Cloudflare
  Pages; an `environment` input (`staging`/`production`) maps to the Cloudflare
  branch (`staging`/`main`).
- `assets/deploy-mobile.yml.tmpl` — build the Android debug APK and push it to
  Firebase App Distribution (see `firebase-distribution`).
- `assets/ci.yml.tmpl` — on every PR: build + lint/test (no deploy). This is the
  gate that keeps `staging`/`main` green.

Place them in `.github/workflows/`. They expect the secrets below.

## Required GitHub secrets (→ also recorded in `SECRETS.md`)

| Secret | Used by | Who provides |
| ------ | ------- | ------------ |
| `SUPABASE_URL` | web + mobile build | Supabase project settings |
| `SUPABASE_PUBLISHABLE_KEY` | web + mobile build | Supabase project (anon key) |
| `CLOUDFLARE_API_TOKEN` | web deploy | Cloudflare token (Pages+Workers edit) |
| `CLOUDFLARE_ACCOUNT_ID` | web deploy | Cloudflare dashboard |
| `FIREBASE_APP_ID` | mobile deploy | Firebase project (Android app) |
| `FIREBASE_SERVICE_ACCOUNT` | mobile deploy | Firebase service-account JSON (contents) |
| `STRIPE_*` (optional) | worker/webhook | Stripe dashboard |

Always (re)generate `SECRETS.md` from `assets/SECRETS.md.tmpl` so the human has
one ordered list of "go create this, paste it here" steps. This is the bulk of
the user's manual work — keep it tight and link every step.

## Build/caching notes (KMP/wasm)

- JDK 17 + Gradle (pin the version). Use `gradle/actions/setup-gradle`.
- Cache `~/.konan`, `~/.gradle/nodejs`, `~/.gradle/yarn`, `.kotlin`,
  `shared/build`, `composeApp/build` (excluding `dist`/`outputs`) keyed on the
  build files + branch — this is what keeps wasm builds fast.
- Pass Supabase config to the build via env (`SUPABASE_URL`,
  `SUPABASE_PUBLISHABLE_KEY`), never hardcoded.

## Branch protection (recommended, human sets in repo settings)

- `main` + `staging`: require PR, require the `ci` workflow to pass, no force-push.
