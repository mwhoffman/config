-- This is lualine.nvim's gruvbox theme (https://github.com/nvim-lualine/lualine.nvim),
-- which is copyright (c) 2020-2021 hoob3rt and has the MIT license.
local colors = {
  black = "#282828",
  white = "#ebdbb2",
  red = "#fb4934",
  green = "#b8bb26",
  blue = "#83a598",
  yellow = "#fe8019",
  gray = "#a89984",
  darkgray = "#3c3836",
  lightgray = "#504945",
  inactivegray = "#7c6f64",
  -- From the theme's roles, so the statusline matches the tmux bar: the normal
  -- mode badge is like the active tab, the second sections like inactive tabs,
  -- and the middle like the bar.
  active_bg = "#a89984",
  active_fg = "#282828",
  inactive_bg = "#504945",
  inactive_fg = "#a89984",
  panel = "#3c3836",
}

return {
  normal = {
    a = {bg = colors.active_bg, fg = colors.active_fg, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.lightgray, fg = colors.white},
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.inactivegray, fg = colors.black},
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.black, fg = colors.white},
  },
  command = {
    a = {bg = colors.green, fg = colors.black, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.inactivegray, fg = colors.black},
  },
  inactive = {
    a = {bg = colors.panel, fg = colors.inactive_fg, gui = "bold"},
    b = {bg = colors.panel, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
}
