local hyper  = { "alt", "ctrl", "shift" }
local hyperc = { "cmd", "alt", "ctrl", "shift" }
local modc   = { "ctrl" }
local modcc  = { "cmd", "ctrl" }

-- Hammerspoon -- reload the config on change
hs.hotkey.bind(hyperc, "r", function()
  hs.reload()
end)

-- Lock screen trigger
hs.hotkey.bind(hyper, "l", function()
  hs.caffeinate.lockScreen()
end)


-- hs.hotkey.bind(hyper, "f", function()
--   local win = hs.window.frontmostWindow()
--   win:setFullscreen(not win:isFullscreen())
-- end)

-- TODO: make a spoon called "elux.spoon" with all my methods, and config, etc

local term = 'Warp'
-- local term = 'iTerm'

-- Global hot-key apps for fast-app launching and switching
local hotApps = {
  a = { id = 'Arc' },
  t = { id = term },
  x = { id = 'Visual Studio Code' },
  -- p = { id = 'Preview' },
  -- g = { id = 'Safari' },
  -- x = { id = 'Xcode', singleton = true },
  k = { id = 'Discord', singleton = true },
  j = { id = 'Slack', singleton = true },
  w = { id = 'WhatsApp', singleton = true },
  s = { id = 'Spotify', singleton = true },
  -- m = { id = 'Simulator', singleton = true },
  -- m = { id = 'Postman', singleton = true },
}

hs.hotkey.bind(hyperc, 'return', function()
  local app = hs.application.find('Finder')
  hs.eventtap.keyStroke({'cmd'}, 'N', nil, app)
  hs.application.launchOrFocus('Finder')
end)

for key, val in pairs(hotApps) do
  hs.hotkey.bind(hyper, key, function()
    local id = val.id
    local singleton = val.singleton
    local app = hs.application.find(id)

    if app == nil or singleton == true then
      hs.application.launchOrFocus(id)
    else
      local win = app:allWindows()[1]
      if win == nil then
        hs.eventtap.keyStroke({'cmd'}, 'N', nil, app)
        hs.application.launchOrFocus(id)
      else
        win.focus(win) -- hmm sup..?
        -- hs.alert.show('select the win')
        -- TODO: we can even keep hitting it and cycling
        -- there is the window switcher thing..
      end
    end
  end)
end

-- TODO: add an elux = {} thing,
-- and then set term = 'iTerm', the name of the term app etc
-- and it could be a config option too..

-- Terminal launcher
hs.hotkey.bind(hyper, "return", function()
  local app = hs.application.find(term)
  if app == nil then
    hs.application.launchOrFocus(term)
  else
    hs.eventtap.keyStroke({'cmd'}, 'N', nil, app)
    hs.application.launchOrFocus(term)
  end
end)

-- All window management is now handled by AeroSpace natively via keybinds
-- No need for yabai integration anymore - AeroSpace handles:
-- - Window navigation (hyper + arrows)
-- - Window movement (hyperc + arrows)
-- - Workspace switching (hyper + 1-9)
-- - Moving windows to workspaces (hyperc + 1-9)
-- - Fullscreen, rotate, float, split (hyper + f/r/space/v)
-- - Resizing (hyper + ;/')


-- Spotify controls -- next/prev/play-pause
hs.hotkey.bind(hyper, ".", function()
  hs.osascript.applescript([[
    tell application "Spotify"
      next track
    end tell  
  ]])
end)
hs.hotkey.bind(hyper, ",", function()
  hs.osascript.applescript([[
    tell application "Spotify"
      previous track
    end tell  
  ]])
end)
hs.hotkey.bind(hyper, "/", function()
  hs.osascript.applescript([[
    if application "Spotify" is running then
      tell application "Spotify" to playpause
    end if
  ]])
end)


--

-- TODO:
-- 1. yabai, dialogs should always be floating, etc..
-- 2. switcher alt+tab, what is this about?
-- 3. yabai, different grid layouts
-- 4. yabai, launching new windows, what is up with this?
-- 5. hammerspoon new space asm thing, lets try it?
-- 6. hammerspoon event watching, always select window in focus, etc?
-- 7. switch space left/right, lets try hyper+][ keys..

--


-- TODO: can we store somewhere in memory this windows thing, so 
-- we can toggle hyper F again and switch back?
-- or.. could just use the other thing above, which is pretty decent too
-- hs.hotkey.bind(hyper, "F", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   local screen = win:screen()
--   local max = screen:frame()

--   f.x = max.x
--   f.y = max.y
--   f.w = max.w
--   f.h = max.h
--   win:setFrame(f)
-- end)

-- hs.loadSpoon("MiroWindowsManager")
-- spoon.MiroWindowsManager:bindHotkeys({
--   up = {hyper, "up"},
--   right = {hyper, "right"},
--   down = {hyper, "down"},
--   left = {hyper, "left"},
--   fullscreen = {hyper, "f"}
-- })
