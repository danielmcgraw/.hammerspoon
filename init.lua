local spaces = require("hs._asm.undocumented.spaces")
local internal = require("hs._asm.undocumented.spaces.internal")

hs.window.animationDuration = 0

-- Replacement for ShiftIt style app
units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  upright50     = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botright50    = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
  upleft50      = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  botleft50     = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

mash = { 'ctrl', 'alt', 'cmd' }
-- Push window to sides or top and bottom
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right50, nil, true) end)
hs.hotkey.bind(mash, 'left',  function() hs.window.focusedWindow():move(units.left50,  nil, true) end)
hs.hotkey.bind(mash, 'up',    function() hs.window.focusedWindow():move(units.top50,   nil, true) end)
hs.hotkey.bind(mash, 'down',  function() hs.window.focusedWindow():move(units.bot50,   nil, true) end)
hs.hotkey.bind(mash, 'm',     function() hs.window.focusedWindow():move(units.maximum, nil, true) end)

-- Move window to the next or previous screen
hs.hotkey.bind(mash, "n", function() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next()) end)
hs.hotkey.bind(mash, "p", function() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():previous()) end)

-- Grow and shrink the window
hs.hotkey.bind(mash, "=", function() hs.grid.resizeWindowWider(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "-", function() hs.grid.resizeWindowThinner(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "[", function() hs.grid.resizeWindowTaller(hs.window.focusedWindow()) end)
hs.hotkey.bind(mash, "]", function() hs.grid.resizeWindowShorter(hs.window.focusedWindow()) end)

hyper = { 'shift', 'alt', 'cmd' }
-- Push window to corners
hs.hotkey.bind(hyper, 'right', function() hs.window.focusedWindow():move(units.upright50,  nil, true) end)
hs.hotkey.bind(hyper, 'left',  function() hs.window.focusedWindow():move(units.botleft50,  nil, true) end)
hs.hotkey.bind(hyper, 'up',    function() hs.window.focusedWindow():move(units.upleft50,   nil, true) end)
hs.hotkey.bind(hyper, 'down',  function() hs.window.focusedWindow():move(units.botright50, nil, true) end)

-- Replacement for Caffeine style app
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  local awake = hs.image.imageFromPath('caffeine/awake.png'):setSize({w=20,h=20})
  local sleepy = hs.image.imageFromPath('caffeine/sleepy.png'):setSize({w=20,h=20})

  if state then
    caffeine:setIcon(awake)
  else
    caffeine:setIcon(sleepy)
  end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


meta = { 'ctrl', 'cmd' }
-- move current window to the space sp
function moveWindowToSpace(sp)
    local win = hs.window.focusedWindow()
    local uuid = win:screen():spacesUUID()
    local spaceID = spaces.layout()[uuid][sp]
    spaces.moveWindowToSpace(win:id(), spaceID)
    spaces.changeToSpace(spaceID)
end
for i = 1, 8 do -- Update with the # of spaces you are using
  hs.hotkey.bind(meta, tostring(i), function() moveWindowToSpace(i) end)
end

-- move to specific space
splat = { 'ctrl', 'shift' }
function moveToSpace(sp)
  local spaceID = spaces.layout()[internal.spaceScreenUUID(internal.activeSpace())][sp]
  spaces.changeToSpace(spaceID)
end
for i = 1, 8 do -- Update with the # of spaces you are using
  hs.hotkey.bind(splat, tostring(i), function() moveToSpace(i) end)
end
