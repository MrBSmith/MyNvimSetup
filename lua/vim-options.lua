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
vim.opt.fileignorecase = false
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
vim.env.FZF_DEFAULT_OPTS = "--case=respect"
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

local split_args_multiline = function()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local start_line = s_start[2]
    local end_line_orig = s_end[2]
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line_orig, false)
    if #lines == 0 then return end

    local text = table.concat(lines, "\n")
    local result = ""
    local depth = 0
    local first_bracket_found = false
    local open_bracket, close_bracket

    for i = 1, #text do
        local char = text:sub(i, i)

        if not first_bracket_found then
            if char == "(" or char == "{" then
                first_bracket_found = true
                open_bracket = char
                close_bracket = (char == "(") and ")" or "}"
                result = result .. char .. "\n"
                depth = 1
            else
                result = result .. char
            end
        else
            if char == open_bracket then
                depth = depth + 1
                result = result .. char
            elseif char == close_bracket then
                depth = depth - 1
                if depth == 0 then
                    result = result .. "\n" .. char
                else
                    result = result .. char
                end
            elseif char == "," and depth == 1 then
                result = result .. ",\n"
            elseif char == "\n" or char == "\r" then
                -- Ignore
            else
                -- Basic check: if we just added a newline, don't start with a space
                if not (char == " " and result:sub(-1) == "\n") then
                    result = result .. char
                end
            end
        end
    end

    -- Replace text
    local split_lines = vim.split(result, "\n")
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line_orig, false, split_lines)

    -- We wait a tiny bit for the buffer to update, then select the new lines and hit '='
    local new_end_line = start_line + #split_lines - 1
    vim.schedule(function()
        vim.cmd(string.format("normal! %dGV%dG=", start_line, new_end_line))
    end)
end

local function trim_whitespace()
    -- Get the selection range
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local start_line = s_start[2]
    local end_line = s_end[2]

    -- Fetch the lines from the buffer
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- Iterate and strip trailing whitespace
    local processed_lines = {}
    for _, line in ipairs(lines) do
        -- %s is any whitespace, + is one or more, $ is end of string
        table.insert(processed_lines, (line:gsub("%s+$", "")))
    end

    -- Set the lines back in the buffer
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, processed_lines)
    print(string.format("Trimmed whitespace on %d lines", #processed_lines))
end

local function align_declarations()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local start_line = s_start[2]
    local end_line = s_end[2]

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 0 then return end

    local function align_on_char(target_lines, char)
        local max_pos = 0
        local pieces = {}

        -- First pass: split lines and find the furthest character position
        for _, line in ipairs(target_lines) do
            local start_idx, end_idx = line:find(char)
            if start_idx then
                local left = line:sub(1, start_idx - 1):gsub("%s+$", "")
                local right = line:sub(end_idx + 1):gsub("^%s+", "")
                max_pos = math.max(max_pos, #left)
                table.insert(pieces, {left = left, right = right, has_char = true})
            else
                table.insert(pieces, {full = line, has_char = false})
            end
        end

        -- Second pass: rebuild lines with padding
        local new_lines = {}
        for _, p in ipairs(pieces) do
            if p.has_char then
                local padding = string.rep(" ", max_pos - #p.left)
                table.insert(new_lines, p.left .. padding .. " " .. char .. " " .. p.right)
            else
                table.insert(new_lines, p.full)
            end
        end
        return new_lines
    end

    -- Run for colons, then run the result through the equals-sign aligner
    local colons_aligned = align_on_char(lines, ":")
    local final_lines = align_on_char(colons_aligned, "=")

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, final_lines)
end

-- Keybinding
vim.keymap.set("v", "<leader>ga", [[:<C-u>lua align_declarations()<CR>]], { desc = "Align : and =" })

vim.api.nvim_create_user_command("GDConstructor", gd_constructor, {range=2})
vim.api.nvim_create_user_command("SplitArgsMultiline", split_args_multiline, {range=2})
vim.api.nvim_create_user_command("TrimWhitespaces", trim_whitespace, {range=2})
vim.api.nvim_create_user_command("AlignDeclarations", align_declarations, {range=2})


--------------------
-- CUSTOM KEYMAPS --
--------------------

-- Invoke Oil.nvim
map("n", "-", "<cmd>Oil<CR>")

-- Remap demi page up/down to recenter the cursor in the middle of the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true })
map("n", "G", "Gzz", { noremap = true })

-- Remap L and R to $ and ^
map("n", "L", "$")
map("n", "H", "^")
map("v", "L", "$h")
map("v", "H", "^")

-- Disable arrows in normal mode
map("n", "<Up>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Down>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<left>", ":echoe 'No arrows allowed, you fool!'<CR>")
map("n", "<Right>", ":echoe 'No arrows allowed, you fool!'<CR>")

-- Automatically create a setter & an associated signal to the variable under the cursor in normal mode or highlighted in visual mode
map("n", "<leader>s", "yiwA:\rset(value):\r  if value != pa:\r	<BS>pa = value\r.pa_changed.emit()\r\risignal pa_changed2k^x2j$")
map("v", "<leader>s", "yA:\rset(value):\r  if value != pa:\r	<BS>pa = value\r.pa_changed.emit()\r\risignal pa_changed2k^x2j$")

-- Yank/paste in OS's clipboard - Its way faster than typing "+y ot "+p
map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>p", "\"+P")
map("v", "<leader>p", "_d\"+P")

-- Add a log to the current highlighted variable in visual mode or the word under the cursor in normal mode
map("n", "<leader>l", "viwyoprint(\"\")2hpa: la + astr()hp")
map("v", "<leader>l", "yoprint(\"\")2hpa: la + astr()hp")

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
map("v", "<leader>co", ":GDConstructor<CR>")
map("v", "<leader>m", ":SplitArgsMultiline<CR>")
map("v", "<leader>tw", ":TrimWhitespaces<CR>")
map("v", "<leader>al", ":AlignDeclarations<CR>")

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--     pattern = { "*" },
--     command = [[%s/\s\+$//e]],
-- })

-- Highlight on yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    callback = function ()
       vim.highlight.on_yank()
    end,
})
