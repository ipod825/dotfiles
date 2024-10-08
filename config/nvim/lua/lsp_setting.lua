local M = {}

local map = vim.keymap.set
local add_util_menu = require("fuzzy_menu").add_util_menu

function M.goto_tag_or_lsp_fn(target_fn)
	local active_lsp_clients = #vim.lsp.get_clients({})

	if active_lsp_clients > 0 then
		vim.cmd("TabdropPushTag")
		target_fn()
	else
		local succ, err = pcall(vim.fn.taglist, vim.fn.expand("<cword>"))
		if succ then
			vim.cmd("TabdropPushTag")
			vim.api.nvim_exec2("silent! TagTabdrop", {})
		end
	end
end

map("n", "<m-d>", function()
	M.goto_tag_or_lsp_fn(vim.lsp.buf.definition)
end)
map("n", "<m-s>", "<cmd>TabdropPopTag<cr>")

function M.goto_handler(_, res, _)
	if res == nil or vim.tbl_isempty(res) then
		print("No location found")
		return nil
	end
	-- vim.cmd("TabdropPushTag")
	local uri = res[1].uri or res[1].targetUri
	local range = res[1].range or res[1].targetRange
	vim.fn["tabdrop#tabdrop"](vim.uri_to_fname(uri), range.start.line + 1, range.start.character + 1)
	if #res > 1 then
		vim.fn.setqflist(vim.lsp.util.locations_to_items(res, "utf-8"))
		vim.api.nvim_command("copen")
	end
end

vim.lsp.handlers["textDocument/declaration"] = M.goto_handler
vim.lsp.handlers["textDocument/definition"] = M.goto_handler
vim.lsp.handlers["textDocument/typeDefinition"] = M.goto_handler
vim.lsp.handlers["textDocument/implementation"] = M.goto_handler

function M.switch_source_header()
	local bufnr = 0
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	for _, client in ipairs(vim.lsp.get_active_clients()) do
		if client.server_capabilities.switchSourceHeaderProvider then
			client.request("textDocument/switchSourceHeader", params, function(err, result)
				if err then
					error(tostring(err))
				end
				if not result then
					print("Corresponding file cannot be determined")
					return
				end
				vim.api.nvim_command("Tabdrop " .. vim.uri_to_fname(result))
			end)
			return
		end
	end
	local file = vim.fn.expand("%:p:t")
	if vim.endswith(file, ".h") then
		file = vim.fn.expand("%:p:t:r") .. ".c"
	else
		file = vim.fn.expand("%:p:t:r") .. ".h"
	end
	require("fuzzy_menu").oldfiles({ default_text = file })
end

add_util_menu("LspSourceHeader", M.switch_source_header)
add_util_menu("LspGotoImplementation", function()
	M.goto_tag_or_lsp_fn(vim.lsp.buf.implementation)
end)
add_util_menu("LspGotoDeclaration", function()
	M.goto_tag_or_lsp_fn(vim.lsp.buf.declaration)
end)

map("n", "<leader>k", vim.diagnostic.open_float)

local capabilities = vim.lsp.protocol.make_client_capabilities()
if prequire("cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

function M.set_lsp(names, options)
	options = vim.tbl_deep_extend("keep", options or {}, {
		profile = "default",
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			local lsp_signature = prequire("lsp_signature")
			if lsp_signature then
				lsp_signature.on_attach()
			end

			if client.server_capabilities.documentSymbolProvider then
				local navic = prequire("nvim-navic")
				if navic then
					navic.attach(client, bufnr)
				end
			end

			local virtualtypes = prequire("virtualtypes")
			if virtualtypes then
				virtualtypes.on_attach()
			end
		end,
	})

	if type(names) == "string" then
		names = { names }
	end

	local lspconfig = require("lspconfig")
	for _, name in ipairs(names) do
		local client = lspconfig[name]
		client.setup(options)
		client.manager.orig_try_add = client.manager.try_add
		client.manager.try_add = function(bufnr, ...)
			require("profile").auto_switch_env()
			if options.profile ~= require("profile").cur_env.name then
				return
			end
			return client.manager.orig_try_add(bufnr)
		end
	end
end

M.set_lsp("pylsp")
M.set_lsp("clangd")
M.set_lsp("gopls")
M.set_lsp("rls")
M.set_lsp("tsserver")

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
M.set_lsp("lua_ls", {
	cmd = { "lua-language-server", ('--configpath="%s/.luarc.json"'):format(vim.env.XDG_CONFIG_HOME) },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = { globals = { "vim", "describe", "it", "before_each", "after_each", "pending" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

return M
