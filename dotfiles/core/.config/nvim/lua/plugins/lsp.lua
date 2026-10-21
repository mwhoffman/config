-- Language server (LSP) support: mason installs the servers and tools,
-- nvim-lspconfig configures them and enables the ones that are installed, and
-- lazydev adds neovim's lua types when editing this config.
return {
  -- We can run :Mason to directly install and update LSPs; mason-tool-installer
  -- should ensure that the given tools are installed by default (when it first
  -- starts up).
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
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
      -- QML: use the system Qt's qmlls (qmlls6 on Arch) rather than mason's
      -- standalone build, which can't find the system's QML modules (QtQuick,
      -- Quickshell). Only where it's installed, since this config is shared.
      if vim.fn.executable("qmlls6") == 1 then
        vim.lsp.config("qmlls", {cmd = {"qmlls6"}})
        vim.lsp.enable("qmlls")
      end
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
