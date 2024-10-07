return {
  "epwalsh/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = {
    "BufReadPre " .. vim.fn.expand "~" .. "/vault/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/vault/*.md",
  },
  keys = {
    {
      "<leader>on",
      "<cmd>ObsidianNew<cr>",
      desc = "[N]ew note",
    },
    {
      "<leader>os",
      "<cmd>ObsidianQuickSwitch<cr>",
      desc = "Quick[S]witch note",
    },
    {
      "<leader>of",
      "<cmd>ObsidianSearch<cr>",
      desc = "[F]ind notes",
    },
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = "~/vault",
      },
    },
    note_id_func = function(title)
      local id = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        id = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          id = id .. string.char(math.random(65, 90))
        end
      end
      return id
    end,
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = {noremap=false, expr=true, buffer=true},
      },
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = {buffer=true, expr=true},
      },
    },
  },
}
