-- Define the leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quickly move up and down.
vim.keymap.set({"n", "v"}, "<c-k>", "<c-u>", {desc="Scroll upwards"})
vim.keymap.set({"n", "v"}, "<c-j>", "<c-d>", {desc="Scroll downwards"})

-- Enable quick movement to beginning/end of line in command mode.
vim.keymap.set("c", "<c-a>", "<Home>")
vim.keymap.set("c", "<c-e>", "<End>")

-- Show LSP documentation.
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")

-- Move between recent buffers.
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", {desc="Buffer next"})
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", {desc="Buffer prev"})

-- Manage splits.
vim.keymap.set("n", "<leader>se", "<c-w>=", {desc="Equalize windows"})
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", {desc="Close window"})
