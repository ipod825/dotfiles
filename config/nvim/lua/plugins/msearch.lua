return {
		"git@github.com:ipod825/msearch.vim",
		config = function()
			vim.keymap.set("n", "8", "<Plug>MSToggleAddCword", { remap = true })
			vim.keymap.set("x", "8", "<Plug>MSToggleAddVisual", { remap = true })
			vim.keymap.set("n", "*", "<Plug>MSExclusiveAddCword", { remap = true })
			vim.keymap.set("x", "*", "<Plug>MSExclusiveAddVisual", { remap = true })
			vim.keymap.set("n", "n", "<Plug>MSNext", { remap = true })
			vim.keymap.set("n", "N", "<Plug>MSPrev", { remap = true })
			vim.keymap.set("o", "n", "<Plug>MSNext", { remap = true })
			vim.keymap.set("o", "N", "<Plug>MSPrev", { remap = true })
			vim.keymap.set("n", "<leader>n", "<Plug>MSToggleJump", { remap = true })
			vim.keymap.set("n", "<leader>/", "<Plug>MSClear", { remap = true })
			vim.keymap.set("n", "?", "<Plug>MSAddBySearchForward", { remap = true })
		end,
	}
