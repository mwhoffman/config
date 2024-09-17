-- Register a function which makes the buffer labels bold. This is cheap enough
-- that we don't really need to worry about making it lazy, and it won't really
-- do anything if we disable barbar.
vim.api.nvim_create_autocmd(
  {"ColorScheme"},
  {
    callback = function ()
      vim.cmd 'hi! BufferDefaultCurrent gui=bold'
      vim.cmd 'hi! BufferDefaultCurrentMod gui=bold'
    end
  })

return {
  'romgrk/barbar.nvim',
  name = 'barbar',
  enabled = false,
  dependencies = {
    {'lewis6991/gitsigns.nvim', name='gitsigns'},
    {'nvim-tree/nvim-web-devicons', name='web-devicons'},
  },
  lazy = false,
  keys = {
    {'<leader>q', ':BufferClose<cr>', silent=true},
    {'<leader>Q', ':BufferCloseAllButCurrent<cr>', silent=true},
    {'<leader>,', ':BufferPrevious<cr>', silent=true},
    {'<leader>.', ':BufferNext<cr>', silent=true},
    {'<leader>0', ':BufferLast<cr>', silent=true},
    {'<leader>1', ':BufferGoto 1<cr>', silent=true},
    {'<leader>2', ':BufferGoto 2<cr>', silent=true},
    {'<leader>3', ':BufferGoto 3<cr>', silent=true},
    {'<leader>4', ':BufferGoto 4<cr>', silent=true},
    {'<leader>5', ':BufferGoto 5<cr>', silent=true},
    {'<leader>6', ':BufferGoto 6<cr>', silent=true},
    {'<leader>7', ':BufferGoto 7<cr>', silent=true},
    {'<leader>8', ':BufferGoto 8<cr>', silent=true},
    {'<leader>9', ':BufferGoto 9<cr>', silent=true},
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
