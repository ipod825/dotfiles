return {
	"terrortylor/nvim-comment",
	config = function()
		require("nvim_comment").setup({
			comment_empty = true,
			create_mapping = false,
		})
		vim.keymap.set("n", "<c-/>", "<cmd>CommentToggle<cr>")
		vim.keymap.set("v", "<c-/>", ":<c-u>call CommentOperator(visualmode())<cr>")
		vim.keymap.set("n", "<c-_>", "<cmd>CommentToggle<cr>")
		vim.keymap.set("v", "<c-_>", ":<c-u>call CommentOperator(visualmode())<cr>")
	end,
}
