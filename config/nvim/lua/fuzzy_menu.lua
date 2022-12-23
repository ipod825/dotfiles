local M = {}
local map = vim.keymap.set

local itt = require("libp.itertools")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local utils = require("utils")

function M.telescope_pick(content, cb, opts)
	opts = opts or {}
	pickers
		.new(opts, {
			finder = finders.new_table(vim.tbl_extend("keep", {
				results = content,
			}, opts)),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					cb(action_state.get_selected_entry().value)
				end)
				return true
			end,
		})
		:find()
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

M.add_util_menu("JavaCopyInclude", function()
	for i in itt.range(1, vim.api.nvim_buf_line_count(0)) do
		local package = vim.fn.getline(i):match("^package (.*);")
		if package then
			vim.fn.setreg('"', ("import %s.%s;"):format(package, vim.fn.expand("<cword>")))
			return
		end
	end
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

M.add_util_menu("EditBin", function()
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

M.add_util_menu("ReloadPlugin", function()
	local pathfn = require("libp.utils.pathfn")
	local plugin = vim.split(pathfn.basename(pathfn.find_directory(".git")), "%.")[1]

	for _, buffer in pairs(require("libp.global")("libp").buffers) do
		vim.cmd("bwipe " .. buffer.id)
	end
	require("vplug").reload(plugin)
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

function M.oldfiles(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			finder = finders.new_table({
				results = vim.tbl_filter(function(e)
					return e:match("cloud/" .. vim.env.USER) or vim.fn.filereadable(e) ~= 0
				end, require("oldfiles").oldfiles()),
				entry_maker = require("telescope.make_entry").gen_from_file(opts),
			}),
			attach_mappings = function(prompt_bufnr, mapfn)
				mapfn("i", "<c-d>", function()
					local current_entry = action_state.get_selected_entry()
					vim.loop.fs_unlink(current_entry[1])
					require("oldfiles").remove(current_entry[1])
					action_state.get_current_picker(prompt_bufnr):refresh()
				end)
				return true
			end,
			previewer = conf.file_previewer(opts),
			sorter = conf.file_sorter(opts),
		})
		:find()
end
map("n", "<c-o>", M.oldfiles)

return M
