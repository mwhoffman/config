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
      "<leader>fc",
      "<cmd>Telescope grep_string<cr>",
      desc = "Find current string",
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
