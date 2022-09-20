local M = {}
local api = vim.api
local devicon = require("libp.integration.web_devicon")
local List = require("libp.datatype.List")
local itt = require("libp.itertools")
local pathfn = require("libp.utils.pathfn")

local scratch_name = "[Scratch]"
function M.get_file_icon(buf_id)
	local filetype = api.nvim_buf_get_option(buf_id, "ft")
	local icon
	local icon_hl = "Directory"
	if filetype == "ranger" then
		icon = ""
	else
		local abspath = api.nvim_buf_get_name(buf_id)
		local devicon_res = devicon.get(abspath)
		icon = devicon_res.icon
		icon_hl = devicon_res.hl_group
	end
	return icon .. " ", icon_hl
end

function M.tab_label(tab_id, current_tab_id)
	local win_id = api.nvim_tabpage_get_win(tab_id)
	local buf_id = api.nvim_win_get_buf(win_id)
	local abspath = api.nvim_buf_get_name(buf_id)
	if abspath == "" then
		for win in itt.values(api.nvim_tabpage_list_wins(tab_id)) do
			if win ~= win_id then
				buf_id = api.nvim_win_get_buf(win)
				abspath = api.nvim_buf_get_name(buf_id)
			end

			if abspath ~= "" then
				break
			end
		end
	end

	if abspath == "" then
		abspath = scratch_name
	end

	local basename = string.format("%s", vim.fs.basename(abspath))
	local current_tab_nr = api.nvim_tabpage_get_number(current_tab_id)
	local tab_nr = api.nvim_tabpage_get_number(tab_id)
	local is_current = (tab_id == current_tab_id)
	local is_left_to_current = (tab_nr == current_tab_nr - 1)
	local mod = api.nvim_buf_get_option(buf_id, "mod") and "Mod" or ""
	local content_hl = (is_current and "TabLineSel" or "TabLine") .. mod
	return {
		abspath = abspath,
		content = basename,
		is_current = is_current,
		buf_id = buf_id,
		is_left_to_current = is_left_to_current,
		content_hl = content_hl,
	}
end

function M.plain_length(label)
	local res = 0
	for _, e in pairs(label.elements) do
		res = res + vim.fn.strwidth(e.content)
	end
	return res
end

function M.filter(labels)
	local width = vim.o.columns

	local current_nr = api.nvim_tabpage_get_number(api.nvim_get_current_tabpage())
	local left_nr = current_nr
	local right_nr = current_nr
	local total_length = M.plain_length(labels[current_nr])

	while true do
		local l = left_nr - 1
		local r = right_nr + 1
		local l_length = l > 0 and M.plain_length(labels[l]) or 0
		local r_length = r <= #labels and M.plain_length(labels[r]) or 0
		total_length = total_length + l_length + r_length
		left_nr = l > 0 and l or left_nr
		right_nr = r <= #labels and r or right_nr
		if total_length >= width or (left_nr == 1 and right_nr == #labels) then
			break
		end
	end

	return vim.list_slice(labels, left_nr, right_nr), total_length, left_nr > 1, right_nr < #labels
end

function M.reduce_from_right(total_length, width, labels)
	local target_reduce = total_length - width
	local l = #labels
	while target_reduce > 0 and l > 1 do
		local last_label = labels[l]
		local i = #last_label.elements
		while i > 0 do
			local c = last_label.elements[i].content
			-- todo: handle unicode substr
			last_label.elements[i].content = c:sub(1, math.max(#c - target_reduce, 0))
			target_reduce = target_reduce - math.min(vim.fn.strwidth(c), target_reduce)
			i = i - 1
		end
		l = l - 1
	end
end

function M.reduce_from_left(total_length, width, labels)
	local target_reduce = total_length - width
	local l = 1
	while target_reduce > 0 and l < #labels do
		local first_label = labels[l]
		local i = 1

		while i <= #first_label.elements do
			local c = first_label.elements[i].content
			-- todo: handle unicode substr
			first_label.elements[i].content = c:sub(target_reduce + 1)
			target_reduce = target_reduce - math.min(vim.fn.strwidth(c), target_reduce)
			i = i + 1
		end
		l = l + 1
	end
end

function M.gen_tab_line(labels, total_length, left_has_more, right_has_more)
	local left_more_indicator = left_has_more and "⮜" or ""
	local right_more_indicator = right_has_more and "⮞" or ""
	local width = vim.o.columns - vim.fn.strwidth(left_more_indicator) - vim.fn.strwidth(right_more_indicator)

	if total_length > width then
		if not right_has_more then
			M.reduce_from_left(total_length, width, labels)
		else
			M.reduce_from_right(total_length, width, labels)
		end
	end

	local res = ""
	for _, label in pairs(labels) do
		for _, element in pairs(label.elements) do
			res = res .. string.format("%%#%s#%s", element.highlight or label.highlight, element.content)
		end
	end
	return string.format(
		"%%#DiffDelete#%s%s%%#DiffDelete#%s%%#TabLine#",
		left_more_indicator,
		res,
		right_more_indicator
	)
end

function M.dedup(labels)
	-- Only consider different buffers containing common substring as duplicate. For same buffer, just show the same basename.
	local buf_id_count = vim.defaulttable(function()
		return 0
	end)
	for label in itt.values(labels) do
		buf_id_count[label.buf_id] = buf_id_count[label.buf_id] + 1
	end
	labels = labels:filter(function(e)
		return buf_id_count[e.buf_id] == 1
	end)

	if #labels == 0 then
		return
	end

	-- Join the full path segment by segment until each path is unique among all tabs.
	for label in itt.values(labels) do
		label.segs = vim.split(label.abspath, "/")
		label.ind = #label.segs - 1
	end

	while true do
		local content_count = vim.defaulttable(function()
			return 0
		end)
		for label in itt.values(labels) do
			if not label.unique then
				label.content = pathfn.join(label.segs[label.ind], label.content)
				label.ind = label.ind - 1
				content_count[label.content] = content_count[label.content] + 1
			end
		end

		local unique_count = 0
		for label in itt.values(labels) do
			if content_count[label.content] == 1 then
				label.unique = true
				unique_count = unique_count + 1
			end
		end

		if unique_count == #labels then
			break
		end
	end
end

function M.build_elements(labels)
	for label in itt.values(labels) do
		local icon, icon_hl = M.get_file_icon(label.buf_id)
		label.elements = {
			{ highlight = "Directory", content = label.is_current and "|" or "" },
			{ highlight = icon_hl, content = icon },
			{ highlight = label.content_hl, content = label.content },
			{ highlight = "NonText", content = label.is_left_to_current and "" or "|" },
		}
	end
end

function M.tabline()
	local labels = List()
	local total_length, left_has_more, right_has_more

	local current_tab_id = api.nvim_get_current_tabpage()
	local content_dedup = vim.defaulttable(List)
	for _, tab_id in pairs(api.nvim_list_tabpages()) do
		local label = M.tab_label(tab_id, current_tab_id)
		labels:append(label)
		if label.content ~= scratch_name then
			content_dedup[label.content]:append(label)
		end
	end

	for _, dup_labels in pairs(content_dedup) do
		if #dup_labels ~= 1 then
			M.dedup(dup_labels)
		end
	end
	M.build_elements(labels)

	labels, total_length, left_has_more, right_has_more = M.filter(labels)
	return M.gen_tab_line(labels, total_length, left_has_more, right_has_more)
end

vim.o.tabline = "%!v:lua.require('tabline').tabline()"
return M
