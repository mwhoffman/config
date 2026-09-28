-- Neo-tree is a plugin for browsing the file system and other tree-like
-- structures. We use it as a floating or sidebar file tree, and in place of
-- netrw when editing a directory.
local spec = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  -- Neo-tree itself is lazy loaded, so we don't need to rely on the plugin
  -- manager for this.
  lazy = false,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    window = {
      width = 40,
      auto_expand_width = false,
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
        },
      },
      hijack_netrw_behavior = "open_default",
    },
    default_component_configs = {
      indent = {indent_marker = "┆"},
      file_size = {enabled = false},
      type = {enabled = false},
      last_modified = {enabled = false},
      created = {enabled = false},
      symlink_target = {enabled = false}
    }
  },
}

-- This doesn't affect the lazy-loading behavior because we set lazy=False, but
-- the descriptions are also used by which-key to display command information.
spec.keys = {
  {
    "<leader>t",
    "<cmd>Neotree toggle reveal_force_cwd position=float<cr>",
    desc = "File tree (floating)",
  },
  {
    "<leader>b",
    "<cmd>Neotree buffers toggle position=float<cr>",
    desc = "Buffer tree (floating)",
  },
  {
    "<leader>T",
    "<cmd>Neotree toggle reveal_force_cwd position=left<cr>",
    desc = "File tree (sidebar)",
  },
}

-- Disable netrw so it doesn't flash underneath when we open directories.
spec.init = function()
  vim.g.loaded_netrwPlugin = 1
end

-- A replacement for neo-tree's git_status component which marks files like the
-- git status flags in the zsh prompt: ? if untracked, * if any change is
-- unstaged, ! for a conflict, and ✓ if every change is staged. Ignored files
-- aren't marked, and neither are directories, but they still get a highlight
-- (with no text) since neo-tree colors names using this component's highlight;
-- a directory's is from neo-tree's one-letter summary of what's under it.
local function git_status(_, node, state)
  if node.type == "message" then
    return {}
  end
  local status = require("neo-tree.git").find_existing_status_code(
    node.path, state.git_base_by_worktree)
  if type(status) == "table" then
    status = status[1]
  end
  if not status or status == "!" then
    return {}
  end

  local text, highlight
  if status == "?" then
    text, highlight = "?", "NeoTreeGitUntracked"
  elseif #status == 1 then
    text = ""
    highlight = ({
      A = "NeoTreeGitAdded",
      D = "NeoTreeGitDeleted",
      U = "NeoTreeGitConflict"})[status] or "NeoTreeGitModified"
  else
    local x, y = status:sub(1, 1), status:sub(2, 2)
    if require("neo-tree.git.parser").status_code_is_conflict(x, y) then
      text, highlight = "!", "NeoTreeGitConflict"
    elseif y ~= "." then
      text, highlight = "*", "NeoTreeGitModified"
    else
      text, highlight = "✓", "NeoTreeGitStaged"
    end
  end
  if node.type == "directory" then
    text = ""
  end
  return {text = text, highlight = highlight}
end

spec.opts.filesystem.components = {git_status = git_status}
spec.opts.buffers = {components = {git_status = git_status}}
spec.opts.git_status = {components = {git_status = git_status}}

return spec
