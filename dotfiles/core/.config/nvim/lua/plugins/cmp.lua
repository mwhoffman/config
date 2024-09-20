return {
  "hrsh7th/nvim-cmp",
  name = "cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
  },
  opts = function()
    local cmp = require("cmp")

    return {
      completion = {completeopt="menu,menuone,noinsert"},

      -- Mappings during completions.
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<C-y>"] = cmp.mapping.confirm { select = true },
      },
      sources = {
        {name="nvim_lsp"},
        {name="path"},
        {name="emoji"},
      }
    }
  end,
}


