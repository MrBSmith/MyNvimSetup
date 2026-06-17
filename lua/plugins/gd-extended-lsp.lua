return {
    "teatek/gdscript-extended-lsp.nvim", opts = {},
    config = function ()
        local ext_lsp = require('gdscript-extended-lsp')
        ext_lsp.setup({
            doc_file_extension = ".md", -- Documentation file extension (can allow a better search in buffers list with telescope)
            view_type = "floating", -- Options : "current", "split", "vsplit", "tab", "floating"
            split_side = false, -- (For split and vsplit only) Open on the right or top on false and on the left or bottom on true
            keymaps = {
                declaration = "gd", -- Keymap to go to definition
                close = { "<Esc>" }, -- Keymap for closing the documentation
            },
            floating_win_size = 0.8, -- Floating window size
            picker = "telescope" -- Options : "telescope", "snacks"
        })
        require('telescope').load_extension('gdscript-extended-lsp')
        vim.keymap.set("n", "<leader>fd", ":Telescope gdscript-extended-lsp class<CR>")
    end
}
