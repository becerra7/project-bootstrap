#!/usr/bin/env bash
# Install the kit into a target project: vendor (copy) the kit, then link it into
# your tool. Use --link to symlink the kit instead of copying (auto-updates).
#
#   bin/install.sh --target /path/to/project --tool cursor
#   bin/install.sh --target /path/to/project --tool all --link
set -euo pipefail

TARGET="" TOOL="all" MODE="copy"
while [[ $# -gt 0 ]]; do case "$1" in
  --target) TARGET="$2"; shift 2;;
  --tool) TOOL="$2"; shift 2;;
  --link) MODE="link"; shift;;
  *) echo "unknown arg: $1"; exit 1;;
esac; done
[[ -n "$TARGET" ]] || { echo "usage: install.sh --target DIR [--tool cursor|claude|codex|all] [--link]"; exit 1; }

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$TARGET/agentic-delivery-kit"

if [[ "$MODE" == "link" ]]; then
  ln -sfn "$KIT" "$DEST"; echo "linked kit -> $DEST"
else
  mkdir -p "$DEST"; cp -R "$KIT/." "$DEST/"; rm -rf "$DEST/.git"; echo "copied kit -> $DEST"
fi

bash "$DEST/bin/link.sh" "$TOOL" --target "$TARGET"
echo "Installed. Next: copy AGENTS.md guidance into your project, run /onboard, then /new-project."
