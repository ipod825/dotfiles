local M = {}

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

function M.save_keymap(keymaps)
	local res = {}
	for mode, mappings in pairs(keymaps) do
		for key, _ in pairs(mappings) do
			local mapping = vim.tbl_extend("keep", vim.fn.maparg(key, mode, false, true), { mode = mode, lhs = key })
			if mapping.buffer == 0 then
				mapping.buffer = false
			else
				mapping.buffer = vim.api.nvim_get_current_buf()
			end

			res[key] = mapping
		end
	end
	return res
end

function M.restore_keymap(mappings, mode)
	for key, v in pairs(mappings) do
		local options = {
			remap = (v.remap and v.remap ~= 0),
			nowait = (v.nowait and v.nowait ~= 0),
			silent = (v.silent and v.silent ~= 0),
			script = (v.script and v.script ~= 0),
			expr = (v.expr and v.expr ~= 0),
			unique = (v.unique and v.unique ~= 0),
		}

		if v.rhs or v.callback then
			vim.keymap.set(v.mode or mode, v.lhs or key, v.rhs or v.callback, options)
		else
			vim.keymap.del(v.mode or mode, v.lhs or key)
		end
	end
end

function M.restore_keymap_with_mode_key(keymaps)
	for mode, mappings in pairs(keymaps) do
		M.restore_keymap(mappings, mode)
	end
end

function M.term_feed(str)
	vim.fn.chansend(vim.b.terminal_job_id, string.gsub(str, "%s+", " ") .. "\r")
end

function M.feed_plug_keys(key)
	vim.fn.feedkeys(string.format("%c%c%c%s", 0x80, 253, 83, key))
end

return M
