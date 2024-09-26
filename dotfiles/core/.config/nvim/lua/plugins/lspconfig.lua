return {
  "neovim/nvim-lspconfig",
  name = "lspconfig",
  dependencies = {
    {"williamboman/mason.nvim", name="mason"},
    {"williamboman/mason-lspconfig.nvim", name="mason-lspconfig"},
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup {}
      end
    }

    require("lspconfig")["basedpyright"].setup({
      settings = {
        basedpyright = {
          typeCheckingMode = "standard",
        }
      }
    })
  end
}
