#!/usr/bin/env bash
# Extract this kit into its OWN GitHub repo, preserving its commit history.
# Run from the repo that currently contains agentic-delivery-kit/ (e.g. myFinance).
#
#   bin/publish-as-new-repo.sh <new-repo-name> [github-owner]
#
# Requires: git, gh (authenticated). Creates the repo and pushes the kit's history.
set -euo pipefail

NAME="${1:?usage: publish-as-new-repo.sh <new-repo-name> [owner]}"
OWNER="${2:-}"
PREFIX="agentic-delivery-kit"

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "1/4 Splitting $PREFIX/ into a branch with its own history…"
git subtree split --prefix="$PREFIX" -b "${NAME}-export"

WORK="$(mktemp -d)"
echo "2/4 Materializing into $WORK…"
git clone -q "$ROOT" "$WORK" --branch "${NAME}-export" --single-branch
cd "$WORK"
git checkout -q --orphan main 2>/dev/null || git branch -m main
# (subtree branch already has only kit content at repo root)

echo "3/4 Creating the GitHub repo and pushing…"
TARGET="$NAME"; [[ -n "$OWNER" ]] && TARGET="$OWNER/$NAME"
if command -v gh >/dev/null 2>&1; then
  gh repo create "$TARGET" --private --source=. --remote=origin --push
else
  echo "  gh not found. Create the repo manually, then:"
  echo "    cd $WORK && git remote add origin <url> && git push -u origin main"
fi

echo "4/4 Done. New repo content is in: $WORK"
echo "Tip: in the original repo you can now 'git rm -r $PREFIX' once the new repo is verified."
