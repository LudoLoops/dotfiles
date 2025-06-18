-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", { desc = "window left" })
keymap.set("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", { desc = "window down" })
keymap.set("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", { desc = "window up" })
keymap.set("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", { desc = "window right" })

keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
