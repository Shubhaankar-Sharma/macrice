#!/bin/bash

# Register this Claude session for SketchyBar workspace indicators
AGENTS_DIR="/tmp/claude-agents"
mkdir -p "$AGENTS_DIR"

# Clean stale sessions
for f in "$AGENTS_DIR"/*.json; do
  [ -f "$f" ] || continue
  pid=$(grep -o '"pid":[0-9]*' "$f" | grep -o '[0-9]*')
  if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$f"
  fi
done

WS="${AEROSPACE_WS:-?}"
PROJECT=$(basename "$(pwd)")
BRANCH=$(git branch --show-current 2>/dev/null)

# Find the stable Claude Code (node) process by walking up the tree
CLAUDE_PID=$PPID
pid=$PPID
while [ "$pid" != "1" ] && [ -n "$pid" ] && [ "$pid" != "0" ]; do
  comm=$(ps -o comm= -p "$pid" 2>/dev/null | xargs 2>/dev/null)
  if [ "$comm" = "node" ]; then
    CLAUDE_PID=$pid
    break
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done

# Key by workspace (not PID) so status scripts can find the file
echo "{\"workspace\":\"$WS\",\"project\":\"$PROJECT\",\"branch\":\"${BRANCH:-}\",\"status\":\"waiting\",\"pid\":$CLAUDE_PID}" > "$AGENTS_DIR/${WS}.json"

sketchybar --trigger claude_session_change 2>/dev/null
