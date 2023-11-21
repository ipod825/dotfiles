return {
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		vim.g.indent_blankline_use_treesitter = true
		vim.g.indentLine_fileTypeExclude = { "tex", "markdown", "txt", "startify", "packer" }
	end,
}
