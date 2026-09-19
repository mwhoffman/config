return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {"mason-org/mason.nvim"},
  opts = {
    ensure_installed = {
      "lua-language-server",
      "ruff",
      "ty",
      "tree-sitter-cli",
    },
  },
}
