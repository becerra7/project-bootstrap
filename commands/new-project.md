# New project

Bootstrap a brand-new product from scratch with minimal configuration from me.

Follow the `project-bootstrap` skill end to end:

1. Run the short interview (batch all questions, pre-filled with defaults). If I
   said "you decide" or didn't specify, take the defaults and proceed without
   blocking.
2. Use the `product-architect` subagent to produce `docs/ARCHITECTURE.md` and a
   build plan.
3. Scaffold in dependency order via the skills: `scaffold-frontend` →
   `design-bridge` → `supabase-backend` → (`cloudflare-deploy` if a Worker is
   needed) → (`stripe-payments` if payments) → `github-cicd` →
   `firebase-distribution`. Use the `scaffolder`, `design-engineer`, and
   `release-engineer` subagents for their domains.
4. Build one thin end-to-end slice (one screen + one table + Google auth) and
   verify the project builds for Android and Web.
5. Generate `SECRETS.md` and finish with the ordered "Your turn" checklist of
   human-only steps, each with a link.

Anything after the command name is the product idea/pitch — use it to skip
questions I've already answered.
