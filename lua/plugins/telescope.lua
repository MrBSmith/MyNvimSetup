return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      "sharkdp/fd",
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>o", builtin.find_files, {})
      vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = actions.select_vertical,
              ["<C-h>"] = actions.select_horizontal,
            },
            n = {
              ["s"] = actions.select_vertical,
              ["h"] = actions.select_horizontal,
            },
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
