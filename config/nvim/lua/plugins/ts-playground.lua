return {
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
		config = function()
			require("nvim-treesitter.configs").setup({
				playground = {
					enable = true,
					disable = {},
					updatetime = 25,
					persist_queries = false,
				},
			})
		end,
	}
