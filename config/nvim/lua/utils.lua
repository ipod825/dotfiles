local M = _G.utils or {}
_G.utils = M

function M.list_unique(lst)
	local cache = {}
	local res = {}
	for _, e in pairs(lst) do
		if cache[e] == nil then
			table.insert(res, e)
			cache[e] = true
		end
	end
	return res
end

function M.left_tab_termopen(cmd)
	vim.cmd("tabedit | tabmove -1")
	vim.fn.termopen(cmd, {
		on_exit = function(_, _, _)
			vim.cmd("quit")
		end,
	})
end

return M
