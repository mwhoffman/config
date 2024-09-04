return {
  'nvim-telescope/telescope.nvim',
  name='telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
  },
  keys = {
    {'<leader>f', ':Telescope find_files<cr>'},
  },
  opts = {},
}
