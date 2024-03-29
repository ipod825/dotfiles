local M = {}

local install_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.filereadable(install_path) == 0 then
	vim.fn.system({
		"curl",
		"-fLo",
		install_path,
		"--create-dirs",
		"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
	})
end

M.plugins_path = vim.fn.stdpath("data") .. "/site/pluggins"
M.configs = { lazy = {}, start = {} }
M.utils = {}

function M.reload(target)
	local function do_reload(t)
		local reloaded = false
		for name, _ in pairs(package.loaded) do
			if name:match(t) then
				package.loaded[name] = nil
				reloaded = true
			end
		end
		if reloaded then
			package.loaded.plugins = nil
			require("plugins")
		end
		return reloaded
	end
	return do_reload(target) or do_reload(target:gsub("^nvim-", ""))
end

function M.begin()
	vim.fn["plug#begin"](M.plugins_path)
end

function M.ends()
	vim.fn["plug#end"]()
	local errors = {}
	for _, config in pairs(M.configs.start) do
		local _, error = pcall(config)
		if error then
			table.insert(errors, error)
		end
	end
	if #errors > 0 then
		vim.notify(table.concat(errors, "\n"), vim.log.levels.WARN)
	end
end

function M.ApplyConfig(plugin_name)
	local fn = M.configs.lazy[plugin_name]
	if type(fn) == "function" then
		fn()
	end
end

local meta = {
	__call = function(_, repo, opts)
		opts = opts or vim.empty_dict()

		if opts.disable then
			return
		end

		opts["do"], opts.run = opts.run, nil
		opts["for"], opts.ft = opts.ft, nil

		vim.call("plug#", repo, opts)

		if opts.utils then
			M.utils = vim.tbl_extend("force", M.utils, opts.utils)
		end

		if type(opts.setup) == "function" then
			opts.setup()
		end

		if type(opts.config) == "function" then
			local plugin = opts.as or vim.fs.basename(repo)

			if opts["for"] == nil and opts.on == nil then
				M.configs.start[plugin] = opts.config
			else
				M.configs.lazy[plugin] = opts.config

				local user_cmd = [[ autocmd! User %s ++once lua require'vplug'.ApplyConfig('%s') ]]
				vim.cmd(user_cmd:format(plugin, plugin))
			end
		end
	end,
}

setmetatable(M, meta)
return M
