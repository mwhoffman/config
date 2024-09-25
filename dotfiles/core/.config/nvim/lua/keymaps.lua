-- Define the leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add general keymappings.
vim.keymap.set({"n", "v"}, "<c-k>", "<c-u>", {desc="Scroll upwards"})
vim.keymap.set({"n", "v"}, "<c-j>", "<c-d>", {desc="Scroll downwards"})

vim.keymap.set("c", "<c-a>", "<Home>")
vim.keymap.set("c", "<c-e>", "<End>")

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", {desc="Buffer next"})
vim.keymap.set("n", "<leader>p", "<cmd>bprev<cr>", {desc="Buffer prev"})

-- Delete some useless builtins.
vim.keymap.del("n", "&")
