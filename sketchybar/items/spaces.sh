#!/bin/bash

# Get all workspaces from aerospace
SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add item space.$sid left                                 \
             --set space.$sid icon=$sid                                 \
                              icon.padding_left=10                      \
                              icon.padding_right=10                     \
                              padding_left=2                            \
                              padding_right=2                           \
                              label.padding_right=20                    \
                              icon.highlight_color=$RED                 \
                              label.color=$GREY                         \
                              label.highlight_color=$WHITE              \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.y_offset=-1                          \
                              background.color=$BACKGROUND_1            \
                              background.border_color=$BACKGROUND_2     \
                              background.drawing=off                    \
                              label.drawing=on                          \
                              click_script="aerospace workspace $sid"    \
                              script="$PLUGIN_DIR/aerospace.sh $sid"     \
             --subscribe space.$sid aerospace_workspace_change
done

sketchybar --add item space_separator left                             \
           --set space_separator icon="􀆊"                                \
                                 icon.color=$ACCENT_COLOR \
                                 icon.padding_left=4                   \
                                 label.drawing=off                     \
                                 background.drawing=off
