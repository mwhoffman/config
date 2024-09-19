local function getCharLen(s, pos)
  local byte = string.byte(s, pos)
  if not byte then
    return nil
  end
  return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

return {
  "goolord/alpha-nvim",
  name = "alpha",
  event = "VimEnter",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  config = function()
    local alpha = require("alpha")
    local startify = require("alpha.themes.startify")

    local logo_chars = {
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

    local logo_colors = {
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

    local hl = {}
    local colors = {
      ["b"] = {fg="#3399ff", ctermfg=33},
      ["a"] = {fg="#53C670", ctermfg=35},
      ["g"] = {fg="#39ac56", ctermfg=29},
      ["h"] = {fg="#33994d", ctermfg=23},
      ["i"] = {fg="#33994d", bg="#39ac56", ctermfg=23, ctermbg=29},
      ["j"] = {fg="#53C670", bg="#33994d", ctermfg=35, ctermbg=23},
      ["k"] = {fg="#30A572", ctermfg=36},
    }

    for key, color in pairs(colors) do
      local name = "Alpha" .. key
      vim.api.nvim_set_hl(0, name, color)
      colors[key] = name
    end

    for i, line in ipairs(logo_colors) do
      local highlights = {}
      local pos = 0

      for j = 1, #line do
        local opos = pos
        pos = pos + getCharLen(logo_chars[i], opos + 1)

        local color_name = colors[line:sub(j, j)]
        if color_name then
          table.insert(highlights, {color_name, opos, pos})
        end
      end

      table.insert(hl, highlights)
    end

    startify.file_icons.provider = "devicons"
    startify.section.header.val = logo_chars
    startify.section.header.opts.hl = hl
    startify.section.mru.val = {{type="padding", val=0}}

    alpha.setup(startify.config)
  end,
}
