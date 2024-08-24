return {
  {
    'lukas-reineke/virt-column.nvim',
    name = 'virt-column',
    config=function()
      require('virt-column').setup({
        char = "▕" ,
        virtcolumn = "+1",
      })
    end,
  }
}
