return {
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				enable_moveright = false,
				ignored_next_char = "[,]",
				fast_wrap = {
					map = "<m-e>",
					end_key = "l",
					keys = "hjkgfdsaqwertyuiopzxcvbnm",
					highlight = "Search",
					highlight_grey = "Normal",
				},
			})
		end,
	}
