-- vim-maximizer toggles maximizing the current window, restoring the previous
-- layout when toggled back.
return {
  "szw/vim-maximizer",
  keys = {
    {
      "<leader>wm",
      "<cmd>MaximizerToggle<cr>",
      desc = "Maximize window (toggle)"
    }
  },
}

