-- telescope is a fuzzy finder with a preview window. We use it to find files,
-- recent files and strings (searched with ripgrep).
local spec = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
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
      },
      -- Show the same status letters as `git status --short` (the first column
      -- is the staged status and the second is the unstaged status).
      git_status = {
        git_icons = {
          added = "A",
          changed = "M",
          copied = "C",
          deleted = "D",
          renamed = "R",
          unmerged = "U",
          untracked = "?",
        },
      },
    },
  },
}

-- Lazy-load on the :Telescope command.
spec.cmd = "Telescope"

-- Lazy-load when these keys are used.
spec.keys = {
  {
    "<leader>ff",
    "<cmd>Telescope find_files<cr>",
    desc = "Find files",
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
    "<leader>fg",
    "<cmd>Telescope git_status<cr>",
    desc = "Find git changes",
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
}

return spec
