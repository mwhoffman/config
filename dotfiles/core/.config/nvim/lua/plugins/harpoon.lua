return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>hm",
      function()
        require("harpoon.mark").add_file()
        print("Mark added")
      end,
      desc = "Add mark",
    },
    {
      "<leader>hh",
      function() require("harpoon.ui").toggle_quick_menu() end,
      desc = "Show marks",
    },
    {
      "<leader>hn",
      function() require("harpoon.ui").nav_next() end,
      desc = "Next mark",
    },
    {
      "<leader>hp",
      function() require("harpoon.ui").nav_prev() end,
      desc = "Previous mark",
    },
  },
  opts = {},
}
