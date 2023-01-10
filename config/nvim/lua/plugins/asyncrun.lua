return {
		"skywind3000/asyncrun.vim",
		config = function()
			vim.g.asyncrun_pathfix = 1
			vim.g.asyncrun_open = 6
			local ASYNCRUN = vim.api.nvim_create_augroup("ASYNCRUN", {})
			vim.api.nvim_create_autocmd("User", {
				group = ASYNCRUN,
				pattern = "AsyncRunPre",
				callback = function()
					vim.cmd("wincmd o")
					vim.g.asyncrun_win = vim.api.nvim_get_current_win()
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = ASYNCRUN,
				pattern = "AsyncRunStop",
				callback = function()
					vim.api.nvim_set_current_win(vim.g.asyncrun_win)
					if vim.g.asyncrun_code == 0 then
						vim.cmd("cclose")
					else
						vim.fn.setqflist(vim.tbl_filter(function(e)
							return e.valid ~= 0
						end, vim.fn.getqflist()))
						vim.cmd("botright copen")
					end
				end,
			})
		end,
	}
