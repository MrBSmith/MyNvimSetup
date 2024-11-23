return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            ensure_installed = { "lua", "zig", "gdscript" },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<Leader>is",
                node_incremental = "<Leader>ni",
                scope_incremental = "<Leader>si",
                node_decremental = "<Leader>nd"
              },
            },
        })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
