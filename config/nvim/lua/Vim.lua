local M = {}

M.current = {}

function M.save_keymap(keys, mode, is_global)
	mode = mode or "n"
	if is_global == nil then
		is_global = true
	end

	if type(keys) ~= "table" then
		keys = { keys }
	end

	local not_mapped_keys = {}
	-- normalize keys
	keys = vim.tbl_map(function(e)
		local mapping = vim.fn.maparg(e, mode, false, true)
		local res = mapping.lhs
		if res == nil or (not is_global and mapping.buffer == 0) then
			table.insert(not_mapped_keys, { lhs = e, mode = mode })
		else
			res = string.gsub(res, "<Space>", " ")
		end
		return res
	end, keys)

	local res = nil
	if is_global then
		res = vim.list_extend(
			not_mapped_keys,
			vim.tbl_filter(function(e)
				return vim.tbl_contains(keys, e.lhs)
			end, vim.api.nvim_get_keymap(mode))
		)
	else
		res = vim.list_extend(
			not_mapped_keys,
			vim.tbl_filter(function(e)
				return vim.tbl_contains(keys, e.lhs)
			end, vim.api.nvim_buf_get_keymap(0, mode))
		)
	end
	local buffer_nr = is_global and -1 or vim.api.nvim_get_current_buf()
	res = vim.tbl_map(function(e)
		e.buffer = buffer_nr
		return e
	end, res)
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
