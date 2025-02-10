return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  init = function ()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup(
        "Neotree_start_directory",
        {clear=true}
      ),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>t",
      ":Neotree toggle reveal_force_cwd position=float<cr>",
      desc = "File tree (floating)",
      silent = true
    },
    {
      "<leader>b",
      ":Neotree buffers toggle position=float<cr>",
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
