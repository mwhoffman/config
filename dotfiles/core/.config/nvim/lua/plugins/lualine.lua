return {
  "nvim-lualine/lualine.nvim",
  dependencies={
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    sections={
      lualine_a = {"mode"},
      lualine_b = {"branch", "diagnostics"},
      lualine_c = {"filename"},
      lualine_x = {"filetype"},
      lualine_y = {},
      lualine_z = {"progress"},
    },
    inactive_sections={
      lualine_a = {},
      lualine_b = {},
      lualine_c = {"filename"},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {"neo-tree"},
    options = {
      theme = "auto",
      disabled_filetypes = {"alpha", "trouble"},
      section_separators = {left='', right=''},
      component_separators = {left='', right=''},
    },
  },
}
