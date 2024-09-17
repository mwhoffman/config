return {
  'nvim-lualine/lualine.nvim',
  name='lualine',
  dependencies={'nvim-tree/nvim-web-devicons'},
  opts = {
    sections={
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'filetype'},
      lualine_y = {},
      lualine_z = {'progress'},
    },
    inactive_sections={
      lualine_a = {'filename'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {'neo-tree'},
    options = {
      theme = 'auto',
    },
  },
}
