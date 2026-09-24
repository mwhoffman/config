-- Neo-tree is a plugin for browsing the file system and other tree-like
-- structures.
local spec = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- Neo-tree itself is lazy loaded, so we don't need to rely on the plugin
  -- manager for this.
  lazy = false,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    window = {
      width = 40,
      auto_expand_width = false,
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
        },
      },
      hijack_netrw_behavior = "open_default",
    },
    default_component_configs = {
      indent = {indent_marker = "┆"},
      file_size = {enabled = false},
      type = {enabled = false},
      last_modified = {enabled = false},
      created = {enabled = false},
      symlink_target = {enabled = false}
    }
  },
}

-- This doesn't affect the lazy-loading behavior because we set lazy=False, but
-- the descriptions are also used by which-key to display command information.
spec.keys = {
  {
    "<leader>t",
    "<cmd>Neotree toggle reveal_force_cwd position=float<cr>",
    desc = "File tree (floating)",
  },
  {
    "<leader>b",
    "<cmd>Neotree buffers toggle position=float<cr>",
    desc = "Buffer tree (floating)",
  },
  {
    "<leader>T",
    "<cmd>Neotree toggle reveal_force_cwd position=left<cr>",
    desc = "File tree (sidebar)",
  },
}

-- Disable netrw so it doesn't flash underneath when we open directories.
spec.init = function()
  vim.g.loaded_netrwPlugin = 1
end

return spec
