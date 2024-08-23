return {
  {
    'ellisonleao/gruvbox.nvim',
    name='gruvbox',
    priority=1000,
    config=function()
      -- Include the package and save the load function.
      gruvbox = require('gruvbox')
      gruvbox_load = gruvbox.load

      -- Override the load function to check the background option.
      gruvbox.load = function()
        -- Set the background based on whether we want a dark theme or not.
        if vim.o.background == 'dark' then
          bg = gruvbox.palette.dark0
        else
          bg = gruvbox.palette.light0
        end

        -- Run the setup; override SignColumn's bg color.
        gruvbox.setup({
          overrides = {
            SignColumn={bg=bg},
          },
        })

        -- Run the original load.
        return gruvbox_load()
      end
    end
  }
}
