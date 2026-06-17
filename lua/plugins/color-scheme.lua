--return {
--	"catppuccin/nvim",
--	name = "catppuccin",
--	priority = 1000,
--	config = function()
--    require("catppuccin").setup {
--      custom_highlights = function (colors)
--        return {
--          Comment = { fg = "#1d6630"}
--        }
--      end
--    }
--		vim.cmd.colorscheme("catppuccin-mocha")
--	end,
--}

return {
    -- add dracula
    "Mofiqul/dracula.nvim",
    name = "dracula",
    priority = 1000,
    config = function ()
        require("dracula").setup {
            opts = {
                colorscheme = "dracula",
            },
			colors = {
				bg = "#282A36",
				fg = "#F8F8F2",
				selection = "#44475A",
				comment = "#6272A4",
				red = "#FF5555",
				orange = "#FFB86C",
				yellow = "#F1FA8C",
				green = "#50fa7b",
				purple = "#BD93F9",
				cyan = "#8BE9FD",
				pink = "#FF79C6",
				bright_red = "#FF6E6E",
				bright_green = "#69FF94",
				bright_yellow = "#FFFFA5",
				bright_blue = "#D6ACFF",
				bright_magenta = "#FF92DF",
				bright_cyan = "#A4FFFF",
				bright_white = "#FFFFFF",
				menu = "#21222C",
				visual = "#3E4452",
				gutter_fg = "#4B5263",
				nontext = "#3B4048",
				white = "#ABB2BF",
				black = "#191A21",
			},
			-- set italic comment
			italic_comment = true, -- default false
			-- overrides the default highlights with table see `:h synIDattr`
			overrides = {},
		}
		vim.cmd.colorscheme("dracula-soft")
	end
}
