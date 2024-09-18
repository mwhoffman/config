-- Define the leader keys.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local keymap = vim.keymap

-- Add general keymappings.
keymap.set("n", "<c-k>", "<pageup>")
keymap.set("n", "<c-j>", "<pagedown>")
keymap.set("v", "<c-k>", "<pageup>")
keymap.set("v", "<c-j>", "<pagedown>")
