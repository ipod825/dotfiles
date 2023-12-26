return {
		"git@github.com:ipod825/war.vim",
		lazy=false,
		config = function()
			local WAR = vim.api.nvim_create_augroup("WAR", {})
			vim.api.nvim_create_autocmd("Filetype", {
				group = WAR,
				pattern = "esearch",
				callback = function()
					vim.fn["war#fire"](0.8, -1, 0.2, -1)
				end,
			})
			vim.api.nvim_create_autocmd("Filetype", {
				group = WAR,
				pattern = "tagbar",
				callback = function()
					vim.fn["war#fire"](0.7, -1, -1, -1)
				end,
			})
			vim.api.nvim_create_autocmd("Filetype", {
				group = WAR,
				pattern = "bookmark",
				callback = function()
					vim.fn["war#fire"](-1, 1, -1, 0.2)
					vim.fn["war#enter"]()
				end,
			})
			vim.api.nvim_create_autocmd("Filetype", {
				group = WAR,
				pattern = { "dapui_breakpoints", "dapui_stacks" },
				callback = function()
					vim.fn["war#fire"](0.8, 0.3, 0.5, 0.3)
				end,
			})
			vim.api.nvim_create_autocmd("Filetype", {
				group = WAR,
				pattern = { "dapui_repl", "dapui_console" },
				callback = function()
					vim.fn["war#fire"](0.8, 0.3, 0.5, 0.01)
				end,
			})
		end,
	}
