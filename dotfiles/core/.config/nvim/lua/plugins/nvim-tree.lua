-- Mark netrw as already loaded so we can use nvim-tree instead.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  'nvim-tree/nvim-tree.lua',
  name='nvim-tree',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      renderer = {
        symlink_destination=false,
        icons = {
          git_placement='after'
        }
      }
    })
  end
}

