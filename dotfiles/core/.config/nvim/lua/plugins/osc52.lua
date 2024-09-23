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
    vim.keymap.set("n","<leader>c", require("osc52").copy_operator,
      {expr=true, desc="Copy to clipboard"})

    vim.keymap.set("v", "<leader>c", require("osc52").copy_visual,
      {desc="Copy to clipboard"})

    vim.keymap.set("n", "<leader>cc", "<leader>c_",
      {remap=true, desc="Copy line to clipboard"})

    -- Return any options.
    return {}
  end,
}
