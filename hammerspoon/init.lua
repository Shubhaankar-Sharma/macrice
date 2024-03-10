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
  s = { id = 'Google Chrome' },
  t = { id = term },
  e = { id = 'Code' },
  p = { id = 'Preview' },
  g = { id = 'Safari' },
  x = { id = 'Xcode', singleton = true },
  k = { id = 'Discord', singleton = true },
  j = { id = 'Slack', singleton = true },
  a = { id = 'Messages', singleton = true },
  i = { id = 'Spotify', singleton = true },
  n = { id = 'Notion', singleton = true },
  -- m = { id = 'Simulator', singleton = true },
  m = { id = 'Postman', singleton = true },
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

-- yabai integration..
local function yabaiExec(cmd)
  local _cmd = '/opt/homebrew/bin/yabai -m ' .. cmd
  return hs.execute(_cmd, false)
end

hs.hotkey.bind(hyper, "left", function()
  yabaiExec('window --focus west')
end)
hs.hotkey.bind(hyper, "right", function()
  yabaiExec('window --focus east')
end)
hs.hotkey.bind(hyper, "up", function()
  yabaiExec('window --focus north')
end)
hs.hotkey.bind(hyper, "down", function()
  yabaiExec('window --focus south')
end)

hs.hotkey.bind(hyperc, "left", function()
  yabaiExec('window --warp west')
end)
hs.hotkey.bind(hyperc, "right", function()
  yabaiExec('window --warp east')
end)
hs.hotkey.bind(hyperc, "up", function()
  yabaiExec('window --warp north')
end)
hs.hotkey.bind(hyperc, "down", function()
  yabaiExec('window --warp south')
end)

hs.hotkey.bind(hyper, "f", function()
  yabaiExec('window --toggle zoom-fullscreen')
end)
hs.hotkey.bind(hyper, "r", function()
  yabaiExec('space --rotate 90')
end)
hs.hotkey.bind(hyper, "space", function()
  yabaiExec('window --toggle float')
end)

-- spaces
hs.hotkey.bind(hyper, "]", function()
  yabaiExec('space --focus next')
end)
hs.hotkey.bind(hyper, "[", function()
  yabaiExec('space --focus prev')
end)
hs.hotkey.bind(hyper, "1", function()
  yabaiExec('space --focus 1')
end)
hs.hotkey.bind(hyper, "2", function()
  yabaiExec('space --focus 2')
end)
hs.hotkey.bind(hyper, "3", function()
  yabaiExec('space --focus 3')
end)
hs.hotkey.bind(hyper, "4", function()
  yabaiExec('space --focus 4')
end)
hs.hotkey.bind(hyper, "5", function()
  yabaiExec('space --focus 5')
end)
hs.hotkey.bind(hyper, "6", function()
  yabaiExec('space --focus 6')
end)
hs.hotkey.bind(hyper, "7", function()
  yabaiExec('space --focus 7')
end)
hs.hotkey.bind(hyper, "8", function()
  yabaiExec('space --focus 8')
end)
hs.hotkey.bind(hyper, "9", function()
  yabaiExec('space --focus 9')
end)
hs.hotkey.bind(hyper, "0", function()
  yabaiExec('space --focus 10')
end)

-- move windows to other spaces
hs.hotkey.bind(hyperc, "1", function()
  yabaiExec('window --space 1')
end)
hs.hotkey.bind(hyperc, "2", function()
  yabaiExec('window --space 2')
end)
hs.hotkey.bind(hyperc, "3", function()
  yabaiExec('window --space 3')
end)
hs.hotkey.bind(hyperc, "4", function()
  yabaiExec('window --space 4')
end)
hs.hotkey.bind(hyperc, "5", function()
  yabaiExec('window --space 5')
end)
hs.hotkey.bind(hyperc, "6", function()
  yabaiExec('window --space 6')
end)
hs.hotkey.bind(hyperc, "7", function()
  yabaiExec('window --space 7')
end)
hs.hotkey.bind(hyperc, "8", function()
  yabaiExec('window --space 8')
end)
hs.hotkey.bind(hyperc, "9", function()
  yabaiExec('window --space 9')
end)
hs.hotkey.bind(hyperc, "0", function()
  yabaiExec('window --space 10')
end)


hs.hotkey.bind(hyper, "v", function()
  yabaiExec('window --toggle split')
end)
-- hs.hotkey.bind(hyper, "h", function()
--   yabaiExec('window --grid 1:3:0:0:2:1')
-- end)


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
