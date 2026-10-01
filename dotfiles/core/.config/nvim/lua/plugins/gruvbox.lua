-- gruvbox is our color theme. We keep its palette, but reassign some of the
-- colors to different highlight groups.
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
          NeotreeNormal = {bg = bg1},
          NeotreeCursorLine = {bg = bg3},
          -- Don't give markdown code blocks a background. render-markdown
          -- links this to ColorColumn, which virt-column clears when it loads,
          -- so otherwise the result depends on which loads first. This links
          -- to render-markdown's empty group since a group with no attributes
          -- doesn't count as set, and render-markdown would still link it.
          RenderMarkdownCode = {link = "RenderMarkdownPadding"},
        },
      })

      -- Run the original load.
      local result = gruvbox_load()

      -- Helper function to load the color by group and attr name.
      local function get_color(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      -- Override the color of directories, including in neo-tree (which gruvbox
      -- otherwise colors green). This uses the darker neutral blue, which
      -- gruvbox has no highlight group for, to match the ANSI blue used by DIR
      -- in .dircolors and by the prompt.
      local blue = gruvbox.palette.neutral_blue
      vim.api.nvim_set_hl(0, "Directory", {fg = blue, bold = true})
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", {link = "Directory"})
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", {fg = blue})

      -- Make the sign column the same as normal text.
      vim.cmd "hi! link SignColumn Normal"
      vim.cmd "hi! link NeotreeNormalNC NeotreeNormal"
      vim.cmd "hi! link NeoTreeSignColumn NeoTreeNormal"

      -- Remove the background from gruvbox's sign groups (used by diagnostic
      -- signs), so they match the sign column like the git signs do.
      for _, color in ipairs(
        {"Red", "Green", "Yellow", "Blue", "Purple", "Aqua", "Orange"}) do
        local group = "Gruvbox" .. color .. "Sign"
        local fg = vim.api.nvim_get_hl(0, {name = group}).fg
        vim.api.nvim_set_hl(0, group, {fg = fg})
      end

      -- Make the window separators and statusline match nvim-tree so that they
      -- "disappear".
      vim.cmd("hi! StatusLine guifg=" .. get_color("NeotreeNormal", "bg"))

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
