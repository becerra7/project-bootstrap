#!/usr/bin/env bash
# Report which secrets are present vs missing across: the local mirror and GitHub
# Actions (names only — values are never read). Run inside the target git repo.
set -euo pipefail

MIRROR="${1:-secrets/secrets.local.env}"
echo "== Local mirror ($MIRROR) =="
if [[ -f "$MIRROR" ]]; then
  while IFS='=' read -r k v; do
    [[ "$k" =~ ^#|^$ ]] && continue
    if [[ -n "${v:-}" ]]; then echo "  set:     $k"; else echo "  MISSING: $k"; fi
  done < "$MIRROR"
else
  echo "  (no mirror file)"
fi

echo "== GitHub Actions secrets (names) =="
if command -v gh >/dev/null 2>&1; then
  gh secret list 2>/dev/null | awk '{print "  "$1}' || echo "  (gh not authed or no repo)"
else
  echo "  (gh CLI not installed)"
fi
echo "Compare against secrets/secrets.manifest.md for completeness."
