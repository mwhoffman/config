-- Define the leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add general keymappings.
vim.keymap.set({"n", "v"}, "<c-k>", "<c-u>", {desc="Scroll upwards"})
vim.keymap.set({"n", "v"}, "<c-j>", "<c-d>", {desc="Scroll downwards"})

-- Delete some useless builtins.
vim.keymap.del("n", "&")
