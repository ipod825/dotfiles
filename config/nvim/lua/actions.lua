local M = {}
local fuzzy_menu = require("fuzzy_menu")

function M.EditBin()
	vim.bo.bin = true
	vim.api.nvim_exec2(
		[[
      autocmd BufReadPost <buffer> if &bin | %!xxd
      autocmd BufReadPost <buffer> set ft=xxd | endif
      autocmd BufWritePre <buffer> if &bin | let b:cursorpos=getcurpos() | %!xxd -r
      autocmd BufWritePre <buffer> endif
      autocmd BufWritePost <buffer> if &bin | undojoin | silent keepjumps %!xxd
      autocmd BufWritePost <buffer> set nomod | call setpos('.', b:cursorpos) | endif
      edit
  ]],
		{}
	)
end

function M.cheat_sheet()
	local id = vim.b.terminal_job_id
	local cheats = vim.list_extend(
		vim.fn.systemlist(string.format("cat %s/dotfiles/misc/cheatsheet", vim.env.HOME)),
		vim.fn.systemlist(string.format("cat %s/.local/share/cheatsheet", vim.env.HOME))
	)

	fuzzy_menu.pick(cheats, function(value)
		if id then
			vim.fn.chansend(id, value)
			vim.defer_fn(function()
				vim.cmd("normal! i")
			end, 50)
		else
			vim.fn.setreg('"', value)
		end
	end)
end

return M
