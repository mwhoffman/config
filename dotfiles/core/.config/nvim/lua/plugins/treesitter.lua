-- nvim-treesitter installs treesitter parsers, which give more accurate syntax
-- highlighting and indentation than vim's regex-based system. The autocmd
-- below starts treesitter for each buffer whose filetype has a parser.
local spec = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- The main branch does not support lazy loading.
  lazy = false,
  build = ":TSUpdate",
}

-- Parsers to install.
local parsers = {
  "bash",
  "diff",
  "html",
  "just",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "ruby",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

-- Filetypes which rely on vim's regex highlighting system for indentation and
-- syntax (rather than treesitter's).
local legacy = {python = true, ruby = true}

spec.config = function()
  -- Install any missing parsers (asynchronous, no-op if already installed).
  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_start", {clear = true}),
    callback = function(args)
      -- Only start if a parser is available for this filetype.
      if not pcall(vim.treesitter.start, args.buf) then
        return
      end

      -- Fold using treesitter (for all filetypes, including legacy ones).
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

      local ft = vim.bo[args.buf].filetype
      if legacy[ft] then
        vim.bo[args.buf].syntax = "on"
      else
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return spec
