local window = require("hs.window") -- make sure this is loaded
local winMT  = getmetatable(window)
local original_index = winMT.__index
winMT.__index = function(self, key)
    local answer = original_index(self, key)
    if answer then
        return answer
    else
        return hs.getObjectMetatable("hs.window")[key]
    end
end

-- require my local layout
local layout = require('layout')

-- define the hyper keys
local hyper = {'ctrl', 'shift'}

-- don't use window animations
hs.window.animationDuration = 0

-- change the grid parameters
hs.grid.GRIDHEIGHT = 4
hs.grid.GRIDWIDTH = 8
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.ui.showExtraKeys = false

-- hs.hotkey.bind keys for changing layouts of the current window
hs.hotkey.bind(hyper, '0', layout.set_layout('full'))
hs.hotkey.bind(hyper, '1', layout.set_layout('nw'))
hs.hotkey.bind(hyper, '2', layout.set_layout('sw'))
hs.hotkey.bind(hyper, '3', layout.set_layout('ne'))
hs.hotkey.bind(hyper, '4', layout.set_layout('se'))
hs.hotkey.bind(hyper, '5', layout.set_layout('west'))
hs.hotkey.bind(hyper, '6', layout.set_layout('east'))

function move_mouse_to_window()
  local frame = hs.window.focusedWindow():frame()
  local pt = hs.geometry.rectMidPoint(frame)
  hs.mouse.setAbsolutePosition(pt)
end

-- change the focus
hs.hotkey.bind(hyper, 'h', function() hs.window.filter.focusWest(); move_mouse_to_window() end)
hs.hotkey.bind(hyper, 'j', function() hs.window.filter.focusSouth(); move_mouse_to_window() end)
hs.hotkey.bind(hyper, 'k', function() hs.window.filter.focusNorth(); move_mouse_to_window() end)
hs.hotkey.bind(hyper, 'l', function() hs.window.filter.focusEast(); move_mouse_to_window() end)

-- show a grid to resize windows
hs.hotkey.bind(hyper, 'a', hs.grid.show)
hs.hotkey.bind(hyper, 'r', hs.reload)
hs.hotkey.bind(hyper, 'o', hs.openConsole)

-- display to show we've reloaded
hs.alert.show('Reloaded hammerspoon config')

