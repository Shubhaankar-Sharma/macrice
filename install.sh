#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$REPO_DIR/omniwm/.config/omniwm/settings.toml"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# Match OmniWM: relative XDG_CONFIG_HOME values fall back to ~/.config.
[[ "$CONFIG_HOME" = /* ]] || CONFIG_HOME="$HOME/.config"
TARGET="$CONFIG_HOME/omniwm/settings.toml"

if [[ ! -d /Applications/OmniWM.app && ! -d "$HOME/Applications/OmniWM.app" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew (https://brew.sh), then rerun ./install.sh." >&2
    exit 1
  fi
  brew install --cask omniwm
fi

mkdir -p "$(dirname "$TARGET")"
if [[ -f "$TARGET" ]] && cmp -s "$SOURCE" "$TARGET"; then
  echo "OmniWM config is already up to date: $TARGET"
else
  if [[ -e "$TARGET" || -L "$TARGET" ]]; then
    BACKUP="${TARGET}.backup.$(date +%Y%m%d-%H%M%S).$$"
    mv "$TARGET" "$BACKUP"
    echo "Previous config saved to $BACKUP"
  fi
  cp "$SOURCE" "$TARGET"
  echo "Installed $TARGET"
fi

printf '\nNext steps:\n'
echo '  1. Open OmniWM and grant Accessibility and Input Monitoring.'
echo '  2. Enable Displays have separate Spaces in macOS; log out/in if changed.'
echo '  3. Enable Start at Login in OmniWM if wanted.'
echo 'Raycast and Warp are managed separately. No other configs were changed.'
