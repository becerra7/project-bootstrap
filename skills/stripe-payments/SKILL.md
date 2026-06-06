---
name: stripe-payments
description: >-
  Adds payments to a project using Stripe in the project's standard shape:
  Stripe Checkout on the client, a webhook handled by a Cloudflare Worker or
  Supabase edge function, and a SECURITY DEFINER Postgres function that credits
  the user (e.g. a token ledger / entitlement). Use when adding one-time
  purchases, subscriptions, token packs, or any paid feature. For deep Stripe
  API decisions (Checkout vs PaymentIntents, Connect, Billing, security), ALSO
  consult the `stripe-best-practices` skill.
metadata:
  pattern: "Checkout -> webhook(Worker/edge) -> security-definer credit fn -> ledger"
---

# Stripe payments — the standard shape for this stack

This skill defines *how payments fit this architecture*. For Stripe API choices,
restricted keys, and integration security, read the `stripe-best-practices`
skill (it has the authoritative API guidance); this skill wires it into the
Supabase + Cloudflare + clean-architecture pattern.

## The flow (never trust the client for credit)

```
Client (Compose/web)                Worker / Edge fn                 Supabase
─────────────────────               ────────────────                ─────────
1. user taps "Buy"                                                   
2. POST /checkout  ───────────────▶ create Checkout Session
                                    (server-side, secret key)
3. redirect to session.url ◀───────  return session.url
4. user pays on Stripe-hosted page
                                    Stripe ─POST /webhook──▶ verify signature
                                                            on checkout.session.completed
                                                            └─▶ call credit fn ─▶ security definer
                                                                                  inserts ledger row,
                                                                                  bumps balance
5. client re-reads balance ◀──────────────────────────────────────── RLS select
```

Key principles:
- The **client never grants entitlements**. It only starts Checkout and later
  *reads* its (RLS-protected) balance/entitlement.
- The **webhook is the source of truth** for "money received". It must verify
  the Stripe signature, be idempotent (dedupe on `event.id`), and call a
  `security definer` function with the service role.
- Crediting happens in Postgres via a `security definer` function so RLS can
  stay default-deny for clients while the server can write. (See the
  `credit_tokens`/ledger pattern in the example `supabase/schema.sql`.)

## Where the webhook lives

- **Cloudflare Worker** (preferred when a Worker already exists) — add a
  `/webhook` route; `STRIPE_SECRET_KEY` + `STRIPE_WEBHOOK_SECRET` are per-env
  Worker secrets (`--env staging|production`). See `cloudflare-deploy`.
- **Supabase Edge Function** — fine for tiny projects with no Worker; secrets via
  `supabase secrets set`.

Use Stripe **test** mode + keys on `staging`, **live** on `production`.

## Domain modeling (clean architecture)

Follow the standard layering (see `scaffold-frontend`):
- Domain: `Entitlement`/`TokenBalance`, `LedgerEntry`, `Product`/`Pack`.
- Use cases: `StartCheckoutUseCase` (calls the Worker), `GetBalanceUseCase`,
  `ChargeUseCase`/`RefundUseCase` (server-mediated where money is involved).
- A repository interface backed by a Supabase data source (reads balance/ledger)
  and an API data source (calls the Worker's `/checkout`).
- UI: a "Buy" sheet built from design-bridge catalog components; gate the paid feature on
  the balance, with a clear CTA when it hits zero.

## Subscriptions

For recurring billing use Checkout in `subscription` mode + Stripe Billing;
handle `customer.subscription.*` events to flip an `is_active` entitlement row.
Consult `stripe-best-practices` → billing reference before implementing.

## Human must do (→ `SECRETS.md`)

- Create the Stripe account + products/prices.
- Provide `STRIPE_SECRET_KEY` (test+live) and `STRIPE_WEBHOOK_SECRET` as Worker/
  edge secrets per environment.
- Register the webhook endpoint URL in the Stripe dashboard.

## Critical reminders (from stripe-best-practices)

- Prefer a **restricted API key** (`rk_`) over a full secret key.
- Do **not** pass `payment_method_types` (let dynamic payment methods work),
  except Terminal/`card_present`.
- Always use the latest Stripe API version + SDK unless told otherwise.
