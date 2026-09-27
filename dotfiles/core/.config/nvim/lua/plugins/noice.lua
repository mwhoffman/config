-- Noice provides UI replacements for messages, cmdline, and popupmenu.
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- Noice draws hover and signature help in its own popups, which ignore
    -- 'winborder', so add a border to them.
    presets = {
      lsp_doc_border = true,
    },
    -- Show the cmdline at the bottom (rather than in a popup) but keep noice's
    -- icons and highlighting.
    cmdline = {
      view = "cmdline",
    },
    -- Don't show the search count next to the cursor; lualine's searchcount
    -- component already shows it in the statusline.
    messages = {
      view_search = false,
    },
    -- Don't notify when hover has nothing to show.
    lsp = {
      hover = {silent = true},
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
}
