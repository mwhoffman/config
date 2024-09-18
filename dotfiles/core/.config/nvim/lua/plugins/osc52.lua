return {
  "ojroques/nvim-osc52",
  name = "osc52",
  keys = {
    {"<leader>c"},
    {"<leader>c", mode="v"},
    {"<leader>cc"},
  },
  opts = function ()
    -- Set explicit keymaps.
    vim.keymap.set("n", "<leader>c", require("osc52").copy_operator, {expr=true})
    vim.keymap.set("v", "<leader>c", require("osc52").copy_visual)
    vim.keymap.set("n", "<leader>cc", "<leader>c_", {remap=true})

    -- Return any options.
    return {}
  end,
}
