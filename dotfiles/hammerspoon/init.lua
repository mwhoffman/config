-- require my local layout
local layout = require('layout')
local bind = hs.hotkey.bind

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

-- bind keys for changing layouts of the current window
bind(mash1, '0', layout.set_layout('full'))
bind(mash1, '1', layout.set_layout('nw'))
bind(mash1, '2', layout.set_layout('sw'))
bind(mash1, '3', layout.set_layout('ne'))
bind(mash1, '4', layout.set_layout('se'))
bind(mash1, '5', layout.set_layout('west'))
bind(mash1, '6', layout.set_layout('east'))

-- change the focus
bind(mash1, 'h', hs.window.filter.focusWest)
bind(mash1, 'j', hs.window.filter.focusSouth)
bind(mash1, 'k', hs.window.filter.focusNorth)
bind(mash1, 'l', hs.window.filter.focusEast)

-- show a grid to resize windows
bind(mash1, 'a', hs.grid.show)
bind(mash1, 'r', hs.reload)
bind(mash1, 'o', hs.openConsole)

function activate(name)
  return function()
    local app = hs.application.find(name)
    app:activate()
  end
end

bind(mash2, 'm', activate('Mail'))
bind(mash2, 'e', activate('Messages'))
bind(mash2, 's', activate('Slack'))
bind(mash2, 't', activate('Things'))
bind(mash2, 'n', activate('Alternote'))
bind(mash2, 'i', activate('iTunes'))

-- display to show we've reloaded
hs.alert.show('Reloaded hammerspoon config')

