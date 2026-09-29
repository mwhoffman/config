-- Define the leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quickly move up and down.
vim.keymap.set({"n", "v"}, "<c-k>", "<c-u>", {desc = "Scroll upwards"})
vim.keymap.set({"n", "v"}, "<c-j>", "<c-d>", {desc = "Scroll downwards"})

-- Enable quick movement to beginning/end of line in command mode.
vim.keymap.set("c", "<c-a>", "<Home>")
vim.keymap.set("c", "<c-e>", "<End>")

-- Close an LSP hover/diagnostic float (if one is open) without moving the
-- cursor. Otherwise do nothing, which is all <Esc> does in normal mode anyway.
-- Noice shows hover and signature help in its own popups, so close those too
-- (but only if noice has loaded them, rather than loading it here).
vim.keymap.set("n", "<Esc>", function()
  local win = vim.b.lsp_floating_preview
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  local docs = package.loaded["noice.lsp.docs"]
  if docs then
    for _, message in pairs(docs._messages) do
      if message:win() then
        docs.hide(message)
      end
    end
  end
end, {desc = "Close hover"})

-- Extend the default <c-l> (clear search highlighting, update diffs and
-- redraw) to also dismiss any notifications. Silenced since the Noice command
-- doesn't exist until noice loads.
vim.keymap.set("n", "<c-l>", function()
  vim.cmd("nohlsearch | diffupdate | silent! Noice dismiss")
end, {desc = "Redraw and dismiss notifications"})

-- Move between recent buffers.
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", {desc = "Buffer next"})
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", {desc = "Buffer prev"})

-- Manage windows.
vim.keymap.set("n", "<leader>we", "<c-w>=", {desc = "Equalize windows"})
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>", {desc = "Close window"})
