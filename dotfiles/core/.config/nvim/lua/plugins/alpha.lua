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

    function button(key, txt, cmd, desc)
      opts = {noremap=true, silent=true, nowait=true, desc=desc}
      return dashboard.button(key, txt, cmd, opts)
    end

    dashboard.leader = "󱁐"
    dashboard.section.header.val = logo
    dashboard.section.header.opts.hl = "GruvboxBlue"
    dashboard.section.buttons.val = {
      button("e", " New file", "<cmd>ene<cr>", "New file"),
      button("󱁐ff", " Find files", "<leader>ff"),
      button("󱁐fg", " Find word (grep)", "<leader>fg"),
      button("󱁐fr", " Recent files (cwd)", "<leader>fr"),
      button("󱁐fR", " Recent files (all)", "<leader>fR"),
      button("q", "󰅚 Quit", "<cmd>qa<cr>", "Quit"),
    }

    dashboard.section.buttons.opts.inherit = {
      hl_shortcut = "GruvboxYellow",
      cursor = 0,
      width = 30,
    }

    alpha.setup(dashboard.config)
  end,
}
