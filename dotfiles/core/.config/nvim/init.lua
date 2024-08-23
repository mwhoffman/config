vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.colorcolumn = '+0'
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 5
vim.opt.tabstop = 2
vim.opt.textwidth = 80
vim.opt.wrap = true

vim.keymap.set('n', '<c-k>', '<pageup>')
vim.keymap.set('n', '<c-j>', '<pagedown>')

-- Where store lazy plugins.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Bootstrap lazy.nvim.
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

-- Prepend the lazypath so we can load plugins.
vim.opt.rtp:prepend(lazypath)

-- Use lazy to manage plugins configured in lua/plugins.
require('lazy').setup('plugins')

vim.cmd.colorscheme 'gruvbox'

