return {
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				qf_win_option = {
					wrap = true,
					number = false,
					relativenumber = false,
				},
				func_map = {
					tabdrop = "<cr>",
					open = "<c-e>",
				},
				preview = { win_height = 35 },
			})
		end,
	}
