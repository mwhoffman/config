-- require my local layout
local layout = require('layout')

-- define the hyper keys
local mash1 = {'ctrl', 'shift'}
local mash2 = {'ctrl', 'shift'}

-- don't use window animations
hs.window.animationDuration = 0

-- change the grid parameters
hs.grid.GRIDHEIGHT = 4
hs.grid.GRIDWIDTH = 8
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.ui.showExtraKeys = false

-- hs.hotkey.bind keys for changing layouts of the current window
hs.hotkey.bind(mash1, '0', layout.set_layout('full'))
hs.hotkey.bind(mash1, '1', layout.set_layout('nw'))
hs.hotkey.bind(mash1, '2', layout.set_layout('sw'))
hs.hotkey.bind(mash1, '3', layout.set_layout('ne'))
hs.hotkey.bind(mash1, '4', layout.set_layout('se'))
hs.hotkey.bind(mash1, '5', layout.set_layout('west'))
hs.hotkey.bind(mash1, '6', layout.set_layout('east'))

function move_mouse_to_window()
  local frame = hs.window.focusedWindow():frame()
  local pt = hs.geometry.rectMidPoint(frame)
  hs.mouse.setAbsolutePosition(pt)
end

-- change the focus
hs.hotkey.bind(mash1, 'h', function() hs.window.filter.focusWest(); move_mouse_to_window() end)
hs.hotkey.bind(mash1, 'j', function() hs.window.filter.focusSouth(); move_mouse_to_window() end)
hs.hotkey.bind(mash1, 'k', function() hs.window.filter.focusNorth(); move_mouse_to_window() end)
hs.hotkey.bind(mash1, 'l', function() hs.window.filter.focusEast(); move_mouse_to_window() end)

hs.hotkey.bind(mash1, "space", function ()
  focusScreen(hs.window.focusedWindow():screen():next())
end)

--Predicate that checks if a window belongs to a screen
function isInScreen(screen, win)
  return win:screen() == screen
end

function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
      hs.window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local pt = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.setAbsolutePosition(pt)
end

-- show a grid to resize windows
hs.hotkey.bind(mash1, 'a', hs.grid.show)
hs.hotkey.bind(mash1, 'r', hs.reload)
hs.hotkey.bind(mash1, 'o', hs.openConsole)

-- display to show we've reloaded
hs.alert.show('Reloaded hammerspoon config')

