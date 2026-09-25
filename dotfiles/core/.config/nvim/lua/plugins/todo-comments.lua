-- todo-comments highlights TODO, FIXME, NOTE, etc. comments, and lets us jump
-- between them or search for them with telescope.
local spec = {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    highlight = {
      -- vimgrep regex which matches whitespace followed by a todo comment of
      -- the form "TODO:" or "TODO(string):". Note, this will have false
      -- positives for todos that appear within a comment due the fact that it
      -- is not possible to search only at the beginning of a comment.
      pattern = [[\s+<((KEYWORDS)%(\(.+\))?):]],
      keyword = "wide",
    },
    search = {
      -- Define the pattern to use for :TodoTelescope. See the above for a
      -- note on "false positives".
      pattern = [[\s+\b(KEYWORDS)(\(.+\))?:]],
    },
  }
}

-- Load when a file is opened, to highlight its todo comments.
spec.event = {"BufReadPre", "BufNewFile"}

-- Lazy-load when these keys are used.
spec.keys = {
  {
    "]t",
    function() return require("todo-comments").jump_next() end,
    desc = "Next todo comment",
  },
  {
    "[t",
    function() return require("todo-comments").jump_prev() end,
    desc = "Previous todo comment",
  },
  {
    "<leader>ft",
    "<cmd>:TodoTelescope<cr>",
    desc = "Find todo comments",
  },
}

return spec
