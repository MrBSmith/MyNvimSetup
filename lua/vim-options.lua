vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set list")
vim.cmd("set listchars=tab:>·,trail:×")
vim.cmd("set relativenumber")
vim.cmd("set number")
vim.cmd("set splitright")
vim.cmd("set termguicolors")
vim.cmd("set fileformats=unix,dos")

vim.g.fileformats = "unix,dos"

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

local map = vim.keymap.set

-- Remap demi page up/down to recenter the cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Disable arrows in normal mode
map("n", "<Up>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Down>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<left>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Right>", ":echoe 'No arrows allowed, you fool!'<CR>")

-- Macro to create a setter and an associated signal in GDscript
vim.fn.setreg("z", "yiwA:\rset(value):\r  if value != pa:\r	pa = value\r.pa_changed.emit()\r\risignal pa_changed2k^x2j$")

