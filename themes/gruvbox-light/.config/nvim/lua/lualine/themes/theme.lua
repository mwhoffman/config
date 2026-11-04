-- This is lualine.nvim's gruvbox theme (https://github.com/nvim-lualine/lualine.nvim),
-- which is copyright (c) 2020-2021 hoob3rt and has the MIT license.
local colors = {
  black = "#fbf1c7",
  white = "#3c3836",
  red = "#9d0006",
  green = "#79740e",
  blue = "#076678",
  yellow = "#af3a03",
  gray = "#7c6f64",
  darkgray = "#ebdbb2",
  lightgray = "#d5c4a1",
  inactivegray = "#a89984",
  -- From the theme's roles, so the statusline matches the tmux bar: the normal
  -- mode badge is like the active tab, the second sections like inactive tabs,
  -- and the middle like the bar.
  active_bg = "#7c6f64",
  active_fg = "#fbf1c7",
  inactive_bg = "#d5c4a1",
  inactive_fg = "#7c6f64",
  panel = "#ebdbb2",
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
