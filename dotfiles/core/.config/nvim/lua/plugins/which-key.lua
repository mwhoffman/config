return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    icons = {mappings=false},
    plugins = {
      marks = false,
      registers = false,
      spelling = {enabled=true},
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
      {"<leader>", group="Leader", mode="nv"},
      {"<leader>c", group="Copy…"},
      {"<leader>f", group="Find…"},
      {"<leader>h", group="Harpoon…"},
      {"<leader>s", group="Split…"},
      {"h", hidden=true, mode="n"},
      {"j", hidden=true, mode="n"},
      {"k", hidden=true, mode="n"},
      {"l", hidden=true, mode="n"},
      {"Y", desc="Yank to End of Line"},
      {"D", desc="Delete to End of Line"},
      {"&", desc="Repeat last substitution"},
      {"<C-L>", desc="Clear screen"},
      {"/", hidden=true, mode="o"},
      {"?", hidden=true, mode="o"},
    },
  }
}
