-- Dims the rest of the editor behind a floating window, like snacks' picker,
-- Lazy and Mason do behind theirs: a black window covering the editor, blended
-- with what's underneath, just below the float.
local M = {}

-- How opaque the backdrop is: 0 is fully opaque, 100 is fully transparent. This
-- matches the default of the plugins above.
local blend = 60

-- Dim the editor behind the given floating window until it closes.
function M.open(win)
  -- Colorschemes clear this, so (re)define it each time.
  vim.api.nvim_set_hl(0, "Backdrop", {bg = "#000000"})

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  local function config()
    return {
      relative = "editor",
      row = 0,
      col = 0,
      width = vim.o.columns,
      height = vim.o.lines,
      -- Draw just below the float (and above the statusline separators).
      zindex = math.max((vim.api.nvim_win_get_config(win).zindex or 50) - 1, 2),
      focusable = false,
      mouse = false,
      style = "minimal",
      border = "none",
    }
  end
  -- Don't fire WinNew/BufEnter/etc for other plugins to react to.
  local backdrop = vim.api.nvim_open_win(
    buf, false, vim.tbl_extend("force", config(), {noautocmd = true}))
  vim.wo[backdrop].winhighlight = "NormalFloat:Backdrop"
  vim.wo[backdrop].winblend = blend

  local group = vim.api.nvim_create_augroup("backdrop_" .. backdrop, {})

  -- Keep covering the editor when it's resized.
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      if vim.api.nvim_win_is_valid(backdrop) and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(backdrop, config())
      end
    end,
  })

  -- Close along with the float. This is scheduled since windows can't always
  -- be closed from within an autocmd.
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = tostring(win),
    callback = function()
      vim.api.nvim_del_augroup_by_id(group)
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(backdrop) then
          vim.api.nvim_win_close(backdrop, true)
        end
      end)
    end,
  })
end

return M
