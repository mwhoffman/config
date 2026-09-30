-- zk-nvim integrates the zk note-taking tool: it starts zk's language server
-- for markdown files in a notebook (link completion, go to linked note, hover
-- previews, backlinks as references, dead link diagnostics) and adds telescope
-- pickers for finding, creating and linking notes. It manages the zk LSP
-- client itself, so zk isn't enabled in lsp.lua.
local spec = {
  "zk-org/zk-nvim",
  name = "zk",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  -- Load when these commands are run, so that e.g. `nvim +ZkNotes` works.
  ft = "markdown",
  cmd = {"ZkNew", "ZkNotes"},
  opts = {
    picker = "telescope",
  },
}

-- These keys also lazy-load the plugin, and which-key uses the descriptions
-- to display command information.
spec.keys = {
  {
    "<leader>zn",
    "<cmd>ZkNew<cr>",
    desc = "New note",
  },
  {
    "<leader>ze",
    "<cmd>ZkNotes<cr>",
    desc = "Edit notes",
  },
  {
    "<leader>zi",
    "<cmd>ZkInsertLink<cr>",
    desc = "Insert link",
  },
}

return spec
