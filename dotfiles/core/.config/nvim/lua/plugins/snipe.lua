-- snipe opens a menu of open buffers, where each buffer gets a short key to
-- jump straight to it.
return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>s",
      -- Open the menu, and dim the editor behind it (the menu's window is
      -- unset if there was nothing to show).
      function()
        local snipe = require("snipe")
        snipe.open_buffer_menu()
        local win = snipe.global_menu.win
        if type(win) == "number" and vim.api.nvim_win_is_valid(win) then
          require("backdrop").open(win)
        end
      end,
      desc = "Snipe buffers"
    }
  },
  opts = {
    ui = {
      max_width = -1,
      position = "center",
    },
    sort = "last",
  }
}
