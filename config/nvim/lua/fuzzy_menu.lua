local M = {}
local map = vim.keymap.set

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

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

M.telescope_pick_async = require("plenary.async").wrap(function(content, opts, callback)
	vim.validate({ opts = { opts, "t" }, callback = { callback, "f" } })
	opts = opts or {}
	return M.pick(content, callback, opts)
end, 3)

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

	M.pick(names, function(value)
		menu_actions[value]()
	end)
end

map("n", "<leader><cr>", M.select)

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
map("n", "<c-m-o>", function()
	require("telescope.builtin").fd({ cwd = require("utils").find_project_root() })
end)

return M
