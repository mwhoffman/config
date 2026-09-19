local function ruff_attach()
  -- If and when ruff is attached add a command to organize imports.
  vim.api.nvim_buf_set_keymap(
    0, "n", "<leader>li",
    '<cmd>lua vim.lsp.buf.code_action({context={only={"source.organizeImports"}}, apply=true})<cr>',
    {desc="Organize imports."}
  )
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "folke/neodev.nvim",
  },
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    require("neodev").setup({lspconfig=true})

    vim.lsp.config("ruff", {
      on_attach = ruff_attach,
    })

    require("mason-lspconfig").setup()
  end
}
