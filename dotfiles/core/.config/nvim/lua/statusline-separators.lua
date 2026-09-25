-- Draw vertical window separators in the statusline row.
--
-- When two windows sit side by side, each has its own statusline with one cell
-- between them. Nvim draws that cell with the statusline fillchar
-- (`stl`/`stlnc`, a space by default) rather than the separator character,
-- leaving a gap in the vertical line. The fillchar can't be changed for just
-- that cell since it also pads every statusline. Instead, cover each of those
-- cells with a one-cell floating window showing the separator character.

-- What to draw in each cell: the same character and highlight as the vertical
-- separators themselves. `vert` is missing from fillchars when it hasn't been
-- set, in which case nvim uses "│". This is read once, so fillchars needs to be
-- set before this file is loaded (see init.lua).
local char = vim.opt.fillchars:get().vert or "│"
local hl = "WinSeparator"

-- A scratch buffer holding `char`, shared by all of our windows.
local buf

-- Mapping from tabpage to a list of windows we've created for that tabpage.
local all_windows = {}

-- Return the shared buffer.
local function get_buf()
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    -- Create an unlisted scratch buffer and fill it with our character.
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {char})
  end
  return buf
end

-- Return a list of 0-based positions {row, col} corresponding to each cell
-- below a vertical separator in the given tabpage.
local function get_cells(tabpage)
  local cells = {}
  -- Windows only have their own statuslines with laststatus 1 or 2 (0 and 3
  -- correspond to no statusline and a global statusline respectively). So if
  -- laststatus is not 1 or 2 return no cells.
  if vim.o.laststatus ~= 2 and vim.o.laststatus ~= 1 then
    return cells
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    -- Skip floating windows (including the ones we've created); only split
    -- windows have separators.
    if vim.api.nvim_win_get_config(win).relative == "" then
      -- getwininfo() positions are 1-based, so convert to 0-based.
      local info = vim.fn.getwininfo(win)[1]
      -- The column just right of the window's text area...
      local col = info.wincol - 1 + info.width
      -- ...holds its separator, unless the window reaches the right edge of
      -- the screen and so has no separator.
      if col < vim.o.columns then
        -- The statusline row is just below the window's winbar and text.
        local row = info.winrow - 1 + info.winbar + info.height
        table.insert(cells, {row, col})
      end
    end
  end
  return cells
end

-- Update separator windows in the current tabpage.
local function update_tabpage()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local cells = get_cells(tabpage)

  -- Drop any windows that have been closed by something else.
  local windows = vim.tbl_filter(
    vim.api.nvim_win_is_valid, all_windows[tabpage] or {})

  for i, cell in ipairs(cells) do
    local config = {
      -- Position in screen cells, relative to the whole editor.
      relative = "editor",
      row = cell[1],
      col = cell[2],
      width = 1,
      height = 1,
      -- Can't be entered with window commands, and mouse clicks go through to
      -- whatever is underneath (e.g. dragging the separator).
      focusable = false,
      mouse = false,
      -- Draw below any other windows (completion menus, pickers, etc).
      zindex = 1,
      -- No number column, sign column, etc.
      style = "minimal",
      -- No border, even if 'winborder' sets one for floats by default.
      border = "none",
    }
    if windows[i] then
      -- Set the config if we have enough windows.
      vim.api.nvim_win_set_config(windows[i], config)
    else
      -- Create a new window, but don't fire WinNew/BufEnter/etc for other
      -- plugins to react to.
      config.noautocmd = true
      windows[i] = vim.api.nvim_open_win(get_buf(), false, config)
      -- Floats are drawn with NormalFloat; show this one like a separator.
      vim.wo[windows[i]].winhighlight = "NormalFloat:" .. hl
    end
  end

  -- Close windows beyond the number of separators, e.g. after closing a split.
  for i = #cells + 1, #windows do
    vim.api.nvim_win_close(windows[i], true)
    windows[i] = nil
  end
  all_windows[tabpage] = windows
end

-- Forget the windows of closed tabpages. Their windows are closed along with
-- the tabpage, so only the entries in all_windows are left. TabClosed only
-- gives the closed tab's position, not its handle, so check every entry.
local function prune_tabpage()
  for tabpage in pairs(all_windows) do
    if not vim.api.nvim_tabpage_is_valid(tabpage) then
      all_windows[tabpage] = nil
    end
  end
end

local group = vim.api.nvim_create_augroup(
  "StatuslineSeparators",
  { clear = true }
)

-- Update whenever the separators may have moved: i.e. right after startup
-- (VimEnter), when windows or vim are resized (WinResized, which includes
-- splits and closes, and VimResized), every time a tabpage is entered
-- (TabEnter).
vim.api.nvim_create_autocmd(
  { "VimEnter", "WinResized", "VimResized", "TabEnter" },
  {
    group = group,
    callback = update_tabpage,
  })

-- Also update when statuslines are turned on/off.
vim.api.nvim_create_autocmd(
  "OptionSet",
  {
    group = group,
    pattern = "laststatus",
    callback = update_tabpage,
  })

-- Also forget about closed tabpages.
vim.api.nvim_create_autocmd(
  "TabClosed",
  {
    group = group,
    callback = prune_tabpage,
  })
