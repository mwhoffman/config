return {
  "mhinz/vim-signify",
  config = function()
    vim.g.signify_skip = {vcs={deny={"git"}}}
    vim.g.signify_sign_add = "┃"
    vim.g.signify_sign_change = "┃"
    vim.g.signify_sign_delete = "▁"
    vim.g.signify_sign_delete_first_line = "▔"
    vim.g.signify_sign_change_delete = "~"
  end
}
