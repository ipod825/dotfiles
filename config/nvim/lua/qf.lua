local M = {}
local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("QF", {}),
	pattern = { "qf" },
	callback = function()
		require("qf").setup()
	end,
})

function M.open()
	require("bqf.qfwin.handler").open(false)
end

function M.setup()
	vim.cmd("silent! wincmd J")
	map("n", "j", "<down>", { buffer = true })
	map("n", "k", "<up>", { buffer = true })
	map("n", "<cr>", function()
		require("qf").open()
	end, { buffer = true })
	map("n", "/", function()
		require("bqf.filter.fzf").run()
	end, { buffer = true })
end

return M
