-- trouble shows diagnostics (errors, warnings, etc.) in a list that we can
-- browse and jump to.
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    {
      "<leader>x",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Show diagnostics",
    },
  },
  opts = {
    warn_no_results = false,
    open_no_results = true,
  },
}
