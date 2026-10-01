-- snacks is a collection of small plugins, but we only enable its picker: a
-- fuzzy finder with a preview window. We use it to find files, recent files,
-- strings (searched with ripgrep), git changes and diagnostics. It also
-- replaces vim.ui.select (used e.g. for LSP code actions).
local spec = {
  "folke/snacks.nvim",
  -- Load after startup rather than on the keys below, so that vim.ui.select is
  -- replaced before anything uses it. Only the picker is enabled, so this is
  -- cheap, and its modules are only loaded when a picker is opened.
  event = "VeryLazy",
  opts = {
    picker = {
      sources = {
        files = {hidden = true},
        grep = {hidden = true},
        grep_word = {hidden = true},
        recent = {
          filter = {
            -- Also skip nvim's own help files (the plugin docs are in the data
            -- dir, which snacks already skips).
            paths = {[vim.env.VIMRUNTIME .. "/doc"] = false},
            -- And git commit messages.
            filter = function(item)
              return not item.file:match("/%.git/COMMIT_EDITMSG$")
            end,
          },
        },
      },
      -- Show the same status letters as `git status --short`. A staged change
      -- is still shown with snacks' staged icon.
      icons = {
        git = {
          added = "A",
          deleted = "D",
          modified = "M",
          renamed = "R",
          unmerged = "U",
          untracked = "?",
        },
      },
    },
  },
}

-- Open the given picker. This requires snacks rather than using its Snacks
-- global so it works whether or not snacks has loaded yet.
local function pick(source, opts)
  return function()
    require("snacks").picker[source](opts)
  end
end

spec.keys = {
  {
    "<leader>ff",
    pick("files"),
    desc = "Find files",
  },
  {
    "<leader>fs",
    pick("grep"),
    desc = "Find string",
  },
  {
    "<leader>fw",
    pick("grep_word"),
    desc = "Find string under cursor",
  },
  {
    "<leader>fg",
    pick("git_status"),
    desc = "Find git changes",
  },
  {
    "<leader>fr",
    pick("recent", {filter = {cwd = true}}),
    desc = "Find recent files (cwd)",
  },
  {
    "<leader>fR",
    pick("recent"),
    desc = "Find recent files (all)",
  },
  {
    "<leader>fd",
    pick("diagnostics"),
    desc = "Find diagnostics",
  },
}

return spec
