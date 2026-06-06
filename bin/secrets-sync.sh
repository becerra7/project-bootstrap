#!/usr/bin/env bash
# Push CI-scoped secrets from the local mirror to GitHub Actions (write-only).
# Reads secrets/secrets.local.env; pushes only the vars listed on the `#ci:` line.
# Requires: gh (authenticated), run inside the target git repo.
set -euo pipefail

MIRROR="${1:-secrets/secrets.local.env}"
[[ -f "$MIRROR" ]] || { echo "No mirror at $MIRROR"; exit 1; }

CI_VARS=$(grep -E '^#ci:' "$MIRROR" | head -1 | sed 's/^#ci:[[:space:]]*//')
[[ -n "$CI_VARS" ]] || { echo "No '#ci:' list in $MIRROR; nothing to push."; exit 0; }

# shellcheck disable=SC1090
set -a; source "$MIRROR"; set +a

for name in $CI_VARS; do
  val="${!name:-}"
  if [[ -z "$val" ]]; then echo "  skip (empty): $name"; continue; fi
  printf '%s' "$val" | gh secret set "$name" --body - >/dev/null
  echo "  pushed: $name"
done
echo "Done. CI secrets are in GitHub Actions (not readable back; that's expected)."
