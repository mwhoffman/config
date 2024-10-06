return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>b",
      function () require("snipe").open_buffer_menu() end,
      desc = "Buffer menu"
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
