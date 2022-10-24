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

function SetQfFromFile(file)
	local content = vim.fn.readfile(file)
	-- cgetexpr uniq(filter(map(systemlist('cat /tmp/androidbuild'), function('AndroidFixPath')), "!empty(v:val)"))
	vim.fn.setqflist({}, "r", { title = "Android Build", lines = content })

	vim.fn.setqflist(vim.tbl_filter(function(e)
		return e.valid ~= 0
	end, vim.fn.getqflist()))
	vim.cmd("botright copen")
end

function M.setup()
	vim.cmd("silent! wincmd J")
	map("n", "j", "<down>", { buffer = true })
	map("n", "k", "<up>", { buffer = true })
	map("n", "co", "<cmd>:colder<cr>")
	map("n", "cn", "<cmd>:cnewer<cr>")
	map("n", "<cr>", function()
		require("qf").open()
	end, { buffer = true })
	map("n", "/", function()
		require("bqf.filter.fzf").run()
	end, { buffer = true })
end

return M
