---
name: supabase-backend
description: >-
  Sets up the Supabase backend for a project: Postgres schema + migrations, Row
  Level Security (RLS) policies, Google sign-in via Supabase Auth, storage, and
  the client wiring (supabase-kt for KMP, supabase-js for web-react). Use when
  adding a database, authentication, user data persistence, RLS policies, or
  Google login to a project. Covers the local migrations workflow and the exact
  human-only steps (creating the project, OAuth credentials).
paths:
  - "supabase/**"
  - "**/datasource/**"
  - "**/dto/**"
---

# Supabase backend — schema, RLS, and Google auth

Supabase is the default backend: Postgres + Auth + RLS + Storage, with the
client talking directly to it for plain CRUD. Add a Cloudflare Worker only when
you need server-held secrets or server logic (see `cloudflare-deploy`).

## Migrations workflow (everything in git)

Keep all schema in `supabase/migrations/NNN_description.sql`, applied in order.
Never click-edit the schema in the dashboard as the source of truth.

```
supabase/
  migrations/
    001_init.sql          # tables + RLS + triggers
    002_<feature>.sql
  config.toml             # local Supabase CLI config (optional)
```

Local dev / apply:

```bash
supabase start                 # local stack (Docker)
supabase db reset              # re-apply all migrations locally
supabase db push               # apply to the linked remote project
# or paste the SQL into the dashboard SQL editor for the first manual setup
```

## RLS — the non-negotiable pattern

Every user-owned table follows the same shape (this is the proven pattern):

```sql
alter table public.<table> enable row level security;
create policy "user crud own rows" on public.<table>
    for all
    using      (auth.uid() = user_id)
    with check (auth.uid() = user_id);
```

- `user_id` is `uuid` referencing `auth.users(id) on delete cascade`.
  (If a legacy table stores it as `text`, compare with `auth.uid()::text`.)
- **Writes that must be trusted** (token grants, payment credits, anything the
  client must not forge) go through `security definer` functions, never direct
  table writes. See the Stripe ledger pattern in `stripe-payments`.
- Default-deny: RLS on + only the policies you explicitly add.

Use `assets/migration_template.sql` as the starting point for any new table.

## Google sign-in (Supabase Auth)

Agent does:
- Enable the Google provider in `supabase/config.toml` (or document it).
- Wire the client: `auth-kt` (KMP) / `@supabase/supabase-js` (web-react) with
  `signInWith(Google)`. On web, the OAuth redirect returns to the app origin;
  add the redirect URLs to the Supabase Auth settings list.
- Add an `AuthRepository` interface + Supabase-backed impl (see
  `scaffold-frontend` layering) exposing `currentUser`, `signInWithGoogle`,
  `signOut`, and an auth-state `Flow` the `RootViewModel` observes.

Human must do (goes in `SECRETS.md`):
- Create the Supabase project; copy the **Project URL** + **publishable
  (anon) key** → GitHub secrets `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`.
- In Google Cloud Console: create an **OAuth 2.0 Client ID** (Web), set the
  authorized redirect URI to the Supabase callback
  (`https://<ref>.supabase.co/auth/v1/callback`), copy the **client id +
  secret** into Supabase → Authentication → Providers → Google.
- Add the app's own origins (staging + prod Cloudflare Pages URLs, and
  `http://localhost:*` for dev) to Supabase Auth → URL Configuration.

## Client config (no secrets in code)

Expose `SUPABASE_URL` + `SUPABASE_PUBLISHABLE_KEY` via a generated config object
(build-time injected — see `scaffold-frontend`'s `composeApp.build.gradle.kts`).
The publishable/anon key is safe to ship to clients **because RLS protects the
data**; the service-role key is NEVER shipped and only lives in Workers/edge
functions secrets.

## DTO ⇄ domain rule

Supabase rows are `@Serializable` DTOs in `data/remote/dto/` using exact column
names (snake_case). Map to platform-free domain models before they cross into
`domain/`. See the feature recipe in `scaffold-frontend`.

## Edge functions (optional)

For logic that needs the service role but is too small for a Worker, use
Supabase Edge Functions (Deno) under `supabase/functions/<name>/`. The Stripe
webhook → `credit_tokens` flow is a typical use.
