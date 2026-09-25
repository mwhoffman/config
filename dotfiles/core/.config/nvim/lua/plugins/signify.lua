-- signify shows version control changes as signs in the margin, like gitsigns
-- but for other version control systems (e.g. mercurial). Git is skipped here
-- since gitsigns handles it.
return {
  "mhinz/vim-signify",
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    vim.g.signify_skip = {vcs = {deny = {"git"}}}
    vim.g.signify_sign_add = "┃"
    vim.g.signify_sign_change = "┃"
    vim.g.signify_sign_delete = "▁"
    vim.g.signify_sign_delete_first_line = "▔"
    vim.g.signify_sign_change_delete = "┃"
  end
}
