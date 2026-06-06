# Setup infra

Provision and wire all infrastructure for the project, and produce the exact
human-only checklist. Use the `release-engineer` subagent.

Do, in order:
1. Supabase (`supabase-backend`): migrations + RLS + Google auth wiring + client
   config injection.
2. Cloudflare (`cloudflare-deploy`): `wrangler.toml` for Pages; if a Worker is
   needed, the two-environment (`staging`/`production`) Worker config.
3. GitHub CI/CD (`github-cicd`): branch model + `ci.yml`, `deploy-web.yml`,
   `deploy-mobile.yml` workflows from templates, parameterized with the real
   project name.
4. Firebase App Distribution (`firebase-distribution`): mobile deploy step +
   tester group.
5. Stripe (`stripe-payments`) only if payments are enabled.

Finish by (re)generating `SECRETS.md` — the single ordered list of browser-only
steps and the exact GitHub secret names to paste into. Clearly separate "done by
agent" from "your turn".
