#!/bin/bash

# Mark session as waiting (Claude needs user input) - direct sketchybar update for speed
INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | grep -o '"transcript_path":"[^"]*"' | cut -d'"' -f4)
SESSION_ID=$(echo "$INPUT" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)

f="/tmp/claude-agents/${AEROSPACE_WS}.json"
if [ -f "$f" ]; then
  TIMESTAMP=$(date +%s)

  if grep -q '"status":"active"' "$f"; then
    sed -i '' 's/"status":"active"/"status":"waiting"/' "$f"
  fi

  sed -i '' 's/,"transcript_path":"[^"]*"//g' "$f"
  sed -i '' 's/,"session_id":"[^"]*"//g' "$f"
  sed -i '' 's/,"waiting_since":[0-9]*//g' "$f"
  sed -i '' "s/}$/,\"transcript_path\":\"${TRANSCRIPT_PATH}\",\"session_id\":\"${SESSION_ID}\",\"waiting_since\":${TIMESTAMP}}/" "$f"

  sketchybar --set space.$AEROSPACE_WS background.color=0x35f5a97f 2>/dev/null
fi
