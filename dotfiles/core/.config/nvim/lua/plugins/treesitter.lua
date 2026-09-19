local parsers = {
  "bash", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline",
  "python", "vim", "vimdoc",
}

-- Filetypes which rely on vim's regex highlighting system for indentation and
-- syntax (rather than treesitter's).
local legacy = {python=true, ruby=true}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- The main branch does not support lazy loading.
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    -- Install any missing parsers (asynchronous, no-op if already installed).
    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", {clear=true}),
      callback = function(args)
        -- Only start if a parser is available for this filetype.
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        local ft = vim.bo[args.buf].filetype
        if legacy[ft] then
          vim.bo[args.buf].syntax = "on"
        else
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
