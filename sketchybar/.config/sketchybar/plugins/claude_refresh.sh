#!/bin/bash

# Periodic check: flip "active" sessions to "waiting" if their process is idle (low CPU)
# This catches interrupts (Escape) where the Stop hook doesn't fire
AGENTS_DIR="/tmp/claude-agents"
[ -d "$AGENTS_DIR" ] || exit 0

for f in "$AGENTS_DIR"/*.json; do
  [ -f "$f" ] || continue
  pid=$(grep -o '"pid":[0-9]*' "$f" | grep -o '[0-9]*')
  status=$(grep -o '"status":"[^"]*"' "$f" | cut -d'"' -f4)

  # Clean dead sessions
  if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then
    ws=$(grep -o '"workspace":"[^"]*"' "$f" | cut -d'"' -f4)
    rm -f "$f"
    sketchybar --set space.$ws background.drawing=off 2>/dev/null
    continue
  fi

  # If marked active but process is idle, flip to waiting
  if [ "$status" = "active" ] && [ -n "$pid" ]; then
    cpu=$(ps -o %cpu= -p "$pid" 2>/dev/null | tr -d ' ')
    idle=$(echo "$cpu" | awk '{print ($1 < 2.0) ? "1" : "0"}')
    if [ "$idle" = "1" ]; then
      sed -i '' 's/"status":"active"/"status":"waiting"/' "$f"
      ws=$(grep -o '"workspace":"[^"]*"' "$f" | cut -d'"' -f4)
      sketchybar --set space.$ws background.color=0x35f5a97f 2>/dev/null
    fi
  fi
done
