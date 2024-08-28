local function extra_config ()
  vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>', {silent=true})
end

return {
  'nvim-telescope/telescope.nvim',
  name='telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
  },
  opts = function()
    extra_config()

    return {}
  end,
}
