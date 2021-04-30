-- initialize the "package"
local layout = {}
local layouts = {}

layouts['full'] = function(x, y, w, h)
  return hs.geometry.rect(x, y, w, h)
end

layouts['north'] = function(x, y, w, h)
  return hs.geometry.rect(x, y, w, h/2)
end

layouts['south'] = function(x, y, w, h)
  return hs.geometry.rect(x, y+h/2, w, h/2)
end

layouts['east'] = function(x, y, w, h)
  return hs.geometry.rect(x+w/2, y, w/2, h)
end

layouts['west'] = function(x, y, w, h)
  return hs.geometry.rect(x, y, w/2, h)
end

layouts['ne'] = function(x, y, w, h)
  return hs.geometry.rect(x+w/2, y, w/2, h/2)
end

layouts['nw'] = function(x, y, w, h)
  return hs.geometry.rect(x, y, w/2, h/2)
end

layouts['se'] = function(x, y, w, h)
  return hs.geometry.rect(x+w/2, y+h/2, w/2, h/2)
end

layouts['sw'] = function(x, y, w, h)
  return hs.geometry.rect(x, y+h/2, w/2, h/2)
end

function layout.set_layout(str)
  return function()
    local window = hs.window.focusedWindow()
    if window then
      local f = window:screen():frame()
      window:setFrame(layouts[str](f.x, f.y, f.w, f.h))
    end
  end
end

return layout
