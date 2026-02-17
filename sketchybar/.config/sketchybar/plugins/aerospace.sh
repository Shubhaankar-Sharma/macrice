#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

WORKSPACE_ID="$1"

# Get focused workspace if not set (e.g. from claude_session_change event)
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

# Check for active Claude session in this workspace (files keyed by workspace name)
CLAUDE_HERE=false
CLAUDE_STATUS=""
CLAUDE_LABEL=""
SESSION_FILE="/tmp/claude-agents/${WORKSPACE_ID}.json"
if [ -f "$SESSION_FILE" ]; then
  pid=$(grep -o '"pid":[0-9]*' "$SESSION_FILE" | grep -o '[0-9]*')
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    CLAUDE_HERE=true
    CLAUDE_STATUS=$(grep -o '"status":"[^"]*"' "$SESSION_FILE" | cut -d'"' -f4)
    branch=$(grep -o '"branch":"[^"]*"' "$SESSION_FILE" | cut -d'"' -f4)
    project=$(grep -o '"project":"[^"]*"' "$SESSION_FILE" | cut -d'"' -f4)
    CLAUDE_LABEL="$project"
  else
    rm -f "$SESSION_FILE"
  fi
fi

# Focus styling
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME icon.highlight=on \
                         label.highlight=on \
                         background.border_color=$GREY \
                         icon.color=$RED \
                         label.color=$WHITE
else
  sketchybar --set $NAME icon.highlight=off \
                         label.highlight=off \
                         background.border_color=$BACKGROUND_2 \
                         icon.color=$ACCENT_COLOR \
                         label.color=$GREY
fi

# Claude indicator: colored background + branch/project label
if $CLAUDE_HERE; then
  if [ "$CLAUDE_STATUS" = "waiting" ]; then
    BG_COLOR=0x35f5a97f  # amber - idle, needs you
  else
    BG_COLOR=0x30c6a0f6  # purple - actively working
  fi
  sketchybar --set $NAME background.drawing=on \
                         background.color=$BG_COLOR \
                         label="$CLAUDE_LABEL" \
                         label.font="SF Pro:Semibold:11.0" \
                         label.y_offset=0
else
  # Regular app icons
  apps=$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" 2>/dev/null | sort -u)
  icon_strip=""
  if [ -n "$apps" ]; then
    while IFS= read -r app; do
      if [ -f "$CONFIG_DIR/plugins/icon_map_fn.sh" ]; then
        icon_result=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app")
        icon_strip+=" $icon_result"
      else
        icon_strip+=" ●"
      fi
    done <<< "$apps"
  fi
  sketchybar --set $NAME background.drawing=off \
                         label="$icon_strip" \
                         label.font="sketchybar-app-font:Regular:16.0" \
                         label.y_offset=-1
fi
