# Onboard

Set up everything a project needs to run, automating all that's automatable and
giving me a verified checklist of the rest. Use `mcp`, `secrets-manager`,
`supabase-backend`, `cloudflare-deploy`, `firebase-distribution`.

1. **MCP (once per machine, shared):** check user-scope servers exist (GitHub,
   Cloudflare, Stitch, Playwright, Context7, Firebase) from `mcp/mcp.user.json`;
   help me add any missing ones. Then write this project's `.mcp.json` (Supabase,
   project-scoped) and the env vars it needs.
2. **Provision what's automatable** via CLIs (no dashboards where avoidable):
   `firebase`/`gcloud` for the Firebase project/app/service-account; Supabase &
   Cloudflare via their CLIs/MCP. (Optionally offer Stripe Projects as a shortcut,
   but don't depend on it.)
3. **Secrets:** generate `secrets/secrets.manifest.md`; I fill
   `secrets/secrets.local.env` once; run `bin/secrets-sync.sh` to push CI secrets
   to GitHub Actions; source local-MCP vars into my shell.
4. **Verify:** ping each MCP/CLI and run `bin/secrets-check.sh`; show a green/red
   checklist of what's live vs missing.
5. **Remaining manual steps:** list only the truly human-only items (Google OAuth
   consent screen, anything needing my account login), each with a direct link.

End with the verified status and the short "your turn" list.
