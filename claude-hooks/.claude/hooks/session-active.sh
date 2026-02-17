#!/bin/bash

# Mark session as active (Claude is working) - direct sketchybar update for speed
f="/tmp/claude-agents/${AEROSPACE_WS}.json"
if [ -f "$f" ] && grep -q '"status":"waiting"' "$f"; then
  sed -i '' 's/"status":"waiting"/"status":"active"/' "$f"
  sketchybar --set space.$AEROSPACE_WS background.color=0x30c6a0f6 2>/dev/null
fi
