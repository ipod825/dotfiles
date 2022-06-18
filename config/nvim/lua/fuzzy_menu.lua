local M = _G.fuzzy_menu or {}
_G.fuzzy_menu = M
local map = vim.keymap.set

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

function M.telescope_pick(content, cb)
	local opts = {}
	pickers.new(opts, {
		finder = finders.new_table({
			results = content,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr)
			action_set.select:replace(function()
				actions.close(prompt_bufnr)
				cb(action_state.get_selected_entry().value)
			end)

			return true
		end,
	}):find()
end

M.menu_actions = M.menu_actions or { default = {} }
function M.add_util_menu(name, fn, id)
	id = id or "default"
	M.menu_actions[id] = M.menu_actions[id] or {}
	M.menu_actions[id][name] = fn
end

function M.select(ids)
	ids = ids or { "default" }
	if type(ids) == "string" then
		ids = { ids }
	end
	local menu_actions = {}
	for _, id in pairs(ids) do
		menu_actions = vim.tbl_extend("force", menu_actions, M.menu_actions[id] or {})
	end
	local names = vim.tbl_keys(menu_actions)
	table.sort(names)

	M.telescope_pick(names, function(value)
		menu_actions[value]()
	end)
end

map("n", "<leader><cr>", M.select)

M.add_util_menu("CopyAbsPath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.fn.setreg('"', path)
end)

M.add_util_menu("CopyBaseName", function()
	local path = vim.fn.expand("%:p:t")
	vim.fn.setreg("+", path)
	vim.fn.setreg('"', path)
end)

M.add_util_menu("SelectYank", function()
	vim.cmd("Telescope yank_history")
end)

M.add_util_menu("DoAbolish", function()
	M.telescope_pick({
		"camelCase:c",
		"MixedCase:m",
		"snake_case:s",
		"SNAKE_UPPERCASE:u",
	}, function(value)
		local _, _, cmd = string.find(value, ":(.+)")
		vim.cmd(string.format("normal cr%s", cmd))
	end)
end)

M.add_util_menu("BinEdit", function()
	vim.bo.bin = true
	vim.api.nvim_exec(
		[[
      autocmd BufReadPost <buffer> if &bin | %!xxd
      autocmd BufReadPost <buffer> set ft=xxd | endif
      autocmd BufWritePre <buffer> if &bin | let b:cursorpos=getcurpos() | %!xxd -r
      autocmd BufWritePre <buffer> endif
      autocmd BufWritePost <buffer> if &bin | undojoin | silent keepjumps %!xxd
      autocmd BufWritePost <buffer> set nomod | call setpos('.', b:cursorpos) | endif
      edit
  ]],
		false
	)
end)

M.add_util_menu("RelatedFile", function()
	require("telescope.builtin").fd({ default_text = vim.fn.expand("%:t:r"), cwd = vim.fn.FindRootDirectory() })
end)

function M.cheat_sheet()
	local id = vim.b.terminal_job_id
	local cheats = vim.list_extend(
		vim.fn.systemlist(string.format("cat %s/dotfiles/misc/cheatsheet", vim.env.HOME)),
		vim.fn.systemlist(string.format("cat %s/.local/share/cheatsheet", vim.env.HOME))
	)

	M.telescope_pick(cheats, function(value)
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
map("t", "<m-c>", M.cheat_sheet)
map("n", "<m-c>", M.cheat_sheet)

M.add_util_menu("RunTests", function()
	vim.cmd("AsyncTask test")
end)

return M
