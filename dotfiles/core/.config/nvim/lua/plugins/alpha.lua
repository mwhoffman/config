local header = {
  [[  ███       ███  ]],
  [[  ████      ████ ]],
  [[  ████     █████ ]],
  [[ █ ████    █████ ]],
  [[ ██ ████   █████ ]],
  [[ ███ ████  █████ ]],
  [[ ████ ████ ████ ]],
  [[ █████  ████████ ]],
  [[ █████   ███████ ]],
  [[ █████    ██████ ]],
  [[ █████     █████ ]],
  [[ ████      ████ ]],
  [[  ███       ███  ]],
  [[                    ]],
  [[  N  E  O  V  I  M  ]],
}

local header_colors = {
  [[  kkkka       gggg  ]],
  [[  kkkkaa      ggggg ]],
  [[ b kkkaaa     ggggg ]],
  [[ bb kkaaaa    ggggg ]],
  [[ bbb kaaaaa   ggggg ]],
  [[ bbbb aaaaaa  ggggg ]],
  [[ bbbbb aaaaaa igggg ]],
  [[ bbbbb  aaaaaahiggg ]],
  [[ bbbbb   aaaaajhigg ]],
  [[ bbbbb    aaaaajhig ]],
  [[ bbbbb     aaaaajhi ]],
  [[ bbbbb      aaaaajh ]],
  [[  bbbb       aaaaa  ]],
  [[                    ]],
  [[  a  a  a  b  b  b  ]],
}

local colors = {
  ["b"] = {fg="#3399ff", ctermfg=33},
  ["a"] = {fg="#53C670", ctermfg=35},
  ["g"] = {fg="#39ac56", ctermfg=29},
  ["h"] = {fg="#33994d", ctermfg=23},
  ["i"] = {fg="#33994d", bg="#39ac56", ctermfg=23, ctermbg=29},
  ["j"] = {fg="#53C670", bg="#33994d", ctermfg=35, ctermbg=23},
  ["k"] = {fg="#30A572", ctermfg=36},
}

local function get_char_len(s, pos)
  local byte = string.byte(s, pos)
  if not byte then
    return nil
  end
  return ((byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or
          (byte < 0xF8 and 4) or 1)
end

local function get_highlights(header, header_colors, colors)
  local highlights = {}
  local hl_names = {}

  for key, color in pairs(colors) do
    local name = "Alpha" .. key
    vim.api.nvim_set_hl(0, name, color)
    hl_names[key] = name
  end

  for i, line in ipairs(header_colors) do
    local hls = {}
    local pos = 0

    for j = 1, #line do
      local opos = pos
      pos = pos + get_char_len(header[i], opos + 1)

      local hl_name = hl_names[line:sub(j, j)]
      if hl_name then
        table.insert(hls, {hl_name, opos, pos})
      end
    end

    table.insert(highlights, hls)
  end

  return highlights
end
return {
  "goolord/alpha-nvim",
  name = "alpha",
  event = "VimEnter",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function() 
    local alpha = require("alpha")
    local startify = require("alpha.themes.startify")
    local mru = startify.mru(0, vim.fn.getcwd())

    mru.opts = {
      inherit = {
        position = "center",
        width = 50,
      },
    }

    startify.file_icons.provider = "devicons"
    startify.config.layout = {
      {type="padding", val=1},
      {
        type = "text",
        val = header,
        opts = {
          hl = get_highlights(header, header_colors, colors),
          shrink_margin = false,
          position = "center",
        },
      },
      {type="padding", val=2},
      {
        type = "text",
        val = "Recent files",
        opts = {
          hl = "SpecialComment",
          shrink_margin = false,
          position = "center",
        }
      },
      {type="padding", val=1},
      mru,
      {type="padding", val=1},
      {
        type = "group",
        val = {
          startify.button("e", "New file", "<cmd>ene <CR>"),
          startify.button("q", "Quit", "<cmd>q <CR>"),
        },
        opts = {
          inherit = {
            position = "center",
            width = 50,
          },
        },
      },
    }

    alpha.setup(startify.config)
  end,
}
