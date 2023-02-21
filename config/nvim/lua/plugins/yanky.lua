local vimfn = require("libp.utils.vimfn")

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

			local cur_line = vimfn.buf_get_line(vimfn.getrow() - 1)
			local cur_col = vimfn.getcol()
			if cur_col == #cur_line and vim.fn.nr2char(vim.fn.strgetchar(cur_line:sub(cur_col), 0)) == " " then
				vim.cmd("normal! p")
			else
				vim.cmd("normal! P")
			end
		end

		vim.keymap.set("n", "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set("n", "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set("x", "p", function()
			visual_paste()
		end)
		require("telescope._extensions").load("yank_history")
	end,
}
