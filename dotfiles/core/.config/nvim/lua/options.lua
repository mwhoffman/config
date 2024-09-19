local opt = vim.opt

opt.background = "dark"
opt.backup = false
opt.fillchars = {vert="▕", eob=" "}
opt.hlsearch = true
opt.linebreak = true
opt.mouse = "a"
opt.number = true
opt.showmode = false
opt.signcolumn = "yes"
opt.scrolloff = 5
opt.textwidth = 80
opt.wrap = true

-- Indentation.
opt.tabstop = 2
opt.softtabstop = vim.o.tabstop
opt.shiftwidth = vim.o.tabstop
opt.expandtab = true
opt.copyindent = true
opt.smartindent = false

-- Search.
opt.ignorecase = true
opt.smartcase = true

-- Split windows.
opt.splitright = true
opt.splitbelow = true
