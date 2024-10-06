return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
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
      "<leader>fs",
      "<cmd>Telescope live_grep<cr>",
      desc = "Find string",
      silent = true,
    },
    {
      "<leader>fw",
      "<cmd>Telescope grep_string<cr>",
      desc = "Find string under cursor",
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
        -- Ignore git commit messages.
        ".git/COMMIT_EDITMSG",

        -- Ignore vimdocs.
        "/usr/share/nvim/runtime/doc/.+",
        vim.env.HOME .. "/%.local/share/nvim/lazy/.+/doc/.+",
        vim.env.HOME .. "/%.local/state/nvim/lazy/readme/doc/.+",
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
        find_command = {"fd", "--ignore", "--hidden"}
      }
    },
  },
}
