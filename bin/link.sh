#!/usr/bin/env bash
# Expose the neutral .agents/ content to a specific tool by symlinking it into the
# directory that tool expects. Run from a project that contains this kit (or point
# --target at one). Tool-agnostic adapter.
#
#   bin/link.sh cursor                 # link into ./.cursor
#   bin/link.sh claude                 # link into ./.claude
#   bin/link.sh codex                  # link into ./.codex
#   bin/link.sh all                    # link into all three
#   bin/link.sh claude --target /path/to/project
set -euo pipefail

TOOL="${1:-all}"; shift || true
TARGET="."
if [[ "${1:-}" == "--target" ]]; then TARGET="${2:?}"; fi

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$KIT/.agents"

link_one() {
  local tool="$1" dir="$TARGET/.$tool"
  mkdir -p "$dir"
  # skills + commands map 1:1; subagents -> agents for tools that use that name.
  ln -sfn "$SRC/skills"    "$dir/skills"
  ln -sfn "$SRC/commands"  "$dir/commands"
  ln -sfn "$SRC/subagents" "$dir/agents"
  echo "  linked .$tool -> $SRC (skills, commands, agents)"
  # MCP: project-scope config where the tool reads it.
  case "$tool" in
    cursor) ln -sfn "$KIT/mcp/mcp.project.json" "$dir/mcp.json" ;;
    claude|codex) ln -sfn "$KIT/mcp/mcp.project.json" "$TARGET/.mcp.json" ;;
  esac
}

case "$TOOL" in
  cursor|claude|codex) link_one "$TOOL" ;;
  all) for t in cursor claude codex; do link_one "$t"; done ;;
  *) echo "usage: link.sh <cursor|claude|codex|all> [--target DIR]"; exit 1 ;;
esac
echo "Done. User-scope MCP servers are set separately (see mcp/mcp.user.json)."
