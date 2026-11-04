-- This is catppuccin/nvim's lualine theme (https://github.com/catppuccin/nvim),
-- which is copyright (c) 2021 Catppuccin and has the MIT license.
local colors = {
  green = "#a6d189",
  peach = "#ef9f76",
  mauve = "#ca9ee6",
  red = "#e78284",
  base = "#303446",
  -- From the theme's roles, so the statusline matches the tmux bar: the normal
  -- mode badge is like the active tab, the second sections like inactive tabs,
  -- and the middle like the bar.
  active_bg = "#949cbb",
  active_fg = "#303446",
  inactive_bg = "#51576d",
  inactive_fg = "#949cbb",
  panel = "#292c3c",
}

return {
  normal = {
    a = {bg = colors.active_bg, fg = colors.active_fg, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
  insert = {
    a = {bg = colors.green, fg = colors.base, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  terminal = {
    a = {bg = colors.green, fg = colors.base, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  command = {
    a = {bg = colors.peach, fg = colors.base, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  visual = {
    a = {bg = colors.mauve, fg = colors.base, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  replace = {
    a = {bg = colors.red, fg = colors.base, gui = "bold"},
    b = {bg = colors.inactive_bg, fg = colors.inactive_fg},
  },
  inactive = {
    a = {bg = colors.panel, fg = colors.inactive_fg, gui = "bold"},
    b = {bg = colors.panel, fg = colors.inactive_fg},
    c = {bg = colors.panel, fg = colors.inactive_fg},
  },
}
