return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
    require("catppuccin").setup {
      custom_highlights = function (colors)
        return {
          Comment = { fg = "#1d6630"}
        }
      end
    }
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
