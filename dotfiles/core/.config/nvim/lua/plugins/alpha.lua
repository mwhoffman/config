local logos = {
  {
    "                                                                     ",
    "       ████ ██████           █████      ██                     ",
    "      ███████████             █████                             ",
    "      █████████ ███████████████████ ███   ███████████   ",
    "     █████████  ███    █████████████ █████ ██████████████   ",
    "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
    "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
    " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
  },
  {
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  },
}

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function() 
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    function button(key, txt, cmd, desc)
      opts = {noremap=true, silent=true, nowait=true, desc=desc}
      return dashboard.button(key, txt, cmd, opts)
    end

    -- Add a logo.
    dashboard.section.header.val = logos[2]
    dashboard.section.header.opts.hl = "GruvboxBlue"

    -- Add our own buttons.
    dashboard.leader = "󱁐"
    dashboard.section.buttons.val = {
      button("e",   "  New file", "<cmd>ene<cr>", "New file"),
      button("󱁐ff", "  Find files", "<leader>ff"),
      button("󱁐fs", "  Find string", "<leader>fs"),
      button("󱁐fr", "  Recent files (cwd)", "<leader>fr"),
      button("󱁐fR", "  Recent files (all)", "<leader>fR"),
      button("q",   "󰅚  Quit", "<cmd>qa<cr>", "Quit"),
    }

    -- Override the button options.
    dashboard.section.buttons.opts.inherit = {
      hl_shortcut = "GruvboxYellow",
      cursor = 2,
      width = 30,
    }

    -- Calculate the amount of whitespace.
    local whitespace = (
      vim.api.nvim_win_get_height(0) 
      - 2 * table.getn(dashboard.section.buttons.val)
      - table.getn(dashboard.section.header.val)
      - 4)

    -- Add initial padding (capped to 20).
    local padding = math.min(20, math.max(0, math.floor(whitespace / 2)))

    -- Rearrange the layout.
    dashboard.config.layout = {
      {type="padding", val=padding},
      dashboard.section.header,
      {type="padding", val=2},
      dashboard.section.buttons,
      {type="padding", val=1},
      dashboard.section.footer,
    }
    
    -- Add plugin stats. This needs to happen after Lazy has finished loading so
    -- we have to add it as an autocmd.
    vim.api.nvim_create_autocmd(
      "User",
      {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          -- Figure out how long it took us to load.
          local stats = require("lazy").stats()
          dashboard.section.footer.val = (
            "󱐋 Neovim loaded " 
            .. stats.loaded 
            .. "/"
            .. stats.count
            .. " plugins in "
            .. string.format("%.1f", stats.startuptime)
            .. "ms"
          )
          pcall(vim.cmd.AlphaRedraw)
        end,
      }
    )

    alpha.setup(dashboard.config)
  end,
}
