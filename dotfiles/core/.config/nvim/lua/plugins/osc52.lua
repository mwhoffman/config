return {
  'ojroques/nvim-osc52',
  name = 'osc52',
  opts = function ()
    -- Set explicit keymaps.
    vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
    vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
    vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

    -- Return any options.
    return {}
  end,
}
