return {
  {
    'nvim-lualine/lualine.nvim',
    name='lualine',
    dependencies={'nvim-tree/nvim-web-devicons'},
    config=function()
      require('lualine').setup({
        sections={
          lualine_a={'mode'},
          lualine_b={'branch', 'diff', 'diagnostics'},
          lualine_c={'filename'},
          lualine_x={'filetype'},
          lualine_y={},
          lualine_z={'progress'},
        },
        extensions={'nvim-tree'},
        options={theme='gruvbox'},
      })
    end,
  },
}
