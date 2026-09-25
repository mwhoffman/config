-- Modules from the mini.nvim collection: small, independent plugins that each
-- do one thing.
return {
  -- Better support for comments: comment selections, lines, motions. Also
  -- defines comments as objects that actions (d, y, c, ...) can be applied to,
  -- e.g. dgc deletes a comment block.
  {
    'nvim-mini/mini.comment',
    event = {"BufReadPre", "BufNewFile"},
    opts = {},
  },
}
