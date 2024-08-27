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
          bg2 = gruvbox.palette.dark2
          bg3 = gruvbox.palette.dark3

        else
          bg0 = gruvbox.palette.light0
          bg1 = gruvbox.palette.light1
          bg2 = gruvbox.palette.light2
          bg3 = gruvbox.palette.light3
        end

        -- Run the setup; but provide various overrides based on the background
        -- colors grabbed above.
        gruvbox.setup({
          terminal_colors = true,
          overrides = {
            NvimTreeNormal = {bg=bg1},
            NvimTreeCursorLine = {bg=bg3},
          },
        })

        -- Run the original load.
        result = gruvbox_load()

        -- Override the color of directories.
        vim.api.nvim_set_hl(0, "Directory", {link='GruvboxBlueBold'})
        vim.api.nvim_set_hl(0, "NvimTreeRootFolder", {link='GruvboxGreenBold'})

        return result
      end
    end
  }
}
