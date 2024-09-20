local logo = {
  [[                                                                     ]],
  [[       ████ ██████           █████      ██                     ]],
  [[      ███████████             █████                             ]],
  [[      █████████ ███████████████████ ███   ███████████   ]],
  [[     █████████  ███    █████████████ █████ ██████████████   ]],
  [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
  [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
  [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
}

return {
  "goolord/alpha-nvim",
  name = "alpha",
  event = "VimEnter",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function() 
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = logo
    dashboard.section.header.opts.hl = "GruvboxBlue"

    dashboard.section.buttons.val = {
      dashboard.button("e", " New file", "<cmd>ene<cr>"),
      dashboard.button("f", " Find files", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", " Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("q", "󰅚 Quit", "<cmd>qa<cr>"),
    }

    dashboard.section.buttons.opts.inherit = {
      hl_shortcut = "GruvboxYellow",
      cursor = 30,
      width = 30,
    }

    alpha.setup(dashboard.config)
  end,
}
