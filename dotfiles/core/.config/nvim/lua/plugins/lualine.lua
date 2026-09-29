-- lualine replaces the default statusline with a prettier, configurable one.
return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_a = {"mode"},
      lualine_b = {"branch", "diagnostics"},
      lualine_c = {"filename"},
      lualine_x = {"filetype"},
      lualine_y = {"searchcount"},
      lualine_z = {"progress"},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {"filename"},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    -- Label neo-tree windows rather than showing the working directory (which
    -- is what lualine's own neo-tree extension does).
    extensions = {
      {
        filetypes = {"neo-tree"},
        sections = {lualine_a = {function() return "NeoTree" end}},
      },
    },
    options = {
      theme = "auto",
      disabled_filetypes = {"alpha", "trouble"},
      section_separators = {left = '', right = ''},
      component_separators = {left = '', right = ''},
    },
  },
}
