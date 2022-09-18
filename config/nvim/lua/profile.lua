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

function M.switch_env(env)
	if M.cur_env == env then
		return
	end
	M.cur_env = env
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
