return {
  'nvim-telescope/telescope.nvim',
  name='telescope',
  dependencies = {
    {'nvim-lua/plenary.nvim', name='plenary'},
    'BurntSushi/ripgrep',
  },
  keys = {
    {'<leader>ff', ':Telescope find_files<cr>'},
  },
  opts = {},
}
