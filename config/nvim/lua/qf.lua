local M = {}
local map = vim.keymap.set

vim.api.nvim_exec(
	[[
augroup QF
    autocmd!
    autocmd FileType qf lua require'qf'.setup()
augroup END
]],
	false
)

function M.open()
	require("bqf.qfwin.handler").open(false)
end

function M.setup()
	vim.cmd("silent! wincmd J")
	map("n", "j", "<down>", { buffer = true })
	map("n", "k", "<up>", { buffer = true })
	map("n", "<cr>", "<cmd>lua require'qf'.open()<cr>", { buffer = true })
end

return M
