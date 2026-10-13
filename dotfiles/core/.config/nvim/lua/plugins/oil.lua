-- Oil shows a directory as a buffer which can be edited to create, rename,
-- move and delete files. We use it in place of netrw when editing a directory.
return {
  "stevearc/oil.nvim",
  dependencies = {"nvim-mini/mini.icons"},
  -- Oil's docs advise against lazy loading, and it needs to be loaded at
  -- startup to handle `nvim <directory>` anyway.
  lazy = false,
  -- Disable netrw so it doesn't flash underneath when we open directories.
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    view_options = {
      -- Show dotfiles, other than .git and the parent directory entry.
      show_hidden = true,
      is_always_hidden = function(name)
        return name == ".." or name == ".git"
      end,
    },
  },
  keys = {
    {"-", "<cmd>Oil<cr>", desc = "Open parent directory"},
  },
}
