-- gitsigns shows git changes (added, changed and deleted lines) as signs in the
-- margin for files in a git repo. See signify.lua for other version control
-- systems.
return {
  "lewis6991/gitsigns.nvim",
  event = {"BufReadPre", "BufNewFile"},
  opts = {
    -- Also show signs in new files that haven't been added to git yet.
    attach_to_untracked = true,
    signs = {
      delete = {text = "▁"},
      topdelete = {text = "▔"},
      changedelete = {text = "┃"},
    },
  }
}
