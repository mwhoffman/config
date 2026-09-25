-- indent-blankline draws guides at each indentation level.
return {
  "lukas-reineke/indent-blankline.nvim",
  event = {"BufReadPre", "BufNewFile"},
  main = "ibl",
  opts = {
    indent = {char = "┆"},
  },
}
