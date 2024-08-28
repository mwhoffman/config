vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.background = 'dark'
vim.opt.backup = false
vim.opt.copyindent = true
vim.opt.expandtab = true
vim.opt.fillchars = {vert='▕', eob=' '} -- useful fillchars: ▏▕
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 5
vim.opt.smartindent = false
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
require('lazy').setup({
  spec = 'plugins',
  change_detection = {enabled=false},
})

-- Add keymappings.
vim.keymap.set('n', '<c-k>', '<pageup>')
vim.keymap.set('n', '<c-j>', '<pagedown>')
vim.keymap.set('v', '<c-k>', '<pageup>')
vim.keymap.set('v', '<c-j>', '<pagedown>')

function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

vim.api.nvim_create_autocmd(
  {"ColorScheme"},
  {
    callback = function ()
      vim.cmd 'hi! BufferDefaultCurrent gui=bold'
      vim.cmd 'hi! BufferDefaultCurrentMod gui=bold'
      vim.cmd 'hi! link SignColumn Normal'
      vim.cmd('hi! WinSeparator guibg='..get_color('NvimTreeNormal', 'bg'))
      vim.cmd('hi! StatusLine guifg='..get_color('NvimTreeNormal', 'bg'))
      vim.cmd 'hi! link SignifySignAdd GitSignsAdd'
      vim.cmd 'hi! link SignifySignChange GitSignsChange'
      vim.cmd 'hi! link SignifySignDelete GitSignsDelete'
    end
  })

-- Set the colorscheme.
vim.cmd.colorscheme 'gruvbox'

-- Don't let the the python ftplugin override tabwidth behavior.
vim.cmd 'autocmd Filetype python let &l:et=&g:et'
vim.cmd 'autocmd Filetype python let &l:sw=&g:sw'
vim.cmd 'autocmd Filetype python let &l:ts=&g:ts'
vim.cmd 'autocmd Filetype python let &l:sts=&g:sts'

