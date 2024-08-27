local function extra_config ()
  -- Set nvim-specific keymappings.
  vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {silent=true})
  
  -- Save the global guicursor setting.
  local opt_guicursor = vim.opt.guicursor

  -- Add an autocmd to turn on the cursorline and hide the cursor whenever we
  -- enter the nvim-tree window.
  vim.api.nvim_create_autocmd(
    {"WinEnter", "BufWinEnter", "ColorScheme", "CmdlineLeave"},
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

  -- Turn the cursor back on if we enter the command line.
  vim.api.nvim_create_autocmd(
    {"CmdlineEnter"},
    {
      callback = function ()
        vim.opt.guicursor = opt_guicursor
      end
    })

end

return {
  'nvim-tree/nvim-tree.lua',
  name = 'nvim-tree',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function ()
    -- Mark netrw as already loaded so we can use nvim-tree instead.
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = function()
    -- Run any extra config.
    extra_config()

    -- Return the plugin's options.
    return {
      renderer = {
        symlink_destination = false,
        special_files = {},
        icons = {
          git_placement = 'after',
        },
      },
      sort = {
        sorter="case_sensitive",
        folders_first=false,
      },
      view = {
        width = {max=60},
      },
      filters = {
        custom = {'^\\.git$'},
      },
    }
  end,
}

