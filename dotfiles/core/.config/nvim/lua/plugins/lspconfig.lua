return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- This defines local overrides that will be applied only if and when the
    -- LSP is set up by mason-lspconfig. Each item in overrides defines the
    -- table that is passed to the associated lspconfig setup call.
    local overrides = {
      basedpyright = {
        settings = {
          basedpyright = {
            typeCheckingMode = "standard",
          }
        }
      },
    }

    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        settings = overrides[server_name] or {}
        require("lspconfig")[server_name].setup(settings)
      end
    }
  end
}
