---
name: cloudflare-deploy
description: >-
  Sets up Cloudflare hosting: Cloudflare Pages for the web app (with staging +
  production branches) and an optional Cloudflare Worker for server-side logic
  with two environments (staging and production/main). Use when deploying a web
  build, adding a serverless API/backend, configuring wrangler.toml, environment
  separation, or per-environment secrets/vars. Covers the wrangler config, the
  two-environment model, and which secrets the human must add.
paths:
  - "wrangler.toml"
  - "worker/**"
  - "functions/**"
---

# Cloudflare — Pages (web) + Worker (api), two environments

Two distinct products, both on Cloudflare:

- **Pages** — hosts the static web build (the wasmJs / SPA output). Deploys to a
  `staging` branch and a `production` (`main`) branch on the same project.
- **Worker** — optional serverless API for logic that needs server-held secrets
  (Stripe webhook, LLM proxy, signed URLs, cron). Configured with two
  environments in `wrangler.toml`.

Only add a Worker when there is real server-side work. Plain CRUD = client →
Supabase, no Worker.

## Pages

- The build output dir is set in `wrangler.toml` (`pages_build_output_dir`).
  For KMP wasmJs that is `composeApp/build/dist/wasmJs/productionExecutable`.
- Deployment is driven by the GitHub Actions web workflow (see `github-cicd`),
  which maps the chosen environment to a Cloudflare branch:
  - `production` → branch `main`
  - `staging`    → branch `staging`
- The deploy command pattern (already proven):

```bash
npx wrangler@3 pages deploy "<output_dir>" \
  --project-name={{PROJECT}} --branch={{cf_branch}} --commit-dirty=true
```

Human must do (→ `SECRETS.md`):
- Create a Cloudflare account + a Pages project named `{{PROJECT}}`.
- Create an API token (Pages + Workers edit) → GitHub secret
  `CLOUDFLARE_API_TOKEN`; copy the account id → `CLOUDFLARE_ACCOUNT_ID`.
- Map the custom domains: prod domain → `main` branch, `staging.<domain>` →
  `staging` branch.

## Worker — the two-environment model

Use `wrangler.toml` `[env.staging]` / `[env.production]` blocks so the same code
deploys to two isolated Workers with different vars/secrets/routes. See
`assets/wrangler.worker.toml.tmpl`.

```bash
# deploy each environment explicitly
wrangler deploy --env staging
wrangler deploy --env production

# environment-scoped secrets (never in the toml / never in git)
wrangler secret put SUPABASE_SERVICE_ROLE_KEY --env staging
wrangler secret put SUPABASE_SERVICE_ROLE_KEY --env production
wrangler secret put STRIPE_SECRET_KEY --env production
```

Rules:
- **Non-secret config** → `[vars]` per env in `wrangler.toml` (committed).
- **Secrets** → `wrangler secret put ... --env <env>` (never committed).
- Each env has its own route/subdomain and its own Supabase/Stripe credentials
  (use Stripe test keys + a Supabase staging project for `staging`).
- The Worker is the ONLY place the Supabase **service-role** key and Stripe
  **secret** key may live.

## Local dev

```bash
wrangler dev --env staging      # local Worker against staging vars
```

## Pairing with CI

The `github-cicd` skill provides the workflows that build the web app and call
`wrangler pages deploy`, and (optionally) `wrangler deploy --env <env>` for the
Worker, gated on the branch / chosen environment.
