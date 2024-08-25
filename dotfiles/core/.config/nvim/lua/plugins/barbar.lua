return {
  {
    'romgrk/barbar.nvim',
    name = 'barbar',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config=function()
      require('barbar').setup({
        icons = {
          separator = {left='▕', right=''},
          inactive = {separator={left='▕', right=''}},
        },
        sidebar_filetypes = {
          NvimTree = true,
        },
      })
    end,
  }
}