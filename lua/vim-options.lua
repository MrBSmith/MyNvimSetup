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
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
local map = vim.keymap.set

local function get_visual_selection()
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    local selection = vim.fn.getregion(vstart, vend)
    return table.concat(selection, "\n")
end


local gd_constructor = function()
	local selection = get_visual_selection()
	-- Get the variable's name and type in two capture groups
	local pattern = "var%s(%S+)%s*%:%s*(%S*)"
	local variables = {}

	for name, type in string.gmatch(selection, pattern) do
		table.insert(variables, {name, type})
	end

	local selection_last_line = vim.fn.getpos("'>")[2]
	local buf = vim.api.nvim_get_current_buf()

	-- Generate constructor's header
	local header_line = selection_last_line + 1
	local header_content = ""

	for i, variable in ipairs(variables) do
		local var = table.concat(variable, ": ")
		header_content = header_content.."_"..var
		if (i ~= #variables) then
			header_content = header_content..", "
		end
	end

	local header = string.format("func _init(%s) -> void:", header_content)
	vim.api.nvim_buf_set_lines(buf, header_line, header_line, false, {header})

	-- Generate constructor's body
	local body = {}

	for _, variable in ipairs(variables) do
		local line = string.format("	%s = _%s", variable[1], variable[1])
		table.insert(body, line)
	end

	local body_line = header_line + 1
	vim.api.nvim_buf_set_lines(buf, body_line, body_line, false, body)

	-- Add two empty lines after the constructor to keep the script nicely spaced out
	local func_end_line = body_line + #variables
	vim.api.nvim_buf_set_lines(buf, func_end_line, func_end_line, false, {"", ""})

end

vim.api.nvim_create_user_command("GDConstructor", gd_constructor, {range=2})

--------------------
-- CUSTOM KEYMAPS --
--------------------

-- Invoke Oil.nvim
map("n", "-", "<cmd>Oil<CR>")

-- Remap demi page up/down to recenter the cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true })
map("n", "G", "Gzz", { noremap = true })

-- Disable arrows in normal mode
map("n", "<Up>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Down>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<left>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Right>", ":echoe 'No arrows allowed, you fool!'<CR>")

-- Automatically create a setter & an associated signal to the variable under the cursor in normal mode or highlighted in visual mode
map("n", "<leader>s", "yiwA:\rset(value):\r  if value != pa:\r	<BS>pa = value\r.pa_changed.emit()\r\risignal pa_changed2k^x2j$")
map("v", "<leader>s", "yA:\rset(value):\r  if value != pa:\r	<BS>pa = value\r.pa_changed.emit()\r\risignal pa_changed2k^x2j$")

-- Add a log to the current highlighted variable in visual mode or the word under the cursor in normal mode
map("n", "<leader>p", "viwyoprint(\"\")2hpa: la + astr()hp")
map("v", "<leader>p", "yoprint(\"\")2hpa: la + astr()hp")

-- Comment out the current line
map("n", "<leader>cc", "I#<CR>")
map("v", "<leader>cc", ":'<,'>norm I#<CR>")

-- Remove the current line's comment
map("n", "<leader>dc", "^x<CR>")
map("v", "<leader>dc", ":'<,'>norm ^x<CR>")

-- Insert the current file name
map("n", "<leader>n", "i<c-r>=expand(\"%:t\")<cr>")

-- Automatically declare class_name in GDscript based on the name of the file
map("n", "<leader>cn", "oclass_name <c-r>=expand(\"%:t\")<CR>F.D")

-- Create a GDscript constructor based on the visualy selected variables
map("v", "<leader>co", ":GDConstructor<cr>")

