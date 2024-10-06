return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
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

    require("neodev").setup({lspconfig=true})

    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup(overrides[server_name] or {})
      end
    }
  end
}
