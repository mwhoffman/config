return {
  {
    'ellisonleao/gruvbox.nvim',
    name='gruvbox',
    priority=1000,
    config=function()
      require('gruvbox').setup({
        overrides = {
          SignColumn = {bg='bg'},
        },
      })
    end
  }
}
