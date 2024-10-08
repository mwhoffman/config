return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>s",
      function () require("snipe").open_buffer_menu() end,
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
