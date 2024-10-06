return {
  "gbprod/substitute.nvim",
  keys = {
    {
      "s",
      function () require("substitute").operator() end,
      desc = "Substitute",
    },
    {
      "ss",
      function () require("substitute").line() end,
      desc = "Substitute line",
    },
    {
      "S",
      function () require("substitute").eol() end,
      desc = "Substitute to end of line",
    },
    {
      "s",
      function () require("substitute").visual() end,
      desc = "Substitute",
      mode = "v",
    },
  },
  opts = {},
}
