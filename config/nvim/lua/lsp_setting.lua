local M = _G.lsp or {}
_G.lsp = M

local map = vim.keymap.set
local add_util_menu = require("fuzzy_menu").add_util_menu
local Vim = require("Vim")

function M.goto_tag_or_lsp_fn(target_fn)
	local succ, tags = pcall(vim.fn.taglist, vim.fn.expand("<cword>"))
	if succ and #tags > 0 then
		vim.cmd("TabdropPushTag")
		vim.api.nvim_exec("silent! TagTabdrop", true)
	else
		target_fn()
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
	vim.cmd("TabdropPushTag")
	local uri = res[1].uri or res[1].targetUri
	local range = res[1].range or res[1].targetRange
	vim.fn["tabdrop#tabdrop"](vim.uri_to_fname(uri), range.start.line + 1, range.start.character + 1)
	if #res > 1 then
		vim.fn.setqflist(vim.lsp.util.locations_to_items(res))
		vim.api.nvim_command("copen")
	end
end
vim.lsp.handlers["textDocument/declaration"] = M.goto_handler
vim.lsp.handlers["textDocument/definition"] = M.goto_handler
vim.lsp.handlers["textDocument/typeDefinition"] = M.goto_handler
vim.lsp.handlers["textDocument/implementation"] = M.goto_handler

function M.switch_source_header()
	local bufnr = 0
	local client = vim.lsp.get_active_clients()[1]
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if client then
		client.request("textDocument/switchSourceHeader", params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				print("Corresponding file cannot be determined")
				return
			end
			vim.api.nvim_command("Tabdrop " .. vim.uri_to_fname(result))
		end, bufnr)
	else
		print("method textDocument/switchSourceHeader is not supported by any servers active on the current buffer")
	end
end
add_util_menu("LspSourceHeader", M.switch_source_header)
add_util_menu("LspHover", vim.lsp.buf.hover)
add_util_menu("LspReferences", vim.lsp.buf.references)
add_util_menu("LspIncomingCalls", vim.lsp.buf.incoming_calls)
add_util_menu("LspOutgoingCalls", vim.lsp.buf.outgoing_calls)
add_util_menu("LspRename", vim.lsp.buf.rename)
add_util_menu("LspCodeAction", vim.lsp.buf.code_action)
add_util_menu("LspSignatureHelp", vim.lsp.buf.signature_help)
add_util_menu("LspGotoImplementation", function()
	M.goto_tag_or_lsp_fn(vim.lsp.buf.implementation)
end)
add_util_menu("LspGotoDeclaration", function()
	M.goto_tag_or_lsp_fn(vim.lsp.buf.declaration)
end)

function M.lsp_diagnostic_open(line_number)
	vim.lsp.diagnostic.set_loclist()
	vim.defer_fn(function()
		vim.fn.search(string.format("|%d col", line_number), "cw")
	end, 10)
end
add_util_menu("LspDiagnosticOpen", vim.diagnostic.setloclist)

local capabilities = vim.lsp.protocol.make_client_capabilities()
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
end

function M.set_lsp(name, options)
	options = vim.tbl_deep_extend("keep", options or {}, {
		profile = "default",
		capabilities = capabilities,
		on_attach = function(client)
			require("lsp-format").on_attach(client)
			local lsp_signature = prequire("lsp_signature")
			if lsp_signature then
				lsp_signature.on_attach()
			end
		end,
	})
	local lspconfig = require("lspconfig")
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
M.set_lsp("pylsp")
M.set_lsp("clangd")
M.set_lsp("gopls")
M.set_lsp("rls")

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
M.set_lsp("sumneko_lua", {
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