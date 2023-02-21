return {
		"justinmk/vim-sneak",
		enabled=false,
		config = function()
			vim.g["sneak#label"] = 1
			vim.g["sneak#absolute_dir"] = -4
			vim.keymap.set("n", "f", "<Plug>Sneak_f", { remap = true })
			vim.keymap.set("n", "F", "<Plug>Sneak_F", { remap = true })
			vim.keymap.set("x", "f", "<Plug>Sneak_f", { remap = true })
			vim.keymap.set("x", "F", "<Plug>Sneak_F", { remap = true })
			vim.keymap.set("n", "L", "<Plug>Sneak_;")
			vim.keymap.set("n", "H", "<Plug>Sneak_,")
			vim.keymap.set("x", "L", "<Plug>Sneak_;")
			vim.keymap.set("x", "H", "<Plug>Sneak_,")

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("SNEAK", {}),
				command = "highlight link Sneak None",
			})
		end,
	}
