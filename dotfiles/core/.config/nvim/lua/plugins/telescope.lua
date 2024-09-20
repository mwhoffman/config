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
  },
  opts = {
    defaults = {
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
