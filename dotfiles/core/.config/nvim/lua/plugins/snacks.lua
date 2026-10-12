-- snacks is a collection of small plugins, but we only enable its picker: a
-- fuzzy finder with a preview window. We use it to find files, recent files,
-- strings (searched with ripgrep), git changes and diagnostics. It also
-- replaces vim.ui.select (used e.g. for LSP code actions).
local spec = {
  "folke/snacks.nvim",
  -- Load after startup rather than on the keys below, so that vim.ui.select is
  -- replaced before anything uses it. Only the picker is enabled, so this is
  -- cheap, and its modules are only loaded when a picker is opened.
  event = "VeryLazy",
  opts = {
    picker = {
      -- Open pickers without the preview, and toggle it with <C-o> (as well as
      -- snacks' <A-p>). <C-p> would clash with moving up the list.
      layout = {hidden = {"preview"}},
      win = {
        input = {
          keys = {["<C-o>"] = {"toggle_preview", mode = {"i", "n"}}},
        },
        list = {keys = {["<C-o>"] = "toggle_preview"}},
      },
      sources = {
        files = {hidden = true},
        grep = {hidden = true},
        grep_word = {hidden = true},
        recent = {
          filter = {
            -- Also skip nvim's own help files (the plugin docs are in the data
            -- dir, which snacks already skips).
            paths = {[vim.env.VIMRUNTIME .. "/doc"] = false},
            -- And git commit messages.
            filter = function(item)
              return not item.file:match("/%.git/COMMIT_EDITMSG$")
            end,
          },
        },
      },
      -- Show the same status letters as `git status --short`. A staged change
      -- is still shown with snacks' staged icon.
      icons = {
        git = {
          added = "A",
          deleted = "D",
          modified = "M",
          renamed = "R",
          unmerged = "U",
          untracked = "?",
        },
      },
    },
  },
}

-- Open the given picker. This requires snacks rather than using its Snacks
-- global so it works whether or not snacks has loaded yet.
local function pick(source, opts)
  return function()
    require("snacks").picker[source](opts)
  end
end

-- A picker of the files changed in the working-copy commit, like the
-- git_status picker but listing `jj diff --summary`. Each item's status
-- looks like git's (" M", " A", ...) so snacks' git_status formatter colors
-- it; renames are shown "old -> new" like git's.
local function jj_status(_, ctx)
  local root = vim.trim(vim.fn.system({"jj", "root", "--ignore-working-copy"}))
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a jj repo", vim.log.levels.WARN)
    return {}
  end
  ctx.picker:set_cwd(root)
  return require("snacks.picker.source.proc").proc(ctx:opts({
    cmd = "jj",
    args = {"diff", "--summary", "--no-pager", "--color=never"},
    cwd = root,
    transform = function(item)
      local status, path = item.text:match("^(%u) (.+)$")
      if not status then
        return false
      end
      -- A rename or copy is printed as e.g. "R dir/{old => new}".
      local pre, old, new, post = path:match("^(.-){(.-) => (.-)}(.*)$")
      if pre then
        item.rename = pre .. old .. post
        path = pre .. new .. post
      end
      item.cwd, item.status, item.file = root, " " .. status, path
    end,
  }), ctx)
end

-- Preview an item like snacks' git_status preview does: an added file is
-- shown as is, and otherwise its jj diff (including the old path of a rename)
-- goes through snacks' diff renderer (its "fancy" style by default) rather
-- than showing jj's own colored output, unless the terminal style is set.
local function jj_preview(ctx)
  local preview = require("snacks").picker.preview
  if ctx.item.status == " A" then
    return preview.file(ctx)
  end
  local fileset = ("root-file:%q"):format(ctx.item.file)
  if ctx.item.rename then
    fileset = fileset .. (" | root-file:%q"):format(ctx.item.rename)
  end
  local terminal = ctx.picker.opts.previewers.diff.style == "terminal"
  return preview.cmd({
    "jj", "diff", "--git", "--no-pager",
    "--color=" .. (terminal and "always" or "never"),
    fileset,
  }, ctx, {ft = not terminal and "diff" or nil})
end

spec.opts.picker.sources.jj_status = {
  finder = jj_status,
  format = "git_status",
  preview = jj_preview,
}

spec.keys = {
  {
    "<leader>ff",
    pick("files"),
    desc = "Find files",
  },
  {
    "<leader>fs",
    pick("grep"),
    desc = "Find string",
  },
  {
    "<leader>fw",
    pick("grep_word"),
    desc = "Find string under cursor",
  },
  {
    "<leader>fg",
    pick("git_status"),
    desc = "Find git changes",
  },
  {
    "<leader>fj",
    pick("jj_status"),
    desc = "Find jj changes",
  },
  {
    "<leader>fr",
    pick("recent", {filter = {cwd = true}}),
    desc = "Find recent files (cwd)",
  },
  {
    "<leader>fR",
    pick("recent"),
    desc = "Find recent files (all)",
  },
  {
    "<leader>fd",
    pick("diagnostics"),
    desc = "Find diagnostics",
  },
}

return spec
