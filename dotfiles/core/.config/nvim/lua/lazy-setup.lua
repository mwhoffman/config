-- Define where to find the lazy plugin manager.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- If lazy doesn't exist get it from github.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

-- Run lazy using plugins configured in ./lua/plugins.
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  spec = "plugins",
  change_detection = {enabled=false},
  rocks = {enabled=false},
})
