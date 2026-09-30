-- generate LuaLS annotations for hs.* (see .luarc.json)
hs.loadSpoon("EmmyLua")

-- visible windows on the current space, kept active so lookups are fast
local wf = hs.window.filter.defaultCurrentSpace
wf:keepActive()

hs.window.animationDuration = 0

local gap = 10 -- px between adjacent windows; none along screen edges

-- return a function that moves the focused window to r, a {x, y, w, h} rect
-- in fractions of the screen. Interior edges are inset by gap/2 so adjacent
-- windows end up gap apart, while edges on the screen border stay flush.
local function set_layout(r)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local s = win:screen():frame()
    local x1, y1, x2, y2 = r[1], r[2], r[1] + r[3], r[2] + r[4]
    local function inset(v) return (v > 0 and v < 1) and gap / 2 or 0 end
    win:setFrame({
      x = s.x + x1 * s.w + inset(x1),
      y = s.y + y1 * s.h + inset(y1),
      w = (x2 - x1) * s.w - inset(x1) - inset(x2),
      h = (y2 - y1) * s.h - inset(y1) - inset(y2),
    })
  end
end

-- return a function that focuses the nearest window in direction dir (e.g.
-- 'West') on the current space and moves the mouse to its center. Windows
-- squarely in that direction win; otherwise (e.g. on a screen that's offset
-- diagonally) fall back to anything on that side.
local function focus_window(dir)
  return function()
    local win = hs.window.frontmostWindow()
    if not win then return end
    local find = wf['windowsTo' .. dir]
    local target = find(wf, win, nil, true)[1] or find(wf, win, nil, false)[1]
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
hs.hotkey.bind(hyper, 'r', hs.reload)
hs.hotkey.bind(hyper, 'o', hs.openConsole)

-- display to show we've reloaded
hs.alert.show('Loaded hammerspoon config')
