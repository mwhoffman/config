return {
  "ojroques/nvim-osc52",
  name = "osc52",
  keys = {
    {
      "<leader>c",
      function() return require("osc52").copy_operator() end,
      expr = true,
      desc = "Copy to clipboard",
    },
    {
      "<leader>c",
      function() return require("osc52").copy_visual() end,
      mode = "v",
      desc = "Copy to clipboard",
    },
    {
      "<leader>cc",
      "<leader>c_",
      remap = true,
      desc = "Copy line to clipboard",
    },
  },
  config = true,
}
