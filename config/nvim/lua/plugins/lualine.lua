local navic = prequire("nvim-navic")
return {
	"hoob3rt/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = {
					{ "branch" },
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						color_error = "#ec5f67",
						color_warn = "#fabd2f",
						color_info = "#203663",
						color_hint = "#203663",
						symbols = {
							error = "",
							warn = "",
							info = "",
							hint = "",
						},
					},
					{
						"diff",
						colored = true,
						color_added = "#ec5f67",
						color_modified = "#fabd2f",
						color_removed = "#203663",
					},
					{ navic.get_location, cond = navic.is_available or false },
				},
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "quickfix" },
		})
	end,
}
