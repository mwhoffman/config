-- generate LuaLS annotations for hs.* (see .luarc.json)
hs.loadSpoon("EmmyLua")

-- visible windows on the current space, kept active so lookups are fast
local wf = hs.window.filter.defaultCurrentSpace
wf:keepActive()

hs.grid.setGrid('8x4') -- w x h
hs.grid.setMargins({5, 5})
hs.grid.ui.showExtraKeys = false
hs.window.animationDuration = 0.2

-- return a function that moves the focused window to r, a {x, y, w, h} rect
-- in fractions of the screen. This is scaled to the current hs.grid size so
-- hs.grid.set can apply the margins.
local function set_layout(r)
  return function()
    local win = hs.window.focusedWindow()
    if win then
      local g = hs.grid.getGrid(win:screen())
      hs.grid.set(win, {r[1] * g.w, r[2] * g.h, r[3] * g.w, r[4] * g.h})
    end
  end
end

-- return a function that focuses the nearest window in direction dir (e.g.
-- 'West') on the current space and moves the mouse to its center.
local function focus_window(dir)
  return function()
    local win = hs.window.frontmostWindow()
    local target = win and wf['windowsTo' .. dir](wf, win, nil, true)[1]
    if target then
      target:focus()
      hs.mouse.absolutePosition(target:frame().center)
    end
  end
end

-- define the hyper keys
local hyper = {'ctrl', 'shift'}

-- hs.hotkey.bind keys for changing layouts of the current window
hs.hotkey.bind(hyper, '0', set_layout({0, 0, 1, 1}))         -- full
hs.hotkey.bind(hyper, '1', set_layout({0, 0, 0.5, 0.5}))     -- nw
hs.hotkey.bind(hyper, '2', set_layout({0, 0.5, 0.5, 0.5}))   -- sw
hs.hotkey.bind(hyper, '3', set_layout({0.5, 0, 0.5, 0.5}))   -- ne
hs.hotkey.bind(hyper, '4', set_layout({0.5, 0.5, 0.5, 0.5})) -- se
hs.hotkey.bind(hyper, '5', set_layout({0, 0, 0.5, 1}))       -- west
hs.hotkey.bind(hyper, '6', set_layout({0.5, 0, 0.5, 1}))     -- east

-- change the focus
hs.hotkey.bind(hyper, 'h', focus_window('West'))
hs.hotkey.bind(hyper, 'j', focus_window('South'))
hs.hotkey.bind(hyper, 'k', focus_window('North'))
hs.hotkey.bind(hyper, 'l', focus_window('East'))

-- show a grid to resize windows
hs.hotkey.bind(hyper, 'a', hs.grid.show)
hs.hotkey.bind(hyper, 'r', hs.reload)
hs.hotkey.bind(hyper, 'o', hs.openConsole)

-- display to show we've reloaded
hs.alert.show('Loaded hammerspoon config')

