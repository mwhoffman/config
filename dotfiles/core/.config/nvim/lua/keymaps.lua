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
vim.keymap.set("n", "<Esc>", function()
  local win = vim.b.lsp_floating_preview
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end, {desc = "Close hover"})

-- Move between recent buffers.
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", {desc = "Buffer next"})
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", {desc = "Buffer prev"})

-- Manage windows.
vim.keymap.set("n", "<leader>we", "<c-w>=", {desc = "Equalize windows"})
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>", {desc = "Close window"})
