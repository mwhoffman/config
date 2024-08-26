-- Mark netrw as already loaded so we can use nvim-tree instead.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  'nvim-tree/nvim-tree.lua',
  name = 'nvim-tree',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Set up the plugin.
    require('nvim-tree').setup({
      renderer = {
        symlink_destination = false,
        icons = {
          git_placement = 'after',
        },
      },
      view = {
        width = {max=60},
      },
      filters = {
        custom = {'^\\.git$'},
      },
    })

    -- Set nvim-specific keymappings.
    vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {silent=true})
    
    -- Save the global guicursor setting.
    local opt_guicursor = vim.opt.guicursor

    -- Add an autocmd to turn on the cursorline and hide the cursor whenever we
    -- enter the nvim-tree window.
    vim.api.nvim_create_autocmd(
      {"WinEnter", "BufWinEnter", "ColorScheme"},
      {
        callback = function ()
          if vim.bo.filetype == "NvimTree" then
            vim.opt.cursorline = true
            vim.opt.guicursor = "a:block-Cursor"
            vim.cmd "hi Cursor blend=100"
          end
        end
      })

    -- Create an autocmd to restore the cursor. Note cursorline should be a
    -- local opt, so by setting this we're only changing the cursorline for the
    -- nvim-tree window.
    vim.api.nvim_create_autocmd(
      {"WinLeave", "BufWinLeave"},
      {
        callback = function ()
          if vim.bo.filetype == "NvimTree" then
            vim.opt.cursorline = false
            vim.opt.guicursor = opt_guicursor
          end
        end
      })
  end
}

