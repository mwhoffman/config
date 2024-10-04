return {
  "lewis6991/gitsigns.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
    signs = {
      delete = {text="▁"},
      topdelete = {text="▔"},
    },
  }
}
