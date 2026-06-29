#!/usr/bin/env bash
# Update the vendored Agentic Delivery Kit in THIS project from the kit's source
# repo. Syncs ONLY kit-owned paths; never touches product code, state, design,
# migrations, or secrets. Review the diff, then commit. The pin is KIT_VERSION.
#
#   bin/update-kit.sh                 # update from default remote @ main
#   bin/update-kit.sh v0.3.0          # update to a specific tag / branch / sha
#   KIT_REMOTE=https://github.com/owner/repo.git bin/update-kit.sh
set -euo pipefail

REMOTE="${KIT_REMOTE:-https://github.com/becerra7/project-bootstrap.git}"
REF="${1:-main}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Kit-owned paths (overwritten on update). Everything else is product-owned and
# is left untouched: README.md, docs/STATE.md, docs/features/, docs/CHANGELOG.md,
# design/, supabase/, .github/, app code, secrets/, KIT root CHANGELOG.md.
KIT_PATHS=(
  ".agents"
  "bin"
  "mcp"
  "AGENTS.md"
  "CLAUDE.md"
  "KIT_VERSION"
  ".claude/settings.json"
  "docs/HOW_IT_WORKS.md"
  "docs/DECISIONS.md"
  "docs/ARCHITECTURE.md"
  "docs/GLOSSARY.md"
)

command -v git >/dev/null || { echo "git is required"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Fetching kit from $REMOTE @ $REF ..."
if git clone --quiet --depth 1 --branch "$REF" "$REMOTE" "$TMP/kit" 2>/dev/null; then
  :
else
  git clone --quiet "$REMOTE" "$TMP/kit"
  git -C "$TMP/kit" checkout --quiet "$REF"
fi

OLD_VER="$(cat "$ROOT/KIT_VERSION" 2>/dev/null || echo "unknown")"
NEW_VER="$(cat "$TMP/kit/KIT_VERSION" 2>/dev/null || echo "unknown")"

for p in "${KIT_PATHS[@]}"; do
  src="$TMP/kit/$p"
  dst="$ROOT/$p"
  if [[ ! -e "$src" ]]; then echo "  skip (not in source): $p"; continue; fi
  mkdir -p "$(dirname "$dst")"
  if [[ -d "$src" ]]; then
    rm -rf "$dst"; cp -R "$src" "$dst"
  else
    cp "$src" "$dst"
  fi
  echo "  synced: $p"
done

echo
echo "Kit updated: $OLD_VER -> $NEW_VER"
echo "Next:"
echo "  1. Review changes:  git diff"
echo "  2. Reconcile anything in this project that relied on changed kit behaviour."
echo "  3. Commit:          git add -A && git commit -m \"chore: update kit to $NEW_VER\""
