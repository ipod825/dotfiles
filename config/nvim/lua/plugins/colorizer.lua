return
{
	"norcalli/nvim-colorizer.lua",
	init = function()
		vim.o.termguicolors = true
	end,
	config = function()
		require("colorizer").setup()
	end,
}
