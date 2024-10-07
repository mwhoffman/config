return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = {"BufReadPre", "BufNewFile"},
  keys = {
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
