#!/bin/bash

# Focus the AeroSpace workspace where this Claude session's terminal lives.
# AEROSPACE_WS is captured in .zshrc at shell startup.
if [ -n "$AEROSPACE_WS" ]; then
  aerospace workspace "$AEROSPACE_WS"
fi

# Refresh SketchyBar Claude indicators
sketchybar --trigger claude_session_change 2>/dev/null
