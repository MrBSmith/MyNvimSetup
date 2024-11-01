return {
  "booperlv/nvim-gomove",
  config = function()
    require("gomove").setup({
      -- whether or not to map default key bindings, (true/false)
      map_defaults = true,
      -- whether or not to reindent lines moved vertically (true/false)
      reindent = true,
      -- whether or not to undojoin same direction moves (true/false)
      undojoin = true,
      -- whether to not to move past end column when moving blocks horizontally, (true/false)
      move_past_end_col = false,
    })
    local map = vim.api.nvim_set_keymap

    map("n", "<S-left>", "<Plug>GoNSMLeft", {})
    map("n", "<S-down>", "<Plug>GoNSMDown", {})
    map("n", "<S-up>", "<Plug>GoNSMUp", {})
    map("n", "<S-right>", "<Plug>GoNSMRight", {})

    map("x", "<S-left>", "<Plug>GoVSMLeft", {})
    map("x", "<S-down>", "<Plug>GoVSMDown", {})
    map("x", "<S-up>", "<Plug>GoVSMUp", {})
    map("x", "<S-right>", "<Plug>GoVSMRight", {})

    map("n", "<A-left>", "<Plug>GoNSDLeft", {})
    map("n", "<A-down>", "<Plug>GoNSDDown", {})
    map("n", "<A-up>", "<Plug>GoNSDUp", {})
    map("n", "<A-right>", "<Plug>GoNSDRight", {})

    map("x", "<A-left>", "<Plug>GoVSDLeft", {})
    map("x", "<A-down>", "<Plug>GoVSDDown", {})
    map("x", "<A-up>", "<Plug>GoVSDUp", {})
    map("x", "<A-right>", "<Plug>GoVSDRight", {})
  end,
}
