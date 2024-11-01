return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function ()
    require("toggleterm").setup{
      size = 20,
      open_mapping = "<F5>",
      hide_numbers = true,
      direction = 'horizontal',
      auto_scroll = true,
      start_in_insert = true,
    }
  end
}
