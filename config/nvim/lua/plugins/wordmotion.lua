return {
		"chaoren/vim-wordmotion",
		init = function()
			vim.g.wordmotion_nomap = 1
			vim.keymap.set("n", "w", "<Plug>WordMotion_w", { remap = true })
			vim.keymap.set("x", "w", "<Plug>WordMotion_e", { remap = true })
			vim.keymap.set("o", "w", "<Plug>WordMotion_e", { remap = true })
			vim.keymap.set("n", "e", "<Plug>WordMotion_e", { remap = true })
			vim.keymap.set("x", "e", "<Plug>WordMotion_e", { remap = true })
			vim.keymap.set("n", "b", "<Plug>WordMotion_b", { remap = true })
			vim.keymap.set("x", "b", "<Plug>WordMotion_b", { remap = true })
			vim.keymap.set("x", "iv", "<Plug>WordMotion_iw", { remap = true })
			vim.keymap.set("o", "iv", "<Plug>WordMotion_iw", { remap = true })
		end,
	}
