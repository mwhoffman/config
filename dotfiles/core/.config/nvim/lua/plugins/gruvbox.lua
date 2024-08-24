return {
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000,
    config = function()
      -- Include the package and save the load function.
      gruvbox = require('gruvbox')
      gruvbox_load = gruvbox.load

      -- Override the load function to check the background option.
      gruvbox.load = function()
        -- Set the background based on whether we want a dark theme or not.
        if vim.o.background == 'dark' then
          bg0 = gruvbox.palette.dark0
          bg1 = gruvbox.palette.dark1
        else
          bg0 = gruvbox.palette.light0
          bg1 = gruvbox.palette.light1
        end

        -- Run the setup; override SignColumn's bg color.
        gruvbox.setup({
          overrides = {
            SignColumn = {bg=bg0},
            WinSeparator = {bg=bg1},
            StatusLine = {fg=bg1},
            NvimTreeNormal = {bg=bg1},
          },
        })

        -- Run the original load.
        return gruvbox_load()
      end
    end
  }
}
