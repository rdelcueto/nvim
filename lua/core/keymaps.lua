-- lua/core/keymaps.lua --- Leaders & Global Maps

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Exit insert mode
map("i", "<C-g>", "<ESC>", opts)

-- M-x equivalent
map("n", "<leader><leader>", "<cmd>FzfLua commands<CR>", { desc = "M-x (commands)" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>bk", "<cmd>bdelete<CR>", { desc = "Kill buffer" })
map("n", "<leader>br", "<cmd>edit!<CR>", { desc = "Reload buffer" })
map("n", "<leader>TAB", "<cmd>b#<CR>", { desc = "Last buffer" })

-- Files
map("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save file" })

-- Windows
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>w/", "<C-w>v", { desc = "Split right" })
map("n", "<leader>w-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit" })
