return {
		"wellle/context.vim",
		cmd = "ContextPeek",
		init = function()
			vim.g.context_add_mappings = 0
			vim.g.context_enabled = 0
		end,
		config = function()
			vim.keymap.set("n", "<m-i>", "<cmd>ContextPeek<cr>")
		end,
	}
