local opt = vim.opt

opt.background = "dark"
opt.backup = false
opt.fillchars = {vert="│", eob=" "}
opt.hlsearch = true
opt.mouse = "a"
opt.scrolloff = 5

-- Break lines at this width.
opt.textwidth = 80

-- Wrap lines visually that don't fit onscreen but wrap entire words.
opt.wrap = true
opt.linebreak = true

-- Always show number/sign columns.
opt.number = true
opt.signcolumn = "yes"

-- Indentation.
opt.tabstop = 2
opt.softtabstop = vim.o.tabstop
opt.shiftwidth = vim.o.tabstop
opt.expandtab = true
opt.copyindent = true
opt.smartindent = false

-- Default to splitting below and to the right.
opt.splitright = true
opt.splitbelow = true

-- The minimum height/width. The default is one but that really isn't any more
-- visible than zero. This is only really important when maximizing splits.
opt.winminheight = 0
opt.winminwidth = 0

-- Hide mode/cmd/ruler since we display them in the status line.
opt.showcmd = false
opt.showmode = false
opt.ruler = false

opt.conceallevel = 2

-- Autocommand which activates whenever is a buffer is read and will jump the
-- cursor the location it was at when the buffer was last closed.
vim.api.nvim_create_autocmd(
  {"BufRead"},
  {
    pattern = "*",
    command = 'silent! normal! g`"zv',
  }
)

-- Disable optional providers.
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
