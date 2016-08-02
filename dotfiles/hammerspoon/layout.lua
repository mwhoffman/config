-- local functions
local rect = hs.geometry.rect

-- initialize the "package"
local layout = {}

-- create a table of layouts which are functions that take the screen
-- dimensions and return a rect describing the window position and size
local layouts = {}
local focus = {}

layouts['full'] = function(x, y, w, h)
    return rect(x, y, w, h)
end

layouts['north'] = function(x, y, w, h)
    return rect(x, y, w, h/2)
end

layouts['south'] = function(x, y, w, h)
    return rect(x, y+h/2, w, h/2)
end

layouts['east'] = function(x, y, w, h)
    return rect(x+w/2, y, w/2, h)
end

layouts['west'] = function(x, y, w, h)
    return rect(x, y, w/2, h)
end

layouts['ne'] = function(x, y, w, h)
    return rect(x+w/2, y, w/2, h/2)
end

layouts['nw'] = function(x, y, w, h)
    return rect(x, y, w/2, h/2)
end

layouts['se'] = function(x, y, w, h)
    return rect(x+w/2, y+h/2, w/2, h/2)
end

layouts['sw'] = function(x, y, w, h)
    return rect(x, y+h/2, w/2, h/2)
end

focus['north'] = function(window) window:focusWindowNorth() end
focus['south'] = function(window) window:focusWindowSouth() end
focus['east'] = function(window) window:focusWindowEast() end
focus['west'] = function(window) window:focusWindowWest() end

-- return a curried function which will the set the layout of the currently
-- focused window

function layout.set_layout(str)
    return function()
        local window = hs.window.focusedWindow()
        if window then
            local f = window:screen():frame()
            window:setFrame(layouts[str](f.x, f.y, f.w, f.h))
        end
    end
end

function layout.set_focus(str)
    return function()
        local window = hs.window.focusedWindow()
        if window then
            focus[str](window)
        end
    end
end

return layout
