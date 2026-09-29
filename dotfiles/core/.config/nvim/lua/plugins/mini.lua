-- Modules from the mini.nvim collection: small, independent plugins that each
-- do one thing.
return {
  -- Better support for comments: comment selections, lines, motions. Also
  -- defines comments as objects that actions (d, y, c, ...) can be applied to,
  -- e.g. dgc deletes a comment block.
  {
    'nvim-mini/mini.comment',
    event = {"BufReadPre", "BufNewFile"},
    opts = {},
  },

  -- Icons for files and directories, using our own icons and colors (see
  -- mini-icons.lua). Plugins that use nvim-web-devicons get them too, since
  -- requiring it gives a mock of it that uses mini.icons (which loads it).
  {
    'nvim-mini/mini.icons',
    lazy = true,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      local icons = require("mini-icons")

      -- Define the highlight groups the icons use, and again whenever the
      -- colorscheme changes (which clears them).
      local function set_highlights()
        for group, color in pairs(icons.highlights) do
          vim.api.nvim_set_hl(0, group, {fg = color})
        end
      end
      set_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {callback = set_highlights})

      require("mini.icons").setup({
        default = icons.default,
        directory = icons.directory,
        file = icons.file,
        extension = icons.extension,
        filetype = icons.filetype,
      })
    end,
  },
}
