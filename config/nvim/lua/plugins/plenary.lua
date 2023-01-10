return {
		"nvim-lua/plenary.nvim",
		config = function()
			vim.api.nvim_create_autocmd("Filetype", {
				group = vim.api.nvim_create_augroup("PLENARY", {}),
				pattern = "lua",
				callback = function()
					vim.keymap.set("n", "<F6>", function()
						require("plenary.test_harness").test_directory(vim.fn.expand("%:p"))
					end, { desc = "plenary test file" })
				end,
			})
		end,
	}
