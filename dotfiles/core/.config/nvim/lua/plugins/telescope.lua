return {
  "nvim-telescope/telescope.nvim",
  name="telescope",
  dependencies = {
    {"nvim-lua/plenary.nvim", name="plenary"},
    "BurntSushi/ripgrep",
  },
  lazy = false,
  keys = {
    {
      "<leader>ff",
      ":Telescope find_files find_command=rg,--ignore,--hidden,-L,--files<cr>",
      silent=true
    },
    {"<leader>fb", ":Telescope buffers<cr>", silent=true},
  },
  opts = {},
}
