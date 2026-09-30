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
  -- Load for markdown files, so the language server starts for notes, and when
  -- these commands are run, so that e.g. `nvim +ZkNotes` works.
  ft = "markdown",
  cmd = {"ZkNew", "ZkNotes"},
  opts = {
    picker = "telescope",
  },
}

-- Run a zk command that's only useful from a note, or warn that it isn't. (For
-- links and backlinks, zk would otherwise ignore the file and list every note.)
local function note_cmd(cmd)
  return function()
    if not require("zk.util").notebook_root(vim.api.nvim_buf_get_name(0)) then
      vim.notify(
        cmd .. " can only be called from a zk note",
        vim.log.levels.WARN)
      return
    end
    vim.cmd(cmd)
  end
end

-- New and edit work from anywhere (finding the notebook with $ZK_NOTEBOOK_DIR),
-- and the rest need a note. The keys also lazy-load the plugin, and which-key
-- uses the descriptions to display command information.
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
    note_cmd("ZkInsertLink"),
    desc = "Insert link",
  },
  {
    "<leader>zb",
    note_cmd("ZkBacklinks"),
    desc = "Find backlinks",
  },
  {
    "<leader>zl",
    note_cmd("ZkLinks"),
    desc = "Find links",
  },
  {
    "<leader>zt",
    note_cmd("ZkTags"),
    desc = "Find tags",
  },
}

return spec
