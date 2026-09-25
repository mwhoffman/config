-- gitsigns shows git changes (added, changed and deleted lines) as signs in the
-- margin for files in a git repo. See signify.lua for other version control
-- systems.
return {
  "lewis6991/gitsigns.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
    signs = {
      delete = {text = "▁"},
      topdelete = {text = "▔"},
      changedelete = {text = "┃"},
    },
  }
}
