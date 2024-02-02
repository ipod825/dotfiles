return {
	"stevearc/conform.nvim",
	lazy=false,
	config = function()
		require("conform").setup({
			format_on_save = {
				async = true,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				borg = { "gclfmt" },
				gcl = { "gclfmt" },
				ncl = { "nclfmt" },
				piccolo = { "pyformat" },
				textpb = { "txtpbfmt" },
				javascript = { "prettierd" },
				json = { "jq" },
				["_"] = { "trim_whitespace" },
			},
			formatters = {
				gclfmt = {
					command = "gclfmt",
					args = {},
					stdin = true,
				},
				nclfmt = {
					command = "nclfmt",
					args = { "-" },
					stdin = true,
				},
				txtpbfmt = {
					command = "txtpbfmt",
					args = {},
					stdin = true,
				},
			},
		})
	end,
}
