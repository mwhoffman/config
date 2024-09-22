return {
  "nvim-telescope/telescope.nvim",
  name="telescope",
  dependencies = {
    {"nvim-lua/plenary.nvim", name="plenary"},
    "BurntSushi/ripgrep",
  },
  lazy = false,
  keys = {
    {"<leader>ff", "<cmd>Telescope find_files<cr>", silent=true},
    {"<leader>fb", "<cmd>Telescope buffers<cr>", silent=true},
    {"<leader>fg", "<cmd>Telescope live_grep<cr>", silent=true},
    {"<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<cr>", silent=true},
    {"<leader>fR", "<cmd>Telescope oldfiles<cr>", silent=true},
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        ".git/COMMIT_EDITMSG$",
        "/usr/share/nvim/runtime/doc/.+%.txt",
        vim.env.HOME .. "/%.local/share/nvim/lazy/.+/doc/.+%.txt",
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      }
    },
    pickers = {
      find_files = {
        find_command = {"rg", "--ignore", "--hidden", "-L", "--files"}
      }
    },
  },
}
