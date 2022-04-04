local M = _G.profile or {}
_G.profile = M
local V = require("Vim")

M.name = "default"
M.envs = {}
M.cur_env = M

function M.register_env(env, mode_mappings)
	mode_mappings = mode_mappings or {}
	M.envs[env.name] = env
	env.mappings = {}
	for mode, mappings in pairs(mode_mappings) do
		local saved_mappings = V.save_keymap(
			vim.tbl_map(function(e)
				return e.lhs
			end, vim.tbl_values(mappings)),
			mode
		)
		M.mappings = vim.tbl_extend("force", M.mappings, saved_mappings)
		for _, mapping in pairs(mappings) do
			mapping.mode = mode
			mapping.buffer = -1
			table.insert(env.mappings, mapping)
		end
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
	V.restore_keymap(M.cur_env.mappings)
end

M.register_env(M)
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
