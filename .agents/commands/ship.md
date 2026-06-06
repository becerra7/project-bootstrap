# Ship

Cut a release. Use the `release-engineer` subagent and the `github-cicd` skill.

Default flow (ship to staging unless I say production):
1. Ensure the working branch is a `feature/<slug>` branch with a clean, building
   tree (both targets compile; CI green).
2. Commit logically-separated changes with clear messages (`conventions`).
3. Push and open/update a PR into `staging` (or `main` for a hotfix). Summarize
   what changed.
4. After merge, trigger the deploy:
   - Web → run **Deploy Web** with the chosen environment (staging→`staging`,
     production→`main` Cloudflare branch).
   - Mobile → run **Deploy Mobile** (APK → Firebase testers) when an Android
     build should go out.
5. If a deploy needs a human-held secret that isn't set yet, stop and output the
   precise step + the missing secret name from `SECRETS.md` instead of failing.

Report: what shipped, to which environment, and any remaining human step.

Text after the command name may specify the environment (e.g. `/ship production`).
