return {
  'romgrk/barbar.nvim',
  name = 'barbar',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  keys = {
    {'<leader>p', ':BufferPin<cr>'},
    {'<leader>q', ':BufferClose<cr>'},
    {'<leader>Q', ':BufferCloseAllButCurrentOrPinned<cr>'},
    {'<leader>,', ':BufferPrevious<cr>'},
    {'<leader>.', ':BufferNext<cr>'},
    {'<leader>1', ':BufferGoto 1<cr>'},
    {'<leader>2', ':BufferGoto 2<cr>'},
    {'<leader>3', ':BufferGoto 3<cr>'},
    {'<leader>4', ':BufferGoto 4<cr>'},
    {'<leader>5', ':BufferGoto 5<cr>'},
    {'<leader>6', ':BufferGoto 6<cr>'},
    {'<leader>7', ':BufferGoto 7<cr>'},
    {'<leader>8', ':BufferGoto 8<cr>'},
    {'<leader>9', ':BufferGoto 9<cr>'},
    {'<leader>0', ':BufferLast<cr>'},
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    icons = {
      separator = {left='▕', right=''},
      inactive = {separator={left='▕', right=''}},
      filetype = {enabled=false},
      buffer_index = true,
      button = false,
    },
    sidebar_filetypes = {
      NvimTree = true,
    },
  }
}
