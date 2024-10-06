local function get_color(group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

return {
  "ellisonleao/gruvbox.nvim",
  -- Load this plugin first since its our primary colorscheme.
  lazy = false,
  priority = 1000,
  config = function()
    -- Include the package and save the load function.
    local gruvbox = require("gruvbox")
    local gruvbox_load = gruvbox.load
    local bg1, bg3

    -- Override the load function to check the background option.
    gruvbox.load = function()
      -- Set the background based on whether we want a dark theme or not.
      if vim.o.background == "dark" then
        bg1 = gruvbox.palette.dark1
        bg3 = gruvbox.palette.dark3

      else
        bg1 = gruvbox.palette.light1
        bg3 = gruvbox.palette.light3
      end

      -- Run the setup; but provide various overrides based on the background
      -- colors grabbed above.
      gruvbox.setup({
        terminal_colors = true,
        overrides = {
          NeotreeNormal = {bg=bg1},
          NeotreeCursorLine = {bg=bg3},
        },
      })

      -- Run the original load.
      local result = gruvbox_load()

      -- Override the color of directories.
      vim.cmd "hi! link Directory GruvboxBlueBold"

      -- Make the sign column the same as normal text.
      vim.cmd "hi! link SignColumn Normal"
      vim.cmd "hi! link NeotreeNormalNC NeotreeNormal"
      vim.cmd "hi! link NeoTreeSignColumn NeoTreeNormal"

      -- Make the window separators and statusline match nvim-tree so that they
      -- "disappear".
      vim.cmd("hi! StatusLine guifg="..get_color("NeotreeNormal", "bg"))

      -- Match colors between signify/gitsigns.
      vim.cmd "hi! link SignifySignAdd GitSignsAdd"
      vim.cmd "hi! link SignifySignChange GitSignsChange"
      vim.cmd "hi! link SignifySignDelete GitSignsDelete"

      return result
    end

    -- Manually load the colorscheme.
    vim.cmd.colorscheme "gruvbox"
  end
}
