-- substitute adds an operator which replaces text with the contents of a
-- register, e.g. siw replaces the word under the cursor with the last yank,
-- without overwriting that register.
return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "s",
      function() require("substitute").operator() end,
      desc = "Substitute",
    },
    {
      "ss",
      function() require("substitute").line() end,
      desc = "Substitute line",
    },
    {
      "S",
      function() require("substitute").eol() end,
      desc = "Substitute to end of line",
    },
    {
      "s",
      function() require("substitute").visual() end,
      desc = "Substitute",
      mode = "v",
    },
  },
  opts = {},
}
