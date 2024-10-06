return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  init = function ()
    -- Mark netrw as already loaded so we can use nvim-tree instead.
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    {
      "<leader>t",
      ":Neotree toggle reveal_force_cwd position=float<cr>",
      desc = "File tree (floating)",
      silent = true
    },
    {
      "<leader>T",
      ":Neotree toggle reveal_force_cwd position=left<cr>",
      desc = "File tree (sidebar)",
      silent = true
    },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    window = {
      width = 30,
      auto_expand_width = true,
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        never_show = {
          ".git",
        },
      },
      hijack_netrw_behavior = "open_current",
    },
    default_component_configs = {
      indent = {indent_marker="┆"},
      file_size = {enabled=false},
      type = {enabled=false},
      last_modified = {enabled=false},
      created = {enabled=false},
      symlink_target = {enabled=false}
    }
  },
}
