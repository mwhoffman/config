return {
  "mhinz/vim-signify",
  name = "signify",
  enabled = false,
  config = function()
    vim.g.signify_vcs_list = {"hg"}
    vim.g.signify_sign_add = "▌"
    vim.g.signify_sign_change = "▌"
    vim.g.signify_sign_delete = "▁▁"
    vim.g.signify_sign_delete_first_line = "▀▀"
  end
}
