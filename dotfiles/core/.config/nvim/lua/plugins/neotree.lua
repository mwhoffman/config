-- Neo-tree is a plugin for browsing the file system and other tree-like
-- structures. We use it as a floating or sidebar file tree, and in place of
-- netrw when editing a directory.
local spec = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  -- Neo-tree itself is lazy loaded, so we don't need to rely on the plugin
  -- manager for this.
  lazy = false,
  opts = {
    -- Don't use git at all: drop the git_status source (which runs git itself)
    -- and don't mark files with their git status in the other sources.
    sources = {"filesystem", "buffers"},
    enable_git_status = false,
    close_if_last_window = true,
    popup_border_style = "rounded",
    window = {
      position = "float",
      width = 40,
      auto_expand_width = false,
      popup = {
        size = function()
          return {height = "80%", width = math.min(50, vim.o.columns - 12)}
        end,
      },
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

-- An icon provider for neo-tree using mini.icons (see bedeck.icons), rather
-- than its default which uses nvim-web-devicons (mocked by mini.icons) and so
-- doesn't get mini.icons' icons for directories or its defaults. Directories
-- with their own icon (e.g. .git) get it, and others keep neo-tree's (closed,
-- open and empty) folder icons. Files get mini.icons' icon, except that those
-- with no extension it doesn't know get our default for them (like eza).
local function icon_provider(icon, node)
  if node.type ~= "file" and node.type ~= "directory" then
    return
  end
  local mini = require("mini.icons")
  local glyph, highlight, is_default = mini.get(node.type, node.name)
  if node.type == "directory" then
    if not is_default then
      icon.text, icon.highlight = glyph, highlight
    end
    return
  end
  if is_default and not node.name:find(".", 2, true) then
    local noext = require("bedeck.icons").defaults.noext
    glyph, highlight = noext.glyph, noext.hl
  end
  icon.text, icon.highlight = glyph, highlight
end

spec.opts.default_component_configs.icon = {provider = icon_provider}

-- Neo-tree highlights a floating tree the same as a sidebar. Instead give it
-- the background of other floats (and the usual cursor line, which is visible
-- against that), leaving the sidebar's highlights alone. Also dim the editor
-- behind it.
spec.opts.event_handlers = {
  {
    event = "neo_tree_window_after_open",
    handler = function(args)
      if args.position ~= "float" then
        return
      end
      vim.wo[args.winid][0].winhighlight = table.concat({
        "Normal:NeoTreeFloatNormal",
        "NormalNC:NeoTreeFloatNormal",
        "SignColumn:NeoTreeFloatNormal",
        "CursorLine:CursorLine",
        "FloatBorder:NeoTreeFloatBorder",
        "EndOfBuffer:NeoTreeEndOfBuffer",
      }, ",")
      require("backdrop").open(args.winid)
    end,
  },
}

return spec
