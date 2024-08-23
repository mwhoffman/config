vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.colorcolumn = '+0'
vim.opt.copyindent = true
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 5
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 80
vim.opt.wrap = true

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
      'git', 'clone', '--filter=blob:none', '--branch=stable',
      lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

-- Run lazy using plugins configured in ./lua/plugins.
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

-- Set the colorscheme.
vim.cmd.colorscheme 'gruvbox'

-- Add keymappings.
vim.keymap.set('n', '<c-k>', '<pageup>')
vim.keymap.set('n', '<c-j>', '<pagedown>')
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {silent=true})

