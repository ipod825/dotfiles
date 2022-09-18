local M = {}
local KVIter = require("libp.datatype.KVIter")

function M.save_keymap(keymaps)
	local res = {}
	for mode, mappings in KVIter(keymaps) do
		for key, _ in KVIter(mappings) do
			local mapping = vim.fn.maparg(key, mode, false, true)
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

function M.restore_keymap(mappings)
	for _, v in pairs(mappings) do
		local options = {
			remap = (v.remap and v.remap ~= 0),
			nowait = (v.nowait and v.nowait ~= 0),
			silent = (v.silent and v.silent ~= 0),
			script = (v.script and v.script ~= 0),
			expr = (v.expr and v.expr ~= 0),
			unique = (v.unique and v.unique ~= 0),
		}
		if v.rhs or v.callback then
			vim.keymap.set(v.mode, v.lhs, v.rhs or v.callback, options)
		else
			vim.keymap.del(v.mode, v.lhs)
		end
	end
end

function M.term_feed(str)
	vim.fn.chansend(vim.b.terminal_job_id, string.gsub(str, "%s+", " ") .. "\r")
end

function M.feed_plug_keys(key)
	vim.fn.feedkeys(string.format("%c%c%c%s", 0x80, 253, 83, key))
end

return M
