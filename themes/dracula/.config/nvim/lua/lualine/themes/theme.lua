-- This is dracula.nvim's lualine theme (https://github.com/Mofiqul/dracula.nvim),
-- which is copyright (c) 2021 Mofiqul Islam and has the MIT license.
local colors = {
  black = "#21222c",
  white = "#afb0b0",
  purple = "#bd93f9",
  green = "#50fa7b",
  pink = "#ff79c6",
  yellow = "#f1fa8c",
  cyan = "#8be9fd",
  -- From the theme's roles, so the statusline matches the tmux bar: the normal
  -- mode badge is like the active tab, the second sections like inactive tabs,
  -- and the middle like the bar.
  active_bg = "#909194",
  active_fg = "#21222c",
  inactive_bg = "#424450",
  inactive_fg = "#909194",
  panel = "#343746",
}

return {
  normal = {
    a = {bg = colors.active_bg, fg = colors.active_fg, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
  insert = {
    a = {bg = colors.green, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.white},
  },
  visual = {
    a = {bg = colors.pink, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  replace = {
    a = {bg = colors.yellow, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.white},
  },
  command = {
    a = {bg = colors.cyan, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  inactive = {
    a = {bg = colors.panel, fg = colors.inactive_fg, gui = "bold"},
    b = {bg = colors.panel, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
}
