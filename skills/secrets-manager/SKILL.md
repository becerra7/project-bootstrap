---
name: secrets-manager
description: >-
  Manages all credentials with "one home per secret" and no duplication across
  frameworks. GitHub Actions secrets are the canonical store for CI/runtime; a
  gitignored local mirror is the readable source you can "read back"; a committed
  manifest (names only) is the index. Use when setting up secrets, syncing them
  to GitHub, checking what's missing, wiring local MCP auth, or configuring a
  Playwright test user for login-gated screens.
paths:
  - "secrets/**"
  - "SECRETS.md"
---

# Secrets — one home per secret, readable locally, canonical in GitHub

The model reconciles "keep it in GitHub only / no duplication" with "I want to
read it back" (GitHub Actions secrets are **write-only** — they cannot be read
back via API once set).

```
secrets/
  secrets.local.env       # GITIGNORED. The readable source of truth (values).
  secrets.manifest.md     # committed. Names + where used + scope. NO values.
SECRETS.md                # the human "your turn" checklist (manual steps only)
```

Three roles, one value each:
- **`secrets/secrets.local.env`** (gitignored): your editable, **readable** copy.
  This is "read back". Set values here once.
- **GitHub Actions secrets**: the canonical store CI/runtime consumes. Written
  FROM the local mirror via `gh secret set`. Never read back; never duplicated
  into other `.env`s.
- **`secrets/secrets.manifest.md`** (committed, names only): the index — every
  expected secret, what uses it, and its scope.

## Secret scopes (decides where it lives)

| Scope | Examples | Home |
| ----- | -------- | ---- |
| **CI / runtime** | `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`, `FIREBASE_APP_ID`, `FIREBASE_SERVICE_ACCOUNT` | local mirror → pushed to **GitHub Actions** only |
| **Local MCP auth** | `GITHUB_PAT`, `SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_REF`, `STITCH_API_KEY`, `STRIPE_SECRET_KEY` | local mirror → exported to your shell/keychain (used by MCP); these cannot live in Actions because the local agent must read them |
| **Test** | `E2E_TEST_EMAIL`, `E2E_TEST_PASSWORD` (staging test user) | local mirror (+ Actions if e2e runs in CI) |

## Workflow

1. The agent generates `secrets/secrets.manifest.md` (from the template) listing
   every secret the project needs and its scope.
2. You fill values **once** in `secrets/secrets.local.env` (gitignored).
3. **Sync up:** `bin/secrets-sync.sh` reads CI-scoped vars and runs
   `gh secret set` for each → GitHub Actions. (Write is allowed; read isn't.)
4. **Check:** `bin/secrets-check.sh` compares the manifest ↔ local mirror ↔
   `gh secret list` (names only) and reports anything missing or stale.
5. Local-MCP vars: source the mirror into your shell (or load into the OS
   keychain) so the MCP servers can read them.

## Rules

- **Never commit values.** `secrets/secrets.local.env` and any `.env` are
  gitignored. Only the manifest (names) is committed.
- **One home per secret.** Local mirror is the source; GitHub Actions is the
  deploy target; the manifest is the map. Do not scatter copies into
  per-framework `.env`s.
- Optional hardening: OS keychain or `git-crypt` for the local mirror.

## Playwright test user (login-gated screens)

To let Playwright screenshot/e2e authenticated screens without automating Google:
- Use a **dedicated staging test user**. Prefer email/password auth in staging,
  or mint a Supabase session programmatically (email+password / admin JWT) and
  inject it into `localStorage` → save as `storageState.json`, reused by all runs
  (`assets/playwright.auth.setup.ts.tmpl`). No re-login per run.
- Test creds (`E2E_TEST_*`) live in the secrets mirror (staging only).

See `mcp` (Playwright) and `github-cicd` (CI secrets) for the surrounding wiring.
