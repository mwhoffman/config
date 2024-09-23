return {
  "folke/which-key.nvim",
  name = "which-key",
  opts = {
    preset = "helix",
    win = {
      col = 2,
    },
    plugins = {
      marks = false,
      registers = false,
      spelling = {enabled=false},
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    spec = {
      {"<leader>", group="+leader"},
      {"<leader>f", group="+find objects"},
    },
  }
}
