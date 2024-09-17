local function extra_config ()
  -- Save the global guicursor setting.
  local opt_guicursor = vim.opt.guicursor
  local opt_cursorline = vim.opt.cursorline

  -- Behavior when we enter a new window or change the color scheme.
  vim.api.nvim_create_autocmd(
    {'WinEnter', 'BufWinEnter', 'ColorScheme', 'CmdlineLeave'},
    {
      callback = function ()
        if vim.bo.filetype == 'NvimTree' then
          -- When we enter a tree-window hide the cursor and turn the cursorline
          -- on, i.e. we will treat this as our cursor.
          vim.opt.cursorline = true
          vim.opt.guicursor = 'a:block-Cursor'
          vim.cmd 'hi Cursor blend=100'
        else
          -- When we enter any other window return to the standard cursor.
          vim.opt.cursorline = opt_cursorline
          vim.opt.guicursor = opt_guicursor
        end
      end
    })

  -- When we leave an nvim-tree window turn the cursorline off to indicate that
  -- we are not focusing that window.
  vim.api.nvim_create_autocmd(
    {'WinLeave', 'BufWinLeave'},
    {
      callback = function ()
        if vim.bo.filetype == 'NvimTree' then
          vim.opt.cursorline = false
        end
      end
    })

  -- Return to the standard cursor when we enter the cmdline.
  vim.api.nvim_create_autocmd(
    {'CmdlineEnter'},
    {
      callback = function ()
        vim.opt.guicursor = opt_guicursor
      end
    })
end

return {
  'nvim-tree/nvim-tree.lua',
  name = 'nvim-tree',
  lazy = false,
  enabled = false,
  dependencies = {
    {'nvim-tree/nvim-web-devicons', name='web-devicons'}
  },
  keys = {
    {'<leader>t', ':NvimTreeToggle<cr>', silent=true},
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
        root_folder_label = function (path)
          return ' ' .. vim.fn.fnamemodify(path, ':t')
        end,
      },
      sort = {
        sorter='case_sensitive',
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

