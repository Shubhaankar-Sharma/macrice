# macrice

My macOS desktop setup: **OmniWM + Raycast + Warp**.

OmniWM handles Dwindle tiling, workspaces, a bottom workspace bar, and Caps Lock as Hyper. Raycast stays the launcher; Warp stays the terminal. No AeroSpace, SketchyBar, Hammerspoon, or Karabiner required.

## Install

Requires Apple Silicon and macOS 26 or later. This config was captured from OmniWM **0.7.6**, settings schema **4**. Newer versions may migrate the file.

With [Homebrew](https://brew.sh) installed:

```bash
git clone https://github.com/Shubhaankar-Sharma/macrice.git ~/config/macrice
cd ~/config/macrice
./install.sh
```

The installer installs OmniWM if missing and copies the tracked config to `${XDG_CONFIG_HOME:-$HOME/.config}/omniwm/settings.toml`. It backs up a different existing config before replacing it. It does not launch OmniWM, uninstall apps, or modify other tools' configs. Stow and extra fonts are not needed.

Install Raycast and Warp separately if needed:

```bash
brew install --cask raycast warp
```

Open OmniWM and grant **Accessibility** and **Input Monitoring**. Enable **Displays have separate Spaces** in System Settings → Desktop & Dock → Mission Control; log out and back in if you change it. Screen Recording is optional for Overview thumbnails. Enable **Start at Login** in OmniWM if wanted; this is not stored in the TOML file.

## Keybindings

**Hold Caps Lock** to use Hyper (`Control + Option`). Command and Shift remain available as extra modifiers.

| Shortcut | Action |
| --- | --- |
| Caps + arrows | Focus window left/down/up/right |
| Caps + Command + arrows | Move window within workspace |
| Caps + Command + Shift + arrows | Send window to adjacent monitor |
| Caps + 1–9 / 0 | Switch to workspace 1–10 |
| Caps + Command + 1–9 / 0 | Send window to workspace 1–10 |
| Caps + [ / ] | Previous / next workspace |
| Caps + Tab | Toggle last workspace |
| Caps + F | Toggle layout fullscreen |
| Caps + Space | Toggle floating / tiled |
| Caps + R | Toggle Dwindle split orientation |
| Caps + ; / ' | Shrink / grow focused window |
| Caps + Shift + B | Balance window sizes |

These are the main bindings; the TOML file also retains other OmniWM defaults. Raycast shortcuts are managed in Raycast and are not exported here.

**Caps + Enter → new Warp window is not configured yet.** OmniWM's built-in quake terminal is separate from Warp.

## Displays and appearance

- All ten workspaces use **Dwindle**.
- Workspace **6** belongs to the secondary display (the laptop in my current setup); the others belong to the main display (Dell).
- macOS currently places the laptop to the right: Caps + Command + Shift + Right sends a window there; Left sends it back. Caps + 6 focuses the laptop workspace.
- Monitor shortcuts follow macOS display arrangement. Adjust workspace monitor assignments for a different setup.
- The workspace bar sits at the **bottom**, with a **solid black background**, 28px height, workspace numbers, and app icons.
- The bar reserves layout space, with an additional 8px bottom gap.
- Focused-window borders are disabled.

## Keep the repo in sync

OmniWM writes Settings changes to its live TOML file. Installation uses a copy, not a symlink, so capture changes before committing:

```bash
cd ~/config/macrice
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
[[ "$config_home" = /* ]] || config_home="$HOME/.config"
cp "$config_home/omniwm/settings.toml" omniwm/.config/omniwm/settings.toml
git diff
```

Review the file for private paths or other personal data before publishing it.

## Previous setup

The AeroSpace, SketchyBar, Hammerspoon, Karabiner, and Claude-session hook configs are preserved in Git history, not in the current tree. Their old installer and screenshot were removed. The old Claude workspace/status integration has not been ported to OmniWM.

When migrating an existing machine, quit the old window manager and disable its login item before launching OmniWM. This installer does not remove old apps, shell snippets, or Claude hooks from your home directory.
