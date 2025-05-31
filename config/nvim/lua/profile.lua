local M = {}
local utils = require("utils")

M.name = "default"
M.envs = {}
M.cur_env = M

local nil_table_value = {}

function M.register_env(opts)
	vim.validate({ env = { opts.env, "t" }, keymaps = { opts.keymaps, "t", true } })
	local env = opts.env
	local default_env = M
	M.envs[env.name] = env
	env.mappings = opts.keymaps or {}
	default_env.mappings = vim.tbl_extend("keep", default_env.mappings or {}, utils.save_keymap(env.mappings))

	env.o = env.o or {}
	default_env.o = default_env.o or {}
	for name, _ in pairs(opts.o or {}) do
		if default_env.o[name] == nil then
			default_env.o[name] = vim.o[name]
		end
	end
	env.g = env.g or {}
	default_env.g = default_env.g or {}
	for k, v in pairs(env.g) do
		local default_val
		if type(v) == "number" then
			default_val = 0
		elseif type(v) == "boolean" then
			default_val = false
		elseif type(v) == "string" then
			default_val = ""
		elseif type(v) == "table" then
			default_val = nil_table_value
		end
		default_env.g[k] = vim.g[k] or default_val
	end
end

M.handlers = {}

function M.is_in_default_env()
	return M.cur_env.name == "default"
end

function M.run_handler(name, ...)
	local handlers = M.cur_env.handlers or {}
	if handlers[name] == nil then
		vim.notify(("%s not supported in environment '%s'"):format(name, M.cur_env.name), vim.log.levels.ERROR)
		return
	end
	return handlers[name](...)
end

function M.on_switch_on()
	vim.cmd([[NeoCodeium enable]])
end

function M.on_switch_off()
	if prequire("neocodeium") then
		vim.cmd([[NeoCodeium! disable]])
	end
end

function M.switch_env(env)
	if M.cur_env == env then
		return
	end
	M.cur_env.on_switch_off()
	M.cur_env = env
	M.cur_env.on_switch_on()

	local default_env = M
	-- Restore default mappings and then apply current env mappings.
	utils.restore_keymap(default_env.mappings)
	if M.cur_env ~= default_env then
		utils.restore_keymap_with_mode_key(M.cur_env.mappings)
	end

	for k, v in pairs(default_env.g) do
		if v == nil_table_value then
			vim.g[k] = nil
		else
			vim.g[k] = v
		end
	end
	for k, v in pairs(M.cur_env.g) do
		vim.g[k] = v
	end

	for k, v in pairs(default_env.o) do
		vim.o[k] = v
	end
	for k, v in pairs(M.cur_env.o) do
		vim.o[k] = v
	end
end

function M.auto_switch_env()
	for _, env in pairs(M.envs) do
		if env.is_in and env.is_in() then
			M.switch_env(env)
			return
		end
	end
	M.switch_env(M)
end

M.register_env({ env = M })
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("PROFILE", {}),
	callback = function()
		vim.defer_fn(M.auto_switch_env, 10)
	end,
})

return M
