return {
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({
				highlight = {
					on_put = false,
					on_yank = false,
				},
			})
			local function visual_paste()
				local ori_mode = vim.fn.mode()
				vim.cmd('normal! "_d')
				if ori_mode ~= "V" then
					vim.fn.setreg('"', vim.trim(vim.fn.getreg('"')))
				end
				vim.cmd("normal! P")
			end

			vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set("x", "p", function()
				visual_paste()
			end)
			require("telescope._extensions").load("yank_history")
		end,
	}
