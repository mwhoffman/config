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
    routes = {
      {
        -- Skip E37 messages because they basically duplicate E162.
        filter = {event = "msg_show", kind = "emsg", find = "E37"},
        opts = {skip = true},
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    -- Hide the real cursor during cmdline mode and draw a fake one in noice's
    -- cmdline instead. Otherwise noice moves the real cursor back to its
    -- cmdline after each redraw, which races with incsearch moving it to the
    -- match, so the cursor flickers between the two. This is an internal
    -- field, so it may break when noice is updated.
    require("noice.ui.cmdline").real_cursor = false
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
}
