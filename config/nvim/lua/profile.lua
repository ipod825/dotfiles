local M = _G.profile or {}
_G.profile = M
local V = require("Vim")

M.name = "default"
M.envs = {}
M.cur_env = M

function M.register_env(opts)
	vim.validate({ env = { opts.env, "t" }, mode_mappings = { opts.mode_mappings, "t", true } })
	local env = opts.env
	local mode_mappings = opts.mode_mappings or {}
	local default_env = M
	M.envs[env.name] = env
	env.mappings = {}
	for mode, mappings in pairs(mode_mappings) do
		local saved_mappings = V.save_keymap(
			vim.tbl_map(function(e)
				return e.lhs
			end, vim.tbl_values(mappings)),
			mode
		)
		default_env.mappings = vim.tbl_extend("force", default_env.mappings, saved_mappings)
		for _, mapping in pairs(mappings) do
			mapping.mode = mode
			mapping.buffer = -1
			table.insert(env.mappings, mapping)
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
		end
		default_env.g[k] = vim.g[k] or default_val
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

function M.switch_env(env)
	if M.cur_env == env then
		return
	end
	M.cur_env = env
	local default_env = M

	-- Restore default mappings and then apply current env mappings.
	V.restore_keymap(default_env.mappings)
	V.restore_keymap(M.cur_env.mappings)

	for k, v in pairs(default_env.g) do
		vim.g[k] = v
	end
	for k, v in pairs(M.cur_env.g) do
		vim.g[k] = v
	end
end

M.register_env({ env = M })
vim.api.nvim_exec(
	[[
augroup PROFILE
    autocmd!
    autocmd BufEnter * lua vim.defer_fn(profile.auto_switch_env, 10)
augroup END
]],
	false
)

return M
