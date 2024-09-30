return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup {}
      end
    }

    -- TODO: remove the setup below for now because I don't want basedpyright
    -- installed everywhere.

    -- require("lspconfig")["basedpyright"].setup({
    --   settings = {
    --     basedpyright = {
    --       typeCheckingMode = "standard",
    --     }
    --   }
    -- })
  end
}
