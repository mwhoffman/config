-- Neo-tree is a plugin for browsing the file system and other tree-like
-- structures. We use it as a floating or sidebar file tree. Editing a directory
-- is left to oil.
local spec = {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  -- Neo-tree itself is lazy loaded, so we don't need to rely on the plugin
  -- manager for this.
  lazy = true,
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
      hijack_netrw_behavior = "disabled",
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

spec.keys = {
  {
    "<leader>t",
    -- Reveal the current file, or in an oil buffer show its directory (neo-tree
    -- can't reveal the buffer itself, since its name isn't a path).
    function()
      local command = "Neotree toggle position=float"
      if vim.bo.filetype ~= "oil" then
        command = command .. " reveal_force_cwd"
      else
        local dir = require("oil").get_current_dir()
        if dir then
          command = command .. " dir=" .. vim.fn.fnameescape(vim.fs.normalize(dir))
        end
      end
      vim.cmd(command)
    end,
    desc = "File tree (floating)",
  },
  {
    "<leader>b",
    "<cmd>Neotree buffers toggle position=float<cr>",
    desc = "Buffer tree (floating)",
  },
}

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
