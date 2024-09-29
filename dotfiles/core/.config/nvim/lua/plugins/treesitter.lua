return {
  "nvim-treesitter/nvim-treesitter",
  event = {"BufReadPre", "BufNewFile"},
  main = "nvim-treesitter.configs",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline",
      "python", "vim", "vimdoc"
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Remove any languages that rely on vim's regex highlighting system (e.g.
      -- ruby) for indentation.
      additional_vim_regex_highlighting = {"ruby"},
    },
    indent = {
      enable = true,
      -- Ditto above.
      disable = {"ruby"}
    },
  },
}
