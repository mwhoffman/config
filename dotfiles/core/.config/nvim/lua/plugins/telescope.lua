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
      "<cmd>Telescope find_files<cr>",
      desc = "Find files",
      silent = true,
    },
    {
      "<leader>fb",
      "<cmd>Telescope buffers<cr>",
      desc = "Find buffers",
      silent = true,
    },
    {
      "<leader>fg",
      "<cmd>Telescope live_grep<cr>",
      desc = "Find word (grep)",
      silent = true,
    },
    {
      "<leader>fr",
      "<cmd>Telescope oldfiles only_cwd=true<cr>",
      desc = "Find recent files (cwd)",
      silent = true,
    },
    {
      "<leader>fR",
      "<cmd>Telescope oldfiles<cr>",
      desc = "Find recent files (all)",
      silent = true,
    },
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
