local M = _G.lsp or {}
_G.lsp = M

local map = vim.keymap.set
local add_util_menu = require("fuzzy_menu").add_util_menu
local Vim = require("Vim")

function M.goto_tag_or_lsp_fn(target_fn)
	if #(vim.fn.taglist(vim.fn.expand("<cword>"))) > 0 then
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
		vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(res))
		vim.api.nvim_command("copen")
	end
end
vim.lsp.handlers["textDocument/declaration"] = M.goto_handler
vim.lsp.handlers["textDocument/definition"] = M.goto_handler
vim.lsp.handlers["textDocument/typeDefinition"] = M.goto_handler
vim.lsp.handlers["textDocument/implementation"] = M.goto_handler

function M.switch_source_header()
	local util = require("lspconfig").util
	local bufnr = 0
	local clangd_client = util.get_active_client_by_name(bufnr, "clangd")
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if clangd_client then
		clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
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
add_util_menu("LspDiagnosticOpen", {
	fn = M.lsp_diagnostic_open,
	context_fn = require("Vim").current.line_number,
})
