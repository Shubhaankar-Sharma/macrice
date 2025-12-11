#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Get workspace ID from parameter
WORKSPACE_ID="$1"

# Determine border color and highlighting
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  BORDER_COLOR=$GREY
  sketchybar --set $NAME icon.highlight=on \
                         label.highlight=on \
                         background.border_color=$BORDER_COLOR \
                         icon.color=$RED \
                         label.color=$WHITE
else
  BORDER_COLOR=$BACKGROUND_2
  sketchybar --set $NAME icon.highlight=off \
                         label.highlight=off \
                         background.border_color=$BORDER_COLOR \
                         icon.color=$ACCENT_COLOR \
                         label.color=$GREY
fi

# Update app icons in label
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

sketchybar --set $NAME label="$icon_strip"
