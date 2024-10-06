return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    local tc = require("todo-comments")
    local km = vim.keymap

    km.set("n", "]t", tc.jump_next, {desc="Next todo comment"})
    km.set("n", "[t", tc.jump_prev, {desc="Previous todo comment"})
    km.set("n", "<leader>ft", "<cmd>:TodoTelescope<cr>", {desc="Find todos"})

    tc.setup({
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
    })
  end
}
