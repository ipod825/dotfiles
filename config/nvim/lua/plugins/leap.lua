return { "ggandor/leap.nvim" ,
		config = function()
			vim.keymap.set("n", "f", "<Plug>(leap-forward-to)", { remap = true })
			vim.keymap.set("n", "F", "<Plug>(leap-backward-to)", { remap = true })
		end,
}
