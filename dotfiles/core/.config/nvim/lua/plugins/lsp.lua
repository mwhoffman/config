return {
  -- Mason is a package manager for LSP servers, linters, etc.
  {
    "mason-org/mason.nvim",
    opts = {}
  },

  -- Ensure that certain mason tools are installed by default.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "ruff",
        "ty",
        "tree-sitter-cli",
      },
    },
  },

  -- Configure the servers and enable the ones mason has installed. This
  -- shouldn't be lazy loaded: once nvim has started vim.lsp.enable() re-fires
  -- FileType, and if that happens while loading on BufNewFile it stops the new
  -- buffer from getting a filetype.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      require("mason-lspconfig").setup()
    end,
  },

  -- Enable the neovim runtime and plugin types when editing lua files in a root
  -- workspace that is in or under a directory named nvim. The lua language
  -- server identifies the root dir of a workspace by the existence of a
  -- .luarc.json file or .git directory.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      enabled = function(root_dir)
        return vim.list_contains(vim.split(root_dir, "/"), "nvim")
      end,
    },
  },
}
