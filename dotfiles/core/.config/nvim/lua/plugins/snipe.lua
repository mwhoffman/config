-- snipe opens a menu of open buffers, where each buffer gets a short key to
-- jump straight to it.
return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>s",
      function() require("snipe").open_buffer_menu() end,
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
