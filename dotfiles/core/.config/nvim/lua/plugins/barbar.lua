local function extra_config ()
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
end

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
    opts = function()
      -- Run any extra config.
      extra_config()

      -- Return the options.
      return {
        icons = {
          separator = {left='▕', right=''},
          inactive = {separator={left='▕', right=''}},
          filetype = {enabled=false},
          buffer_index = 'superscript',
          button = false,
        },
        sidebar_filetypes = {
          NvimTree = true,
        },
      }
    end,
  }
}
