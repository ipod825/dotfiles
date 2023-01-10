return {
	"p00f/nvim-ts-rainbow",
	config = function()
		require("nvim-treesitter.configs").setup({
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
			require("colorscheme").add_plug_hl({
				rainbowcol1 = { fg = "#e5c07b", bold = true },
				rainbowcol2 = { fg = "#8CCBEA", bold = true },
				rainbowcol3 = { fg = "#A4E57E", bold = true },
				rainbowcol4 = { fg = "#FF7272", bold = true },
				rainbowcol5 = { fg = "#FFB3FF", bold = true },
				rainbowcol6 = { fg = "#9999FF", bold = true },
			}),
		})
	end,
}
