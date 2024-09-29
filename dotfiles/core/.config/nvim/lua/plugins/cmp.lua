return {
  "hrsh7th/nvim-cmp",
  name = "cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
  },
  opts = function()
    local cmp = require("cmp")

    return {
      completion = {completeopt="menu,menuone,noinsert,preview"},

      -- Mappings during completions.
      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm {select=true},
      },
      sources = {
        {name="nvim_lsp"},
        {name="path"},
      }
    }
  end,
}


