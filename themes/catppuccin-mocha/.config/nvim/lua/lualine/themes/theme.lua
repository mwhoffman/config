-- This is catppuccin/nvim's lualine theme (https://github.com/catppuccin/nvim),
-- which is copyright (c) 2021 Catppuccin and has the MIT license.
local colors = {
  green = "#a6e3a1",
  peach = "#fab387",
  mauve = "#cba6f7",
  red = "#f38ba8",
  base = "#1e1e2e",
  -- From the theme's roles, so the statusline matches the tmux bar: the normal
  -- mode badge is like the active tab, the second sections like inactive tabs,
  -- and the middle like the bar.
  active_bg = "#9399b2",
  active_fg = "#1e1e2e",
  inactive_bg = "#45475a",
  inactive_fg = "#9399b2",
  panel = "#181825",
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
