local envrun = function(...)
	local args = { ... }
	return function()
		require("profile").run_handler(unpack(args))
	end
end

return {
	"folke/which-key.nvim",
	lazy = false,
	config = function()
		require("which-key").setup({
			triggers = { "<leader>" },
		})
		require("which-key").add({
			{ "<leader><leader>", group = "TransformCode" },
			{ "<leader><leader><leader>", ":TransformCode", desc = "FreeText" },
			{ "<leader><leader>d", "<cmd>TransformCode Add docstring and typings<cr>", desc = "Docstring & Typing" },
			{ "<leader><leader>i", "<cmd>TransformCode Add all missing imports/includes<cr>", desc = "Add imports" },
			{ "<leader><leader>w", "<cmd>TransformCode Fix all warnings<cr>", desc = "Fix Warnings" },
			{ "<leader>a", group = "Abolish" },
			{ "<leader>ac", "<cmd>normal crc<cr>", desc = "camelCase" },
			{ "<leader>am", "<cmd>normal crm<cr>", desc = "MixedCase" },
			{ "<leader>as", "<cmd>normal crs<cr>", desc = "snake_case" },
			{ "<leader>au", "<cmd>normal cru<cr>", desc = "SNAKE_UPPERCASE" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
			{ "<leader>la", vim.lsp.buf.code_action, desc = "CodeAction" },
			{ "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
			{ "<leader>li", vim.lsp.buf.incoming_calls, desc = "IncomingCalls" },
			{ "<leader>lo", vim.lsp.buf.outgoing_calls, desc = "OutgoingCalls" },
			{ "<leader>lr", vim.lsp.buf.references, desc = "References" },
			{ "<leader>ls", vim.lsp.buf.signature_help, desc = "SignatureHelp" },
			{ "<leader>r", group = "Related files" },
			{ "<leader>rh", require("lsp_setting").switch_source_header, desc = "Switch source header" },
			{ "<leader>rp", envrun("OpenProducerOrGraph"), desc = "Producer or Graph" },
			{ "<leader>rt", envrun("OpenSrcOrTest"), desc = "Source or Test" },
			{ "<leader>t", group = "telescope" },
			{
				"<leader>tb",
				function()
					local action_set = require("telescope.actions.set")
					require("telescope.builtin").buffers({
						previewer = false,
						ignore_current_buffer = true,
						sort_lastused = true,
						sort_mru = true,
						attach_mappings = function(_, map)
							map({ "i", "n" }, "<cr>", function(prompt_bufnr)
								action_set.edit(prompt_bufnr, "tab drop")
							end)
							return true
						end,
					})
				end,
				desc = "Find Buffers",
			},
			{ "<leader>td", "<cmd>Telescope diagnostics<cr>", desc = "diagnostics" },
			{ "<leader>ti", require("g4").handlers["InsertIssue"], desc = "Insert Issue" },
			{ "<leader>to", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
			{ "<leader>ty", "<cmd>Telescope yank_history<cr>", desc = "Yank History" },
			{ "<leader>y", group = "Copy" },
			{ "<leader>yB", envrun("CopyEnvBinary"), desc = "Binary" },
			{
				"<leader>ya",
				function()
					local path = vim.fn.expand("%:p")
					vim.fn.setreg("+", path)
					vim.fn.setreg('"', path)
				end,
				desc = "AbsPath",
			},
			{
				"<leader>yb",
				function()
					local path = vim.fn.expand("%:p:t")
					vim.fn.setreg("+", path)
					vim.fn.setreg('"', path)
				end,
				desc = "Basename",
			},
			{ "<leader>yc", envrun("CopyEnvCodeSearch"), desc = "CodeSearch" },
			{ "<leader>yp", envrun("CopyEnvPath"), desc = "Path" },
			{ "<leader>yr", envrun("CopyEnvReview"), desc = "Review" },
			{ "<leader>yt", envrun("CopyEnvTarget"), desc = "Target" },
		})
	end,
}
