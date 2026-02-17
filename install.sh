#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES="aerospace sketchybar hammerspoon karabiner"

echo "macrice installer"
echo "================="

# Check for stow
if ! command -v stow &>/dev/null; then
  echo "Installing GNU Stow..."
  brew install stow
fi

# Check for required apps
MISSING=()
command -v aerospace &>/dev/null || MISSING+=("brew install --cask nikitabobko/tap/aerospace")
command -v sketchybar &>/dev/null || MISSING+=("brew install koekeishiya/formulae/sketchybar")
[ -d "/Applications/Hammerspoon.app" ] || MISSING+=("brew install --cask hammerspoon")
[ -d "/Applications/Karabiner-Elements.app" ] || MISSING+=("brew install --cask karabiner-elements")

if [ ${#MISSING[@]} -gt 0 ]; then
  echo ""
  echo "Missing dependencies. Install with:"
  for cmd in "${MISSING[@]}"; do
    echo "  $cmd"
  done
  echo ""
  read -p "Install now? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    for cmd in "${MISSING[@]}"; do
      eval "$cmd"
    done
  fi
fi

# Install fonts
echo ""
echo "Checking fonts..."
brew install --cask sf-symbols 2>/dev/null || true
brew install --cask font-sf-pro 2>/dev/null || true

# Remove conflicting symlinks or dirs
echo ""
echo "Removing existing configs..."
for target in ~/.config/aerospace ~/.config/sketchybar ~/.config/karabiner ~/.hammerspoon; do
  if [ -L "$target" ]; then
    unlink "$target"
    echo "  unlinked $target"
  elif [ -d "$target" ]; then
    echo "  WARNING: $target is a real directory, skipping (back it up and remove manually)"
  fi
done

# Stow all packages
echo ""
echo "Stowing packages..."
cd "$REPO_DIR"
for pkg in $PACKAGES; do
  if [ -d "$pkg" ]; then
    stow -v -t ~ "$pkg"
  fi
done

# Copy Claude hooks (can't stow into existing ~/.claude/ dir)
echo ""
echo "Installing Claude Code hooks..."
mkdir -p ~/.claude/hooks
cp -v "$REPO_DIR/claude-hooks/.claude/hooks/"*.sh ~/.claude/hooks/ 2>/dev/null || true
chmod +x ~/.claude/hooks/*.sh 2>/dev/null || true

echo ""
echo "Done. Next steps:"
echo "  1. Merge claude-hooks/.claude/settings.json.example into your ~/.claude/settings.json"
echo "  2. Add to ~/.zshrc:"
echo '     if [[ $- == *i* ]] && [[ -z "$AEROSPACE_WS" ]]; then'
echo '       export AEROSPACE_WS=$(aerospace list-workspaces --focused 2>/dev/null)'
echo '     fi'
echo "  3. Reload: sketchybar --reload && hammerspoon -c 'hs.reload()'"
