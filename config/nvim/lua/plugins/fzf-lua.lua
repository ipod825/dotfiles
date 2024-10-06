return {
	"ibhagwan/fzf-lua",
	enabled = false,
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			hls = { border = "Title", preview_border = "Title" },
			winopts = {
				height = 1,
				width = 1,
				border = "single",
				preview = { layout = "vertical", border = "single", vertical = "down:75%" },
			},
		})
	end,
}
