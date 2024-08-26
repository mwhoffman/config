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

      -- barbar-specific kemappings.
      vim.keymap.set('n', '<leader>p', ':BufferPin<cr>', {silent=true})
      vim.keymap.set('n', '<leader>q', ':BufferClose<cr>', {silent=true})
      vim.keymap.set('n', '<leader>Q', ':BufferCloseAllButCurrentOrPinned<cr>', {silent=true})
      vim.keymap.set('n', '<leader>,', ':BufferPrevious<cr>', {silent=true})
      vim.keymap.set('n', '<leader>.', ':BufferNext<cr>', {silent=true})
      vim.keymap.set('n', '<leader>1', ':BufferGoto 1<cr>', {silent=true})
      vim.keymap.set('n', '<leader>2', ':BufferGoto 2<cr>', {silent=true})
      vim.keymap.set('n', '<leader>3', ':BufferGoto 3<cr>', {silent=true})
      vim.keymap.set('n', '<leader>4', ':BufferGoto 4<cr>', {silent=true})
      vim.keymap.set('n', '<leader>5', ':BufferGoto 5<cr>', {silent=true})
      vim.keymap.set('n', '<leader>6', ':BufferGoto 6<cr>', {silent=true})
      vim.keymap.set('n', '<leader>7', ':BufferGoto 7<cr>', {silent=true})
      vim.keymap.set('n', '<leader>8', ':BufferGoto 8<cr>', {silent=true})
      vim.keymap.set('n', '<leader>9', ':BufferGoto 9<cr>', {silent=true})
      vim.keymap.set('n', '<leader>0', ':BufferLast<cr>', {silent=true})
    end,
  }
}
