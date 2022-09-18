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
	for name, _ in pairs(package.loaded) do
		if name:match(target) then
			package.loaded[name] = nil
		end
	end
	package.loaded.plugins = nil
	require("plugins")
end

function M.begin()
	vim.fn["plug#begin"](M.plugins_path)
end

function M.ends()
	vim.fn["plug#end"]()
	for _, config in pairs(M.configs.start) do
		config()
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

				local user_cmd = [[ autocmd! User %s ++once lua plug.ApplyConfig('%s') ]]
				vim.cmd(user_cmd:format(plugin, plugin))
			end
		end
	end,
}

setmetatable(M, meta)
return M
